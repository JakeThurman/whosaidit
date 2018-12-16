//
//  TweetData.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/12/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class TweetData {
    let text: String
    let user: String
    let id: Int64
    
    init(user: String, id: Int64, text: String) {
        self.user = user
        self.id = id
        self.text = TweetData.removeUrls(text)
    }
    
    private static func removeUrls(_ input: String) -> String {
        let output = NSMutableString(string: input)
        
        if let regex = try? NSRegularExpression(pattern: "((http)s?://)?[A-Za-z0-9]+\\.[A-Za-z0-9][A-Za-z0-9]+(\\.[A-Za-z0-9]+)*[/A-Za-z0-9]*", options: .caseInsensitive)
        {
            regex.replaceMatches(in: output, options: [], range: NSRange(location: 0, length: input.count), withTemplate: "")
        }
        
        // SPECIAL CASE: If it's just a url, don't remove it.
        if (output as String).trimmingCharacters(in: .whitespaces).isEmpty {
            return input
        }
        
        return (output as String)
    }
}
