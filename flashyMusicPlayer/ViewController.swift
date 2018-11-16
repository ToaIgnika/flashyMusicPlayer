//
//  ViewController.swift
//  flashyMusicPlayer
//
//  Created by Eugene Myroniuk on 2018-11-16.
//  Copyright © 2018 Eugene Myroniuk. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {
    // new music player
    var songPlayer = AVAudioPlayer()

    var isPaused = false
    
    var timeObserverToken: Any?

    @IBOutlet weak var timeLabel: UILabel!
    func prepareSongAndSession() {
        do {
            songPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath : Bundle.main.path             (forResource:"Doomsday", ofType:"mp3")!))
            songPlayer.enableRate = true;
            songPlayer.prepareToPlay()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playback, mode: .default)
            } catch let sessionError {
                print (sessionError)
            }
        } catch let songPlayerError {
            print(songPlayerError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareSongAndSession()
       
    }

    @IBAction func play(_ sender: Any) {
        announceSong(sName: "Doomsday")
        songPlayer.play()
        
    }
    
    @IBAction func pause(_ sender: Any) {
        if songPlayer.isPlaying {
            songPlayer.pause()
            isPaused = true
        } else {
            isPaused = false
        }
    }
    
    @IBAction func next(_ sender: Any) {
        print(songPlayer.currentTime)
        print(songPlayer.duration)
    }
    

    @IBAction func halfSpeed(_ sender: Any) {
        songPlayer.rate = 0.5
    }
    
    @IBAction func normSpeed(_ sender: Any) {
        songPlayer.rate = 1.0
    }
    
    @IBAction func tutorialSpeed(_ sender: Any) {
        songPlayer.rate = 2.0
    }
    
    func announceSong (sName : String) {
        let utterance = AVSpeechUtterance(string: sName)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        while (synthesizer.isSpeaking){
            
        }
    }
}

