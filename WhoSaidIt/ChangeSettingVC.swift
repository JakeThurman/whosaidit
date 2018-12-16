//
//  ChangeSettingVC.swift
//  WhoSaidIt
//
//  Created by Logan Stahl on 11/14/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit
import TwitterKit

class ChangeSettingVC: UIViewController, UITextFieldDelegate {
    
    var settingValue : Any!
    var settingName = ""
    
    @IBOutlet weak var settingField: UITextField!
    @IBOutlet weak var changeSettingNavBar: UINavigationItem!
    
    @IBAction func leavingView(_ sender: Any) {
        // TODO: This function isn't called????
        
        do {
            try SettingsRepo.instance.setSettingValue(named: settingName, to: settingField.text ?? settingValue)
        }
        catch {
            print("Setting \"\(settingName)\" failed to save :(")
        }
    }
    
    @IBAction func touchNameField(_ sender: Any) {
        settingField.becomeFirstResponder()
    }
    
    //Dismiss keyboard when return button is pressed
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        settingField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Manually declare the delegate of the settingField - needed for textFieldShouldReturn
        self.settingField.delegate = self
        
        //Add gesture to dismiss keyboard when screen is tapped
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(textFieldShouldReturn(_:))))

        changeSettingNavBar.title = settingName
        settingField.text = settingValue as? String
    }

}
