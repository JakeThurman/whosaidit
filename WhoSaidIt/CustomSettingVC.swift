//
//  CustomSettingVC.swift
//  WhoSaidIt
//
//  Created by Logan Stahl on 12/18/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class CustomSettingVC: UIViewController, UITextFieldDelegate {
    
    let settings = SettingsRepo.instance
    
    var twitterOne = ""
    var twitterTwo = ""
    
    @IBOutlet weak var twitterOneField: UITextField!
    
    @IBOutlet weak var twitterTwoField: UITextField!
    
    @IBAction func backgroundTap(_ sender: Any?) {
        self.view.endEditing(true)
    }
    
    @IBAction func touchTwitterField(_ sender: Any) {
        let field = sender as! UITextField
        field.becomeFirstResponder()
    }
    
    //Dismiss keyboard when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Manually declare the delegate of the text fields - needed for textFieldShouldReturn
        self.twitterOneField.delegate = self
        self.twitterTwoField.delegate = self

        twitterOneField.text = twitterOne
        twitterTwoField.text = twitterTwo
    }

}
