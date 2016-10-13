//
//   MailItemSource.swift
//  Test Mail Interactions
//
//  Created by Stanislav Sidelnikov on 10/12/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import Foundation
import UIKit

class MailItemSource: NSObject, UIActivityItemSource {
    var subject: String = ""
    var body: String = ""
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return body
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        return body
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return subject
    }
}
