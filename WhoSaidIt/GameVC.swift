//
//  GameVC.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/11/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    // Controls
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var twitterOne: UIButton!
    @IBOutlet weak var twitterTwo: UIButton!
    
    // Dependencies!
    /* - Tweet Repo
     * -
     */
    
    // Local state
    var secondsRemaining = 20
    var secWhenDisplayed = 0
    var timer: Timer! = nil
    var isTweetByTwitterOne = true
    
    var numCorrect = 0
    var numIncorrect = 0
    var numSkips = 0
    var scorePts = 0
    var localRank = 0
    var overallRank = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tickClock), userInfo: nil, repeats: true)
        
        twitterOne.titleLabel?.text = SettingsRepo.instance.twitterOne
        twitterTwo.titleLabel?.text = SettingsRepo.instance.twitterTwo
        
        showNextTweet()
    }
    
    @IBAction func chooseTwitterOne(_ sender: Any) {
        handleScoreChange(wasCorrect: isTweetByTwitterOne)
        
        showNextTweet()
    }
    
    @IBAction func chooseTwitterTwo(_ sender: Any) {
        handleScoreChange(wasCorrect: !isTweetByTwitterOne)
        
        showNextTweet()
    }
    
    func handleScoreChange(wasCorrect: Bool) {
        let incOrDec = wasCorrect ? 1 : -1
        
        //The longer you take, the more points you lose, the less points you gain
        let scoreChange = (incOrDec * 100) - (5 * (secWhenDisplayed-secondsRemaining))
        //Always gain at least 10 points on correct answer
        scorePts += (wasCorrect && scoreChange < 10) ? 10 : scoreChange
        
        numCorrect += wasCorrect ? 1 : 0
        numIncorrect += wasCorrect ? 0 : 1
        
        scoreLabel.backgroundColor = wasCorrect ? UIColor.green : UIColor.red
        scoreLabel.textColor = wasCorrect ? UIColor.black : UIColor.white
        
        self.scoreLabel.text = "Score: \(self.scorePts)"
    }
    
    func showNextTweet() {
        TweetRepo.instance.getNext(
            onWaiting: { self.spinner.startAnimating() },
            callback: { (next) in
                self.spinner.stopAnimating()
                
                self.isTweetByTwitterOne = next.user == SettingsRepo.instance.twitterOne
                self.tweetBodyLabel.text = next.text
                self.secWhenDisplayed = self.secondsRemaining
            })
    }
    
    @objc func tickClock() {
        secondsRemaining -= 1
        secondsRemaining = (secondsRemaining <= 0) ? 0 : secondsRemaining
        timeRemainingLabel.text = "\(secondsRemaining) seconds"
    
        timeRemainingLabel.textColor = UIColor.black
        
        if (secondsRemaining <= 0) {
            onEndGame();
        }
    }
    
    func onEndGame() {
        timer.invalidate()
        performSegue(withIdentifier: "endGameSegue", sender: nil)
    }
    
    @IBAction func onSkipTweet(_ sender: Any) {
        // Cut two seconds, one manually and one
        //  as a fake clock tick, which also updates
        //  the label for us
        secondsRemaining -= 1
        tickClock()
        
        timeRemainingLabel.textColor = UIColor.red
        
        numSkips += 1
        
        showNextTweet()
    }
    
    /*
    // MARK: - Navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let child = segue.destination as? EndGameVC {
            child.numCorrect = self.numCorrect
            child.numIncorrect = self.numIncorrect
            child.numSkips = self.numSkips
            child.scorePts = self.scorePts
            child.localRank = self.localRank
            child.overallRank = self.overallRank
        }
    }

}
