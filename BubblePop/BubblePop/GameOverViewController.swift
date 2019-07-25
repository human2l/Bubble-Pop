//
//  GameOverViewController.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/4/23.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var userHighestLabel: UILabel!
    let userDefaults = UserDefaults.standard
    
    //display current score and update user's highest score
    override func viewDidLoad() {
        super.viewDidLoad()
        if SoundPlayerHandler.sharedInstance().gameGBMIsPlaying(){
            SoundPlayerHandler.sharedInstance().stopGameBGM()
        }
        SoundPlayerHandler.sharedInstance().playApplauseSound()
        SoundPlayerHandler.sharedInstance().playMenuBGM()
        userScoreLabel.text = (userDefaults.string(forKey: "userScore"))!
        let userName = userDefaults.string(forKey: "userName")!
        var userScores = userDefaults.dictionary(forKey: "userScores")!
        var highestUserScore = 0.0
        if userScores[userName] != nil{
            highestUserScore = max(userScores[userName] as! Double,userDefaults.double(forKey: "userScore"))
            userScores[userName] = highestUserScore
            userHighestLabel.text = String(format: "%.1f",highestUserScore)
        }else{
            userScores[userName] = userDefaults.double(forKey: "userScore")
            userHighestLabel.text = userDefaults.string(forKey: "userScore")
        }
        userDefaults.setValue(userScores, forKey: "userScores")
        reset()
    }
    
    //reset the current user score to 0, disable cheating
    func reset(){
        userDefaults.setValue(0.0, forKey: "userScore")
        userDefaults.setValue(false, forKey: "cheating")
    }
    
    //redirect to game view to restart the game
    @IBAction func TappingRestartButton(_ sender: Any) {
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
    }
    
    //redirect to start page view
    @IBAction func TappingHomeButton(_ sender: Any) {
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
    }
    
    //redirect to score board view
    @IBAction func TappingScoreButton(_ sender: Any) {
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
    }
    
}
