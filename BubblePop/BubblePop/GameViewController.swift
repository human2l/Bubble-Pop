//
//  GameViewController.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/4/19.
//  Copyright © 2018年 UTS. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    @IBOutlet weak var countDownImage3: UIImageView!
    @IBOutlet weak var countDownImage2: UIImageView!
    @IBOutlet weak var countDownImage1: UIImageView!
    @IBOutlet weak var InformationStack: UIStackView!
    @IBOutlet weak var TimeLeftLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    var userName:String?
    var userScore:Double?
    var highScore:Int?
    var totalTime:Int?
    var timeLeft:Int?
    var countDownTimeLeft:Int?
    var maximumBubblesPerScreen:Int?
    var userScores:[String:Double]?
    var sortedScores:[(key:String,value:Double)]?
    var bubbleFieldMinY:Int?
    var bubbleFieldMinX:Int?
    var bubbleFieldMaxY:Int?
    var bubbleFieldMaxX:Int?
    var bubbleSafeAreaMinY:Int?
    var bubbleSafeAreaMinX:Int?
    var bubbleSafeAreaMaxY:Int?
    var bubbleSafeAreaMaxX:Int?
    var bubbleWidth:Int?
    var bubbleHeight:Int?
    var minDistanceBetweenBubblesSquare:Double?
    var timer = Timer()
    var countDownTimer = Timer()
    var bubbles = [Bubble]()
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var previousBubble:Bubble?
    
    //start the count down effects
    override func viewWillAppear(_ animated: Bool) {
        if SoundPlayerHandler.sharedInstance().menuBGMIsPlaying(){
            SoundPlayerHandler.sharedInstance().stopMenuBGM()
        }
        countDownImage3.isHidden = true
        countDownImage2.isHidden = true
        countDownImage1.isHidden = true
        countDownTimeLeft = 5
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    //display different image when counting down
    @objc func countDown(){
        countDownTimeLeft! -= 1
        switch countDownTimeLeft {
        case 4:
            countDownImage3.isHidden = false
            SoundPlayerHandler.sharedInstance().playCountSound()
        case 3:
            countDownImage3.isHidden = true
            countDownImage2.isHidden = false
            SoundPlayerHandler.sharedInstance().playCountSound()
        case 2:
            countDownImage2.isHidden = true
            countDownImage1.isHidden = false
            SoundPlayerHandler.sharedInstance().playCountSound()
        case 1:
            countDownImage1.isHidden = true
            SoundPlayerHandler.sharedInstance().playCountStartSound()
            countDownTimer.invalidate()
            gameStart()
        default:
            ()
        }
    }
    
    //calculate field size to create bubble
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleFieldMinX = 0
        bubbleFieldMinY = (Int)(InformationStack.frame.maxY)
        bubbleFieldMaxX = (Int)(self.view.frame.maxX)
        bubbleFieldMaxY = (Int)(self.view.frame.maxY)
        //width and height set to <85 is safe for most devices.
        //set to 75 to suit iphone SE
        if bubbleFieldMaxX! > 350 && bubbleFieldMaxY! > 600{
            bubbleWidth = 80
            bubbleHeight = 80
        }else{
            bubbleWidth = 75
            bubbleHeight = 75
        }
        bubbleSafeAreaMinX = bubbleFieldMinX!
        bubbleSafeAreaMaxX = bubbleFieldMaxX! - bubbleWidth!
        bubbleSafeAreaMinY = bubbleFieldMinY!
        bubbleSafeAreaMaxY = bubbleFieldMaxY! - bubbleHeight!
        minDistanceBetweenBubblesSquare = (Double)(bubbleWidth!*bubbleHeight!)
        userName = userDefaults.string(forKey: "userName")
        maximumBubblesPerScreen = (userDefaults.integer(forKey: "maximumBubblesPerScreen"))
        showScoreInfo()
    }
    
    //display score information to the top of view
    func showScoreInfo(){
        if (userDefaults.bool(forKey: "cheating")){
            userScore = 100
            ScoreLabel.text = "100.0"
        }else{
            userScore = userDefaults.double(forKey: "userScore")
            ScoreLabel.text = "0.0"
        }
        userScores = userDefaults.dictionary(forKey: "userScores") as? [String : Double]
        sortedScores = userScores!.sorted(by:{$0.value > $1.value})
        if !userScores!.isEmpty{
            HighScoreLabel.text = String(format: "%.1f", (sortedScores!.first!.value))
        }
    }
    
    //start to create bubbles
    func gameStart(){
        SoundPlayerHandler.sharedInstance().playGameBGM()
        gameTimerStart()
        let totalBubblesNumber = (Int)(arc4random_uniform(UInt32(maximumBubblesPerScreen!))+1)
        createBubbles(amount:totalBubblesNumber)
    }
    
    //start game timer
    func gameTimerStart(){
        totalTime = userDefaults.integer(forKey: "totalTime")
        timeLeft = totalTime
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ticTok), userInfo: nil, repeats: true)
    }
    
    /*
     handle events on each second passed
     after timer counts to zero, redirect to game over view
     */
    @objc func ticTok(){
        timeLeft = timeLeft! - 1
        TimeLeftLabel.text = (String)(timeLeft!)
        changeBubbleAtIntervals()
        if !SoundPlayerHandler.sharedInstance().gameGBMIsPlaying(){
            SoundPlayerHandler.sharedInstance().playGameBGM()
        }
        if(timeLeft == 0){
            userDefaults.setValue(ScoreLabel.text!, forKey: "userScore")
            self.performSegue(withIdentifier: "GameOver", sender: nil)
            timer.invalidate()
        }
    }
    
    //on each second game passed, remove some bubbles and create some new bubbles
    func changeBubbleAtIntervals(){
        var onRemovingBubble:Bubble!
        if(bubbles.count > 0){
            //remove bubbles which are less than half of total number of bubbles
            let removeBubblesCount = (Int)(arc4random_uniform(UInt32(bubbles.count))/2+1)
            for index in 0..<removeBubblesCount {
                onRemovingBubble = bubbles[index]
                fadeOut(view:onRemovingBubble,duration: 0.5, completion: {_ in self.bubbles.removeFirst().removeFromSuperview()})
            }
            //create new bubbles which are as same amount as removed bubbles
            for _ in 0..<removeBubblesCount {
                createBubble()
            }
            //if the amount of bubbles is less than half of maximum, create that amount of bubbles
            if(bubbles.count <= maximumBubblesPerScreen!/2){
                createBubbles(amount: maximumBubblesPerScreen!/2)
            }
        }else{
            //create bubbles when there is no bubble on the screen
            let totalBubblesNumber = (Int)(arc4random_uniform(UInt32(maximumBubblesPerScreen!))+1)
            createBubbles(amount:totalBubblesNumber)
        }
    }
    
    //create bubbles by amount
    func createBubbles(amount:Int){
        if amount == 0 {
            return
        }
        for _ in 1...amount {
            createBubble()
        }
    }
    
    //create single bubble
    func createBubble(){
        var overlap = true
        var randomX:Int?
        var randomY:Int?
        while overlap{
            randomX = (Int)((Double)(arc4random_uniform(101))/100*(Double)(bubbleSafeAreaMaxX!-bubbleSafeAreaMinX!)+(Double)(bubbleSafeAreaMinX!))
            randomY = (Int)((Double)(arc4random_uniform(101))/100*(Double)(bubbleSafeAreaMaxY!-bubbleSafeAreaMinY!)+(Double)(bubbleSafeAreaMinY!))
            overlap = checkOverlap(newBubbleX: randomX!, newBubbleY: randomY!, bubbles: bubbles)
        }
        let bubble = Bubble()
        bubble.frame = CGRect(x:randomX!,y:randomY!,width:bubbleWidth!, height:bubbleHeight!)
        //set the property of bubble according to the appearance ratio
        switch arc4random_uniform(101) {
        case 0...40:
            bubble.bubbleType = "red"
            bubble.bubbleScore = 1
        case 41...70:
            bubble.bubbleType = "pink"
            bubble.bubbleScore = 2
        case 71...85:
            bubble.bubbleType = "green"
            bubble.bubbleScore = 5
        case 86...95:
            bubble.bubbleType = "blue"
            bubble.bubbleScore = 8
        case 96...100:
            bubble.bubbleType = "black"
            bubble.bubbleScore = 10
        default:
            ()
        }
        let bgImage = UIImage(named: bubble.bubbleType!+"-bubble")
        bubble.setBackgroundImage(bgImage, for: .normal)
        bubble.addTarget(self, action: #selector(onTappingBubble(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(bubble)
        bubbles.append(bubble)
        fadeIn(view:bubble,duration: 0.5 ,completion:{ _ in })
    }
    
    //fade in function apply to bubble creation
    func fadeIn(view:UIView,duration:Double,completion:@escaping (Bool)->Void){
        UIView.animate(withDuration: 0, delay:0,  animations: {
            view.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: duration, delay:0,options:  UIViewAnimationOptions.allowUserInteraction , animations: {
            view.alpha = 1
        }, completion: completion)
    }
    
    //fade out function apply to bubble remove
    func fadeOut(view:UIView, duration:Double, completion:@escaping (Bool)->Void){
        UIView.animate(withDuration: 0, delay:0,  animations: {
            view.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: duration, delay:0,options: UIViewAnimationOptions.allowUserInteraction, animations: {
            view.alpha = 0
        }, completion: completion)
    }
    
    //check if the input xy could create a bubble overlap with exist bubbles
    func checkOverlap(newBubbleX:Int,newBubbleY:Int,bubbles:[Bubble])->Bool{
        if(bubbles.isEmpty){
            return false
        }else{
            for bubble in bubbles{
                let posX = (Double)(bubble.frame.minX)
                let posY = (Double)(bubble.frame.minY)
                let distanceSquare = (posX - (Double)(newBubbleX))*(posX - (Double)(newBubbleX))+(posY - (Double)(newBubbleY))*(posY - (Double)(newBubbleY))
                if(distanceSquare < minDistanceBetweenBubblesSquare!){
                    return true
                }
            }
            return false
        }
    }
    
    //handle event if user tapped on of the bubble on the screen
    @objc func onTappingBubble(_ bubble:Bubble){
        let bubbleScore = onAddingScore(bubble)
        onBubbleBroken(bubble:bubble,bubbleScore:bubbleScore)
        SoundPlayerHandler.sharedInstance().playBubblePopSound()
        //vibrate when bubble tapped
        lightImpactFeedbackGenerator.prepare()
        lightImpactFeedbackGenerator.impactOccurred()
    }
    
    //handle broken animation after a bubble been tapped
    func onBubbleBroken(bubble:Bubble,bubbleScore:Double){
        UIView.animate(withDuration: 0.1, animations: {
            bubble.alpha = 0
            bubble.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }, completion: {_ in self.removeBubble(bubble)})
        showBubbleScore(bubble:bubble,bubbleScore:bubbleScore)
    }
    
    //after a bubble broken, the score of current bubble would pop up
    func showBubbleScore(bubble:Bubble,bubbleScore:Double){
        let bubbleScoreLabel = UILabel()
        bubbleScoreLabel.frame = CGRect(x:bubble.frame.minX,y:bubble.frame.minY,width:CGFloat(bubbleWidth!), height:CGFloat(bubbleHeight!))
        bubbleScoreLabel.textAlignment = NSTextAlignment.center
        bubbleScoreLabel.text = "+\(bubbleScore)"
        bubbleScoreLabel.textColor = .yellow
        bubbleScoreLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        bubbleScoreLabel.font = bubbleScoreLabel.font.withSize(CGFloat(25))
        self.view.addSubview(bubbleScoreLabel)
        UIView.animate(withDuration: 0.8,delay:0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let moveUp  = CGAffineTransform(translationX: 0, y: -20)
            bubbleScoreLabel.transform = moveUp
        }) { _ in}
        fadeOut(view: bubbleScoreLabel,duration:0.8, completion: { _ in bubbleScoreLabel.removeFromSuperview()})
    }
    
    //remove bubble from bubbles array, and remove from superview as well
    func removeBubble(_ bubble:Bubble){
        for index in 0..<bubbles.count {
            if(bubbles[index] == bubble){
                bubbles[index].removeFromSuperview()
                bubbles.remove(at: index)
                break;
            }
        }
    }
    
    //remove all bubbles, for now just for testing use
    func removeAllBubbles(){
        for index in 0..<bubbles.count {
            bubbles[index].removeFromSuperview()
        }
        bubbles.removeAll()
    }
    
    //calculate the score of current bubble
    func onAddingScore(_ bubble:Bubble)->Double{
        let bubbleScore = bubble.bubbleScore! * getScoreRatio(bubble)
        userScore = (Double)(ScoreLabel.text!)! + bubbleScore
        ScoreLabel.text = String(format: "%.1f", userScore!)
        return bubbleScore
    }
    
    //calculate the score ratio of current bubble
    func getScoreRatio(_ bubble:Bubble)->Double{
        if let pb = previousBubble {
            if pb.bubbleType == bubble.bubbleType{
                return 1.5
            }else{
                previousBubble = bubble
                return 1
            }
        }else{
            previousBubble = bubble
            return 1
        }
    }
}
