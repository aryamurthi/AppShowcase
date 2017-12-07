//
//  DoorViewController.swift
//  AppShowcase
//
//  Created by Arya Murthi on 11/24/17.
//  Copyright © 2017 Arya Murthi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class DoorViewController: UIViewController {
    
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var playerDoorChoice: UIImageView!
    @IBOutlet weak var doorRevealed: UIImageView!
    @IBOutlet weak var doorRemaining: UIImageView!
    @IBOutlet weak var playerDoorChoiceLabel: UILabel!
    @IBOutlet weak var hostRevealLabel: UILabel!
    @IBOutlet weak var doorRevealLabel: UILabel!
    @IBOutlet weak var doorRemainingLabel: UILabel!
    @IBOutlet weak var youCanStayLabel: UILabel!
    @IBOutlet weak var orSwitchLabel: UILabel!
    @IBOutlet weak var stayButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    var authUI: FUIAuth!
    var db: Firestore!
    var openedDoor = ""
    let goatOneIndex = Int(arc4random_uniform(UInt32(3))+1)
    var goatTwoIndex = 0
    var carIndex = 0
    var doorIndex = 0
    var revealIndex = 0
    var switchIndex = 0
    var gameStats = [GameStatistics]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        gifView.loadGif(name:"background3")
        goatTwoIndex = getGoatTwoIndex(goatOneIndex: goatOneIndex)
        carIndex = 6-goatOneIndex-goatTwoIndex
        
        hostRevealLabel.alpha = 0
        doorRevealLabel.alpha = 0
        doorRevealed.alpha = 0
        youCanStayLabel.alpha = 0
        stayButton.alpha = 0
        playerDoorChoiceLabel.alpha = 0
        playerDoorChoice.alpha = 0
        orSwitchLabel.alpha = 0
        switchButton.alpha = 0
        doorRemainingLabel.alpha = 0
        doorRemaining.alpha = 0
        
        
        playerDoorChoice.image = UIImage(named:"door\(doorIndex)")
        playerDoorChoiceLabel.text = "Your Door Choice: \(doorIndex)"
        
        if doorIndex == goatOneIndex {
            //Change text
            hostRevealLabel.text = "The host revealed the goat behind door number \(goatTwoIndex)."
            doorRevealLabel.text = "Door Revealed: \(goatTwoIndex)"
            openedDoor = "opendoor\(goatTwoIndex)"
            doorRemainingLabel.text = "Door Remaining: \(carIndex)"
            
            revealIndex = goatTwoIndex
            switchIndex = carIndex
            
            //Change Images
            doorRevealed.image = UIImage(named:"door\(goatTwoIndex)")
            doorRemaining.image = UIImage(named:"door\(carIndex)")
        }
        else if doorIndex == goatTwoIndex{
            //Change text
            hostRevealLabel.text = "The host revealed the goat behind door number \(goatOneIndex). "
            doorRevealLabel.text = "Door Revealed: \(goatOneIndex)"
            doorRemainingLabel.text = "Door Remaining: \(carIndex)"
            
            revealIndex = goatOneIndex
            switchIndex = carIndex
            
            //Change images
            doorRevealed.image = UIImage(named:"door\(goatOneIndex)")
            openedDoor = "opendoor\(goatOneIndex)"
            doorRemaining.image = UIImage(named:"door\(carIndex)")
            
        }
        else {
            //Change Text
            hostRevealLabel.text = "The host revealed the goat behind door number \(goatOneIndex)."
            doorRevealLabel.text = "Door Revealed: \(goatOneIndex)"
            doorRemainingLabel.text = "Door Remaining: \(goatTwoIndex)"
            
            revealIndex = goatOneIndex
            switchIndex = goatTwoIndex
            
            //Change Images
            doorRevealed.image = UIImage(named:"door\(goatOneIndex)")
            openedDoor = "opendoor\(goatOneIndex)"
            doorRemaining.image = UIImage(named:"door\(goatTwoIndex)")
        }
        
        //Fade in elemets sequentially

        UIView.animate(withDuration: 0.01, animations: {self.hostRevealLabel.alpha = 0.01}, completion:{_ in UIView.animate(withDuration: 1.0, animations: {self.hostRevealLabel.alpha = 1.0}, completion: {_ in UIView.animate(withDuration: 1.0, animations: {self.doorRevealLabel.alpha = 1.0; self.doorRevealed.alpha = 1.0},
          completion: {_ in self.doorRevealed.image = UIImage(named: self.openedDoor);
          UIView.animate(withDuration: 1.0, animations: {self.youCanStayLabel.alpha = 1.0}, completion: {_ in UIView.animate(withDuration: 1.0, animations: {UIView.animate(withDuration: 0.5, animations: {self.stayButton.alpha = 1.0; self.playerDoorChoiceLabel.alpha = 1.0; self.playerDoorChoice.alpha = 1.0}, completion: {_ in UIView.animate(withDuration: 1.0, animations: {self.orSwitchLabel.alpha = 1.0}, completion: {_ in UIView.animate(withDuration: 1.0, animations: {self.switchButton.alpha = 1.0; self.doorRemainingLabel.alpha = 1.0; self.doorRemaining.alpha = 1.0})})})})})
        })})})
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! WinController
        destination.doorIndex = doorIndex
        destination.carIndex = carIndex
        destination.gameStats = gameStats
    
    }
    
    @IBAction func switchButtonPressed(_ sender: UIButton) {
        doorIndex = switchIndex
        gameStats[0].numberOfAttempts += 1
        gameStats[0].numberOfSwitches += 1
        if switchIndex == carIndex {
            gameStats[0].numberOfWins += 1
            gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            gameStats[0].numberOfWinsHadYouSwitchedEveryTime += 1
            gameStats[0].winPercentageHadYouSwitched = Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts)
            saveData(index: 0)
            saveStats()
        }else {
            gameStats[0].numberOfLosses += 1
             gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            gameStats[0].winPercentageHadYouSwitched = Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts)
            
            saveData(index: 0)
            saveStats()
        }
        
        performSegue(withIdentifier: "WinOrLose", sender: self)
    }
    @IBAction func stayButtonPressed(_ sender: UIButton) {
        gameStats[0].numberOfStays += 1
        gameStats[0].numberOfAttempts += 1
        if doorIndex == carIndex {
            gameStats[0].numberOfWins += 1
            gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            gameStats[0].winPercentageHadYouSwitched = Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts)
           
            
            saveData(index: 0)
            saveStats()
        }else {
            gameStats[0].numberOfWinsHadYouSwitchedEveryTime += 1
             gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            gameStats[0].numberOfLosses += 1
            gameStats[0].winPercentageHadYouSwitched = Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime/gameStats[0].numberOfAttempts)
           
            
            saveData(index: 0)
            saveStats()
        }
        
        performSegue(withIdentifier: "WinOrLose", sender: self)
    }
    
    @IBAction func doorRemainingPressed(_ sender: UITapGestureRecognizer) {
        doorIndex = switchIndex
        gameStats[0].numberOfAttempts += 1
        gameStats[0].numberOfSwitches += 1
        if switchIndex == carIndex {
            gameStats[0].numberOfWinsHadYouSwitchedEveryTime += 1
            gameStats[0].numberOfWins += 1
            gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            gameStats[0].winPercentageHadYouSwitched = Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts)
            saveData(index: 0)
            saveStats()
        }else {
             gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            gameStats[0].winPercentageHadYouSwitched = Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts)
            gameStats[0].numberOfLosses += 1
            saveData(index: 0)
            saveStats()
        }
        performSegue(withIdentifier: "WinOrLose", sender: self)
    }
    
    @IBAction func originalDoorPressed(_ sender: UITapGestureRecognizer) {
        gameStats[0].numberOfStays += 1
        gameStats[0].numberOfAttempts += 1
        if doorIndex == carIndex {
            gameStats[0].numberOfWins += 1
            gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            saveData(index: 0)
            saveStats()
        }else {
            gameStats[0].numberOfWinsHadYouSwitchedEveryTime += 1
             gameStats[0].winPercentage = (Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts))
            gameStats[0].winPercentageHadYouSwitched = Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts)
            gameStats[0].numberOfLosses += 1
            saveData(index: 0)
            saveStats()
            
        }
        performSegue(withIdentifier: "WinOrLose", sender: self)
    }
    
    func saveData(index: Int) {
        
        //create dictionary of data to save
        
        let dataToSave:[String: Any] = ["numberOfWins": gameStats[0].numberOfWins, "numberOfLosses": gameStats[0].numberOfLosses,"winPercentage": gameStats[0].winPercentage * 100, "numberOfSwitches": gameStats[0].numberOfSwitches, "numberOfStays": gameStats[0].numberOfStays, "numberOfAttempts": gameStats[0].numberOfAttempts,
            "numberOfWinsHadYouSwitchedEveryTime": gameStats[0].numberOfWinsHadYouSwitchedEveryTime,
            "winPercentageHadYouSwitched": Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts) * 100]
        
            let ref = db.collection("gameStats").addDocument(data: dataToSave)
//        let ref = db.collection("gameStats").document("7ufJLOVLzfZiTfXiaVJH")
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                }else{
                    print("Document updated with reference ID \(ref)")
                }
            }
//         else {
//            var ref : DocumentReference? = nil
//            ref = db.collection("games").addDocument(data: dataToSave) {(error) in
//                if let error = error {
//                    print("ERROR: adding document \(error.localizedDescription)")
//                }else{
//                    print("Document updated with reference ID \(ref!.documentID)")
//                    self.gameStats[0].gameDocumentID = "\(ref!.documentID)"
//                }
//            }
//        }
    }
    
    
    func saveStats() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(gameStats) {
            UserDefaults.standard.set(encoded,forKey: "gameStats")
        } else {
            print("ERROR-: Failed to save Encoded")
        }
    }
    
    func getGoatTwoIndex (goatOneIndex: Int) -> Int {
        repeat {
            goatTwoIndex = Int(arc4random_uniform(UInt32(3))+1)
        } while goatTwoIndex == goatOneIndex
        
        return goatTwoIndex
    }
    
    
}
