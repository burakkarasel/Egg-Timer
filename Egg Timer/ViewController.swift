//
//  ViewController.swift
//  Egg Timer
//
//  Created by Burak Karasel on 6.08.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player : AVAudioPlayer?
    var timer = Timer()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Soft 5 min, Medium 8 min, Hard 12 min
    
    let hardnessTimes : [String:Int] = [
        "Soft": 5,
        "Medium": 8,
        "Hard": 12,
    ]
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let hardnessType = sender.titleLabel?.text else {return}
        guard let duration = hardnessTimes[hardnessType] else {return}
        
        // invalidating the timer here so we don't start timer for each key press
        timer.invalidate()
        titleLabel.text = hardnessType
        // finally start the count down
        countDown(minutes: duration)
    }
    
    func countDown(minutes: Int) {
        var timeRemaining = minutes * 60
        // here we set the time with new timer instance
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)  { (Timer) in
            if timeRemaining > 0 {
                timeRemaining -= 1
                let progress : Float = 1 - Float(timeRemaining) / Float(minutes * 60)
                self.progressBar.setProgress(progress, animated: true)
            }else {
                Timer.invalidate()
                self.titleLabel.text = "Done!"
                self.progressBar.setProgress(1.0, animated: true)
                self.playAlarmSound()
            }
        }
    }
    
    func playAlarmSound() {
        // Build the url for the sound file
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {return}
        do {
            // we use the singleton AVAudioSession instance through our app lifesycle
            // here we set the session as playback so we can still play sounds while iOS app is in silence mode
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            // here we activate the AVAudioSession with categories we specified by setting it true
            try AVAudioSession.sharedInstance().setActive(true)
            // set AVAudioPlayer with the url which we built
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            // play the sound
            player?.play()
        }catch let error {
            // check for error
            print(error.localizedDescription)
        }
    }
}

