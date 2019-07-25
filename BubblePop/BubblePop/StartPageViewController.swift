//
//  StartPageViewController.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/4/19.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var ScoreButton: UIButton!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var BubblePopLabel: UIImageView!
    
    let userDefaults = UserDefaults.standard
    
    //setup userDefaults if this is the first time running
    override func viewDidLoad() {
        super.viewDidLoad()
        if !SoundPlayerHandler.sharedInstance().menuBGMIsPlaying(){
            SoundPlayerHandler.sharedInstance().playMenuBGM()
        }
        if userDefaults.value(forKey: "cheating") == nil {
            userDefaults.setValue(false, forKey: "cheating")
        }
        if userDefaults.value(forKey: "totalTime") == nil {
            userDefaults.setValue(60, forKey: "totalTime")
        }
        if userDefaults.value(forKey: "maximumBubblesPerScreen") == nil {
            userDefaults.setValue(15, forKey: "maximumBubblesPerScreen")
        }
        if userDefaults.value(forKey: "userScores") == nil {
            let userScores = [String:Double]()
            userDefaults.setValue(userScores, forKey: "userScores")
        }
    }
    
    //make the start button jump up and down
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.4,delay: 0, options:[UIViewAnimationOptions.repeat,UIViewAnimationOptions.autoreverse,UIViewAnimationOptions.curveEaseOut,UIViewAnimationOptions.allowUserInteraction],
            animations: {
                self.StartButton.transform = CGAffineTransform(translationX: 0, y: -40)
        })
    }
    
    /*
     after tapping start button
     pop up dialog to ask user input name if they haven't
     */
    @IBAction func TappedStartButton(_ sender: Any) {
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
        if NameLabel.text == "" || NameLabel.text == " "{
            let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Input your name here..."
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                if let name = alert.textFields?.first?.text{
                    self.NameLabel.text = name
                }
            }))
            self.present(alert, animated: true)
        }else{
            userDefaults.setValue(NameLabel.text, forKey: "userName")
            self.performSegue(withIdentifier: "StartGame", sender: sender)
        }
    }
    
    /*
     redirect scoreview
     Note: enable cheating model when both score and settings button tapped
     */
    @IBAction func TappedScoreButton(_ sender: Any) {
        if SettingsButton.isTouchInside{
            userDefaults.setValue(true, forKey: "cheating")
            SoundPlayerHandler.sharedInstance().playCheatingSound()
        }
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
        self.performSegue(withIdentifier: "ScoreBoard", sender: self)
        
    }
    
    /*
     redirect to settings view
     Note: enable cheating model when both score and settings button tapped
     */
    @IBAction func TappedSettingsButton(_ sender: Any) {
        if ScoreButton.isTouchInside{
            userDefaults.setValue(true, forKey: "cheating")
            SoundPlayerHandler.sharedInstance().playCheatingSound()
        }
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
        self.performSegue(withIdentifier: "Settings", sender: self)
        
    }
    
    //when keyboard is opening, touch outside field to close keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
