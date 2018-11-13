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
    var secondsRemaining = 60
    var score = 0
    var timer: Timer! = nil
    var isTweetByTwitterOne = true
    
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
        score += wasCorrect ? 1 : -1
        
        scoreLabel.backgroundColor = wasCorrect ? UIColor.green : UIColor.red
        scoreLabel.textColor = wasCorrect ? UIColor.black : UIColor.white
    }
    
    func showNextTweet() {
        if let next = TweetRepo.instance.getNext() {
        
            isTweetByTwitterOne = next.user == SettingsRepo.instance.twitterOne
            tweetBodyLabel.text = next.text
            
            scoreLabel.text = "Score: \(score)"
        }
        else {
            spinner.startAnimating()
        }
    }
    
    @objc func tickClock() {
        secondsRemaining -= 1
        timeRemainingLabel.text = "\(secondsRemaining) seconds"
    
    timeRemainingLabel.backgroundColor = UIColor.white 
        
        
        if (secondsRemaining <= 0) {
            onEndGame();
        }
    }
    
    func onEndGame() {
        timer.invalidate()
        
        // TODO: Goto some end game screen
    }
    
    @IBAction func onSkipTweet(_ sender: Any) {
        // Cut two seconds, one manually and one
        //  as a fake clock tick, which also updates
        //  the label for us
        secondsRemaining -= 1
        tickClock()
        
        timeRemainingLabel.backgroundColor = UIColor.red
        
        showNextTweet()
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
