//
//  EndGameVC.swift
//  WhoSaidIt
//
//  Created by Logan Stahl on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class EndGameVC: UIViewController {
    
    @objc var numCorrect = 0
    @objc var numIncorrect = 0
    @objc var numSkips = 0
    @objc var scorePts = 0
    @objc var localRank = 0
    @objc var overallRank = 0
    
    @IBOutlet weak var numCorrectLbl: UILabel!
    @IBOutlet weak var numIncorrectLbl: UILabel!
    @IBOutlet weak var numSkipsLbl: UILabel!
    @IBOutlet weak var scorePtsLbl: UILabel!
    @IBOutlet weak var localRankLbl: UILabel!
    @IBOutlet weak var overallRankLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numCorrectLbl.text = String(numCorrect)
        numIncorrectLbl.text = String(numIncorrect)
        numSkipsLbl.text = String(numSkips)
        scorePtsLbl.text = String(scorePts)
        localRankLbl.text = String(localRank)
        overallRankLbl.text = String(overallRank)
    }
    
}
