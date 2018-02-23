//
//  SoundStudioViewController.swift
//  Talkboy
//
//  Created by Andy Harris on 23/02/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit
import AVFoundation

class SoundStudioViewController: UIViewController {
    
    // create an (optonal) audiorecorder object
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL : URL?
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func RecordTapped(_ sender: Any) {
        
        // if recording, then stop; otherwise, start reoding
        if let audioRecorder = self.audioRecorder {
            if audioRecorder.isRecording {

                audioRecorder.stop()
                recordButton.setTitle("Record", for: .normal)
                playButton.isEnabled = true
                SoundNameField.isEnabled = true
                addButton.isEnabled = true

            } else {
            
                audioRecorder.record()
                recordButton.setTitle("Stop", for: .normal)
                playButton.isEnabled = false
                SoundNameField.isEnabled = false
                addButton.isEnabled = false
                
            }
        }
        
    }
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func PlayTapped(_ sender: Any) {
        
        if let audioURL = self.audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        }
        
    }
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func AddTapped(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let sound = Sound(entity: Sound.entity(), insertInto: context)
            sound.name = SoundNameField.text
            if let audioURL = self.audioURL {
                sound.audioData = try? Data(contentsOf: audioURL)
                try? context.save()
                navigationController?.popViewController(animated: true)
                
            }
    
        }
    
    }
    
    
    @IBOutlet weak var SoundNameField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // create an audio session
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)
        
        // URL to save audio
        // First create a base path, then add on audio file
        
        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first{
         
            let pathComponents = [basePath, "audio.m4a"]
            if let audioURL = NSURL.fileURL(withPathComponents: pathComponents){
             
                //Create some settings
                self.audioURL = audioURL
                var settings: [String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                
                
                //Create the audio recorder
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings )
                audioRecorder?.prepareToRecord()
            }
            
        }
        // Disable buttons (except record) until there's a recording
        playButton.isEnabled = false
        SoundNameField.isEnabled = false
        addButton.isEnabled = false
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
