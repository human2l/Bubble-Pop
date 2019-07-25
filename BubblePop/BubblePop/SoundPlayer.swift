//
//  SoundEffectsHandler.swift
//  BubblePop
//
//  Created by 邱凯 on 2018/4/29.
//  Copyright © 2018年 UTS. All rights reserved.
//
//  Music source:
//  https://opengameart.org/content/happy-bgm-pianoviolinflutedrums
//  https://opengameart.org/content/sea-travel-music-benvenuta-estate-mazurka-short-loop
//  https://opengameart.org

import Foundation
import AVFoundation
class SoundPlayer {
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    init(_ soundName:String){
            switch soundName {
            case "pop1":
                createSoundPlayer("pop1", "m4a")
            case "pop2":
                createSoundPlayer("pop2", "m4a")
            case "pop3":
                createSoundPlayer("pop3", "m4a")
            case "menu":
                createSoundPlayer("menu", "mp3")
            case "game":
                createSoundPlayer("game", "mp3")
            case "applause":
                createSoundPlayer("applause", "wav")
            case "cheating":
                createSoundPlayer("cheating", "mp3")
            case "count":
                createSoundPlayer("count", "wav")
            case "count-start":
                createSoundPlayer("count-start", "wav")
            default:
                self.audioPlayer = AVAudioPlayer()
            }
    }
    
    //create AVAudioPlayer by resource
    func createSoundPlayer(_ resourceName:String,_ resourceType:String){
        let nsurl = NSURL(fileURLWithPath: Bundle.main.path(forResource: resourceName, ofType: resourceType)!)
        do{
            try self.audioPlayer = AVAudioPlayer(contentsOf: nsurl as URL)
        }catch{
            print(error)
        }
        audioPlayer.prepareToPlay()
    }
}
