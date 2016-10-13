//
//  ViewController.swift
//  Test Mail Interactions
//
//  Created by Stanislav Sidelnikov on 10/12/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import UIKit
import MessageUI // For MFMailComposeViewController

class ViewController: UIViewController {
    @IBOutlet weak var urlSchemeNameLabel: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    fileprivate let subject = "Test email"
    fileprivate let mailTo = "example@non-existing-domain.comm"
    fileprivate let body = "This is a test mail sent from the test app for testing sending mails from iOS."

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func sendUsingMFMailComposeVC(_ sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailTo])
            mail.setMessageBody(body, isHTML: false)
            mail.setSubject(subject)
            
            present(mail, animated: true)
        } else {
            error("Cannot send email")
        }
    }
    
    @IBAction func sendUsingUrlScheme(_ sender: AnyObject) {
        // http://stackoverflow.com/questions/25604552/i-have-real-misunderstanding-with-mfmailcomposeviewcontroller-in-swift-ios8-in/25864182#25864182
        // Other schemes: http://stackoverflow.com/questions/32114455/open-gmail-app-from-my-app http://handleopenurl.com/scheme/yandex.mail
        guard let scheme = urlSchemeNameLabel.text else {
            error("Scheme is not set. Cannot send the mail")
            return
        }
        
        guard let emailURL = prepareUrl(forScheme: scheme) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        } else {
            error("Cannot open URL: \(emailURL.absoluteString)")
        }
    }
    
    @IBAction func sendUsingActivityVC(_ sender: AnyObject) {
        guard let emailURL = prepareUrl(forScheme: "mailto") else {
            return
        }
        let mailItem = MailItemSource()
        mailItem.body = body
        mailItem.subject = subject
        let activityViewController = UIActivityViewController(activityItems: [subject, mailItem], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .airDrop, .assignToContact, .copyToPasteboard,
                                                        .message, .openInIBooks, .postToFacebook, .postToFacebook,
                                                        .postToTencentWeibo, .postToTwitter, .postToVimeo,
                                                        .postToWeibo, .print, .saveToCameraRoll]
        present(activityViewController, animated: true, completion: nil)
    }
    
    fileprivate func prepareUrl(forScheme scheme: String) -> URL? {
        let plainString = "\(scheme):\(mailTo)?subject=\(subject)&body=\(body)"
        guard let urlString = plainString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            error("Cannot URL-fy string \(plainString)")
            return nil
        }
        if let emailURL = URL(string: urlString) {
            return emailURL
        } else {
            error("Cannot build URL from string: \(urlString)")
            return nil
        }
    }
    
    fileprivate func error(_ text: String?) {
        infoLabel.textColor = UIColor.red
        infoLabel.text = text
    }
    
    fileprivate func info(_ text: String?) {
        infoLabel.textColor = UIColor.black
        infoLabel.text = text
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            self.info("Message sent")
        case .saved:
            self.info("Message saved")
        case .cancelled:
            self.info("Message sending cancelled")
        case .failed:
            self.error("Message sending failed. Error: \(error?.localizedDescription)")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
