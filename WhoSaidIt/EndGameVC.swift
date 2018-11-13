//
//  EndGameVC.swift
//  WhoSaidIt
//
//  Created by Logan Stahl on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class EndGameVC: UIViewController {
    
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
