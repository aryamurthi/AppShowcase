//
//  StatsViewController.swift
//  AppShowcase
//
//  Created by Arya Murthi on 12/1/17.
//  Copyright © 2017 Arya Murthi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class StatsViewController: UIViewController {
    
    @IBOutlet weak var numberOfWins: UILabel!
    @IBOutlet weak var numberOfLosses: UILabel!
    @IBOutlet weak var winPercentage: UILabel!
    @IBOutlet weak var numberOfSwitches: UILabel!
    @IBOutlet weak var numberOfStays: UILabel!
    @IBOutlet weak var winPercentageHadYouSwitched: UILabel!
    @IBOutlet weak var numberOfAttempts: UILabel!
    
    var gameStats = [GameStatistics]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
     
        configureBackground()
        
        self.numberOfWins.text = String(gameStats[0].numberOfWins)
        self.numberOfLosses.text = String(gameStats[0].numberOfLosses)
        self.winPercentage.text = String(format: "%.f", Double(gameStats[0].numberOfWins)/Double(gameStats[0].numberOfAttempts) * 100)
        self.numberOfSwitches.text = String(gameStats[0].numberOfSwitches)
        self.numberOfStays.text = String(gameStats[0].numberOfStays)
        self.numberOfAttempts.text = String(gameStats[0].numberOfAttempts)
        self.winPercentageHadYouSwitched.text = String(format: "%.f", Double(gameStats[0].numberOfWinsHadYouSwitchedEveryTime)/Double(gameStats[0].numberOfAttempts) * 100)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    func configureBackground(){
        let backgroundImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.alpha = 0
        backgroundImage.loadGif(name: "background")
        UIView.animate(withDuration: 0.01, animations:{backgroundImage.alpha = 0.01}, completion:{_ in UIView.animate(withDuration: 10, animations: {backgroundImage.alpha = 0.5})})
        view.addSubview(backgroundImage)
        view.sendSubview(toBack: backgroundImage)
    }
    
    func loadData(){
        db.collection("gameStats").getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: reading documents \(error!.localizedDescription)")
                return
            }
            
            self.gameStats = []
            for document in querySnapshot!.documents {
                let docData = document.data()
                let numberOfWins = docData["numberOfWins"] as! Int
                let numberOfAttempts = docData["numberOfAttempts"] as! Int
                let numberOfLosses = docData["numberOfLosses"] as! Int
                let numberOfSwitches = docData["numberOfSwitches"] as? Int ?? 0
                let numberOfStays = docData["numberOfStays"] as? Int ?? 0
                let numberOfWinsHadYouSwitchedEveryTime = docData["numberOfWinsHadYouSwitchedEveryTime"] as! Int
                let winPercentage = docData["winPercentage"] as! Double
                let winPercentageHadYouSwitched = docData["winPercentageHadYouSwitched"] as! Double
                
                self.gameStats.append(GameStatistics(numberOfWins: numberOfWins, numberOfLosses: numberOfLosses, winPercentage: winPercentage, numberOfSwitches: numberOfSwitches, numberOfStays: numberOfStays, winPercentageHadYouSwitched: winPercentageHadYouSwitched, numberOfWinsHadYouSwitchedEveryTime: numberOfWinsHadYouSwitchedEveryTime, numberOfAttempts: numberOfAttempts))
               
            }
        }
    }
    
}
