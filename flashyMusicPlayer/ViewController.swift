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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let data = ["Doomsday", "Bang The Drum All Day", "Enlightenment", "Take A Chance On Me", "Being As An Ocean - the hardest part is forgetting those you swore you would never forget (Official Music Video) (HD)"]
    var currentSong = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //checked[indexPath.row] = !checked[indexPath.row]
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.songTitle.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5,
                                       animations: {
                                        self.songTitle.transform = CGAffineTransform.identity

                        },
                                       completion: { _ in
                                        self.prepareSongAndSession(sName: self.data[indexPath.row])
                                        self.songTitle.text = self.data[indexPath.row]
                                        self.currentSong = indexPath.row
                                        self.announceSong(sName: self.data[indexPath.row])
                                        self.songPlayer.play()
                                        
                        })
                        
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
   
    // new music player
    var songPlayer = AVAudioPlayer()
 
    var spinda = false
    var isPaused = false
    
    var timeObserverToken: Any?

    @IBOutlet weak var timeLabel: UILabel!
    func prepareSongAndSession(sName : String) {
        do {
            songPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath : Bundle.main.path             (forResource:sName, ofType:"mp3")!))
            songPlayer.enableRate = true;
            songPlayer.prepareToPlay()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playback, mode: .default)
            } catch let sessionError {
                print (sessionError)
            }
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(songPlayer.currentTime/songPlayer.duration), animated: false)
        } catch let songPlayerError {
            print(songPlayerError)
        }
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        print("got the table")
       
    }

    @IBAction func play(_ sender: Any) {
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
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.songTitle.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5,
                                       animations: {
                                        self.songTitle.transform = CGAffineTransform.identity
                                        
                        },
                                       completion: { _ in
                                        self.currentSong = (self.currentSong + 1)%self.data.count
                                        self.prepareSongAndSession(sName: self.data[self.currentSong])
                                        self.announceSong(sName: self.data[self.currentSong])
                                        self.songTitle.text = self.data[self.currentSong]
                                        self.songPlayer.play()
                                        
                        })
                        
        })
        
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
    
    @objc func updateAudioProgressView()
    {
        if songPlayer.isPlaying
        {
            // Update progress
            spinda = false
            progressView.setProgress(Float(songPlayer.currentTime/songPlayer.duration), animated: true)
            timeLabel.text = String(round(songPlayer.currentTime)) + "/" + String(round(songPlayer.duration))
        } else {
            if (!spinda) {
                spinLable()
            }
            spinda = true;
        }
    }
    
    func spinLable() {
   
            
        
        }
    
    
   
}

