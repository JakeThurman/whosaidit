//
//  EndGameVC.swift
//  WhoSaidIt
//
//  Created by Logan Stahl on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class EndGameVC: UIViewController, UITextFieldDelegate {
    
    let leaderboard = LeaderboardRepo.instance
    
    var name = ""
    var numCorrect = 0
    var numIncorrect = 0
    var numSkips = 0
    var scorePts = 0
    var localRank = 0
    var overallRank = 0
    
    @IBOutlet weak var numCorrectLbl: UILabel!
    @IBOutlet weak var numIncorrectLbl: UILabel!
    @IBOutlet weak var numSkipsLbl: UILabel!
    @IBOutlet weak var scorePtsLbl: UILabel!
    @IBOutlet weak var localRankLbl: UILabel!
    @IBOutlet weak var overallRankLbl: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBAction func leavingView(_ sender: Any) {
        addToLeaderboard()
    }
    
    @IBAction func touchNameField(_ sender: Any) {
        nameField.becomeFirstResponder()
    }
    
    //Dismiss keyboard when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Manually declare the delegate of the nameField - needed for textFieldShouldReturn
        self.nameField.delegate = self
        
        //Add gesture to dismiss keyboard when screen is tapped
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:))))
        
        //Set name to the most recent name used if it exists
        if let prevName = (leaderboard.data.sorted(by: {$0.date < $1.date}).first?.name){
            name = prevName
        }
        
        nameField.text = name
        numCorrectLbl.text = String(numCorrect)
        numIncorrectLbl.text = String(numIncorrect)
        numSkipsLbl.text = String(numSkips)
        scorePtsLbl.text = String(scorePts)
        localRankLbl.text = String(localRank)
        overallRankLbl.text = String(overallRank)
    }
    
    func addToLeaderboard(){
        if name.isEmpty {
            leaderboard.addRanking(score: scorePts, name: "User", date: Date())
        }
        else{
            leaderboard.addRanking(score: scorePts, name: name, date: Date())
        }
    }
    
    
}
