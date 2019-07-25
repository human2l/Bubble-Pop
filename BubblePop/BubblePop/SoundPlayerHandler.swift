//
//  PlayerHandler.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/4/29.
//  Copyright © 2018年 UTS. All rights reserved.
//

import Foundation

class SoundPlayerHandler{
    private static var mInstance:SoundPlayerHandler?
    private var playerArray = [SoundPlayer("pop1"),SoundPlayer("pop2"),SoundPlayer("pop3")]
    private var menuPlayer = SoundPlayer("menu")
    private var gamePlayer = SoundPlayer("game")
    private var applauseSoundPlayer = SoundPlayer("applause")
    private var cheatingPlayer = SoundPlayer("cheating")
    private var countDownPlayer = [SoundPlayer("count"),SoundPlayer("count-start")]
    
    static func sharedInstance()->SoundPlayerHandler{
        if mInstance == nil{
            mInstance = SoundPlayerHandler()
        }
        return mInstance!
    }
    
    //setup suitable volume of each music player
    private init(){
        menuPlayer.audioPlayer.setVolume(1, fadeDuration: 0)
        for player in playerArray{
            player.audioPlayer.setVolume(5, fadeDuration: 0)
        }
        gamePlayer.audioPlayer.setVolume(1, fadeDuration: 0)
        applauseSoundPlayer.audioPlayer.setVolume(1, fadeDuration: 0)
        cheatingPlayer.audioPlayer.setVolume(1, fadeDuration: 0)
        for player in countDownPlayer{
            player.audioPlayer.setVolume(5, fadeDuration: 0)
        }
    }
    
    //randomly play 1 of 3 different pop sounds
    func playBubblePopSound(){
        let index = (Int)(arc4random_uniform(UInt32(3)))
        if playerArray[index].audioPlayer.isPlaying{
            if index+1 < playerArray.count{
                playerArray[index+1].audioPlayer.play()
            }else{
                playerArray[index-1].audioPlayer.play()
            }
        }else{
            playerArray[index].audioPlayer.play()
        }
    }
    func playMenuBGM(){
        menuPlayer.audioPlayer.play()
        
    }
    func stopMenuBGM(){
        menuPlayer.audioPlayer.currentTime = 0
        menuPlayer.audioPlayer.stop()
        menuPlayer.audioPlayer.prepareToPlay()
    }
    func menuBGMIsPlaying()->Bool{
        return menuPlayer.audioPlayer.isPlaying
    }
    func playGameBGM(){
        gamePlayer.audioPlayer.play()
    }
    func stopGameBGM(){
        gamePlayer.audioPlayer.currentTime = 0
        gamePlayer.audioPlayer.stop()
        gamePlayer.audioPlayer.prepareToPlay()
    }
    func gameGBMIsPlaying()->Bool{
        return gamePlayer.audioPlayer.isPlaying
    }
    func playApplauseSound(){
        applauseSoundPlayer.audioPlayer.play()
    }
    func playCheatingSound(){
        cheatingPlayer.audioPlayer.play()
    }
    func playCountSound(){
        countDownPlayer[0].audioPlayer.currentTime = 0
        countDownPlayer[0].audioPlayer.play()
    }
    func playCountStartSound(){
        countDownPlayer[1].audioPlayer.play()
    }
}
