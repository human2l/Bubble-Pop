//
//  SplashScreenViewController.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/5/6.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    var redirectTimer = Timer()
    var displayTime = 3
    
    //set a timer to give enough time to show the information
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleRedirect), userInfo: nil, repeats: true)
    }
    
    //after 3 seconds passed, redirect to start page
    @objc func handleRedirect(){
        displayTime -= 1
        print(displayTime)
        if displayTime == 0{
            redirectTimer.invalidate()
            self.performSegue(withIdentifier: "StartPage", sender: self)
        }
    }

}
