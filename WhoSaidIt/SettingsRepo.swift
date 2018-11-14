//
//  SettingsRepo.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/12/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

enum MyError: Error {
    case badSettingNameError(String)
}

class SettingsRepo: NSObject {
    static let instance = SettingsRepo()
    
    let fileUrl: URL?
    @objc dynamic var data: [Setting]
    
    // Warning: obsolete
    var twitterOne: String
    var twitterTwo: String
    
    private override init() {
        // Warning: obsolete
        twitterOne = "@cnn"
        twitterTwo = "@theonion"
        
        data = [Setting]()
        let path = Bundle.main.path(forResource: "settings", ofType: "json")
        if let filePath = path {
            fileUrl = URL(fileURLWithPath: filePath)
        }
        else {
            fileUrl = nil
        }
        
        super.init()
        
        addObserver(self, forKeyPath: "data", options: .new, context: nil)
        
        do {
            if let url = fileUrl {
                // Grab JSON contents
                let contents = try Data(contentsOf: url)
                let settingArray = try JSONSerialization.jsonObject(with: contents, options: .mutableContainers) as! [[String: Any]]
                
                // Append each ranking to the array
                for setting in settingArray {
                    let temp = Setting()
                    
                    for (key, value) in setting {
                        if Setting.fields.contains(key) {
                            temp.setValue(value, forKey: key)
                        }
                    }
                    
                    data.append(temp)
                }
                
                // Sort by the specified order
                data.sort {
                    return $0.order < $1.order
                }
            }
            else {
                print("Bad file path")
            }
        } catch {
            print("Error getting file info")
        }
    }
    
    // Write JSON to file when settings change
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Create array of dictionaries from the array of rankings so it can be written as JSON
        var jsonData = [[String: Any]]()
        for setting in data {
            jsonData.append(setting.toDictionary())
        }
        
        if let file = fileUrl {
            do {
                let contents = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                try contents.write(to: file)
            } catch {
                print("Failed to write")
            }
        }
    }
    
    // Remove self as observer when closing
    deinit {
        removeObserver(self, forKeyPath: "data")
    }
    
    // Returns the value for a setting given the setting name
    // Throws an error when the setting name doesn't exist
    func getSettingValue(settingName: String) throws -> Any {
        for setting in data {
            if setting.name == settingName {
                return setting.value
            }
        }
        
        throw MyError.badSettingNameError("'\(settingName)' is not a valid setting")
    }
}
