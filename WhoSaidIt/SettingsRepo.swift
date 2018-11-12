//
//  SettingsRepo.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/12/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class SettingsRepo {
    static let instance = SettingsRepo()
    
    var twitterOne: String
    var twitterTwo: String
    
    private init() {
        // TODO: Store these in a file
        twitterOne = "@cnn"
        twitterTwo = "@theonion"
    }
}
