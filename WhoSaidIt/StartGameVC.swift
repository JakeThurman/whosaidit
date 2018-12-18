//
//  StartGameVC.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/11/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class StartGameVC: UIViewController {
    
    let settings = SettingsRepo.instance
    
    var shouldStartGame = false
    
    @IBOutlet weak var twitterOneLbl: UILabel!
    @IBOutlet weak var twitterTwoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Segue is only available when view has appeared
        if shouldStartGame {
            performSegue(withIdentifier: "gameSegue", sender: nil)
        }
        
        twitterOneLbl.text = SettingsRepo.instance.twitterOne
        twitterTwoLbl.text = SettingsRepo.instance.twitterTwo
    }
    
    @IBAction func unwindToStartGame(segue: UIStoryboardSegue) {
        shouldStartGame = false
    }
    
    @IBAction func restartGame(segue: UIStoryboardSegue){
        shouldStartGame = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
