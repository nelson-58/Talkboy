//
//  ItemsTableViewController.swift
//  Talkboy
//
//  Created by Andy Harris on 23/02/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit
import AVFoundation

class ItemsTableViewController: UITableViewController {

    // Need an array to store the sounds, of type Sound
    var sounds : [Sound] = []
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // take the stuff out of core memory, put it in the sounds array, then refresh the tableView
        
    }

    func getSounds() {
        // get the sounds out of core data and put them inthe sounds[] array
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            // retreive the data from core data as an array of Sound objects
            
            if let coreSoundsStuff = try? context.fetch(Sound.fetchRequest()) as? [Sound] {
                
                // Sounds are optional, so unwrap
                if let coreSounds = coreSoundsStuff {
                    // put the sounds extracted from core data, into the sounds array, ready to be displayed in the tableView
                    // this copies the entire core data array into the array used by tableview
                    sounds  = coreSounds
                    tableView.reloadData()
                    
                }
            }
            
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        getSounds()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 

        // get the data out of sounds array
        let sound = sounds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // get the item title and place into cell
        cell.textLabel?.text = sound.name

        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sound = sounds[indexPath.row]
        // sound stoed in core data as a binary file
        // it's optional, so need to unwrap
        
        if let audioData = sound.audioData {
            audioPlayer = try? AVAudioPlayer(data: audioData)
            audioPlayer?.play()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let sound = sounds[indexPath.row]
                context.delete(sound)
                try? context.save()
                getSounds()
            }
        }

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
