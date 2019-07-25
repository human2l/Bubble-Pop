//
//  ScoreViewController.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/4/19.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var emptyLable: UILabel!
    @IBOutlet weak var scoreTableView: UITableView!
    var currentScore:Int?
    let userDefaults = UserDefaults.standard
    var userScores:[String:Double]?
    var sortedScores:[(key:String,value:Double)]?
    
    //sort the value of userScores dictionary, show placeholder: Empty if needed
    override func viewDidLoad() {
        super.viewDidLoad()
        userScores = userDefaults.dictionary(forKey: "userScores") as? [String : Double]
        sortedScores = userScores!.sorted(by:{$0.value > $1.value})
        if userScores!.count == 0{
            scoreTableView.isHidden = true
            emptyLable.isHidden = false
        }else{
            scoreTableView.isHidden = false
            emptyLable.isHidden = true
        }
    }
    
    //return the size of score table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScores!.count
    }
    
    //using predefined cell model to fill all the table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = String(indexPath.row+1)+": \(sortedScores![indexPath.row].key) \(sortedScores![indexPath.row].value)"
        return cell
        
    }
    
    //redirect to start page view
    @IBAction func TappingHomeButton(_ sender: Any) {
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
    }
}
