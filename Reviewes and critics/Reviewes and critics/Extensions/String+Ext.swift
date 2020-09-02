//
//  String+Ext.swift
//  Reviewes and critics
//
//  Created by Ivan on 02.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

extension String {
    /// Using regular expressions is not a correct approach for converting HTML to text, there are many pitfalls, like handling <style> and <script> tags. On platforms that support Foundation, one alternative is to use NSAttributedString's basic HTML support. Care must be taken to handle extraneous newlines and object replacement characters left over from the conversion process. It is a good idea to cache complex generated NSAttributedStrings either through storage or NSCache.
    func convertHTMLStringToAttributed(fontName: String? = nil,
                                       fontSize: CGFloat? = nil) -> NSMutableAttributedString? {
        var htmlString = self
        if let fontName = fontName, let fontSize = fontSize {
            htmlString = String(
                format: "<span style=\"font-family: '\(fontName)'; font-size: \(fontSize)\">%@</span>",
                self
            )
        }
        let options = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
            ] as [NSAttributedString.DocumentReadingOptionKey: Any]
        if let htmlData = htmlString.data(using: .unicode, allowLossyConversion: true) {
            let attributedString = try? NSMutableAttributedString(data: htmlData,
                                                                  options: options,
                                                                  documentAttributes: nil)
            return attributedString
        }
        return nil
    }
    
}
