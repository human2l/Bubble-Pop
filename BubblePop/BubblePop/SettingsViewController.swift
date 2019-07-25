//
//  SettingsViewController.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/4/26.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubblesLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var bubblesSlider: UISlider!
    let userDefaults = UserDefaults.standard
    
    //updating timeLabel when user change value of slider
    @IBAction func timeSlider(_ sender: UISlider) {
        timeLabel.text = String(Int(sender.value))
    }
    
    //updating bubblesLabel when user change value of slider
    @IBAction func bubblesSlider(_ sender: UISlider) {
        bubblesLabel.text = String(Int(sender.value))
    }
    
    //set correct value to controls
    override func viewDidLoad() {
        super.viewDidLoad()
        timeSlider.value = userDefaults.float(forKey: "totalTime")
        timeLabel.text = String(Int(timeSlider.value))
        bubblesSlider.value = userDefaults.float(forKey: "maximumBubblesPerScreen")
        bubblesLabel.text = String(Int(bubblesSlider.value))
    }
    
    //before redirection, update game settings in UserDefaults
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        userDefaults.setValue(Int(timeLabel.text!), forKey: "totalTime")
        userDefaults.setValue(Int(bubblesLabel.text!), forKey: "maximumBubblesPerScreen")
    }
    
    //redirect to start page view
    @IBAction func TappingHomeButton(_ sender: Any) {
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
    }
}
