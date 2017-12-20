//
//  ViewController.swift
//  AppShowcase
//
//  Created by Arya Murthi on 11/24/17.
//  Copyright © 2017 Arya Murthi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var door1: UIImageView!
    @IBOutlet weak var door2: UIImageView!
    @IBOutlet weak var door3: UIImageView!
    @IBOutlet weak var doorSelectionLabel: UILabel!

    var gameStats = [GameStatistics]()
    var authUI: FUIAuth!
    
    var doorIndex = 0
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        let newGameStats = GameStatistics(numberOfWins: 0, numberOfLosses: 0, winPercentage: 0.0, numberOfSwitches: 0, numberOfStays: 0, winPercentageHadYouSwitched: 0.0, numberOfWinsHadYouSwitchedEveryTime: 0, numberOfAttempts: 0)
        
        gameStats.append(newGameStats)
        loadStats()
        
        doorSelectionLabel.alpha = 0
        continueButton.alpha = 0
        
        gifView.loadGif(name:"giphy")
        
        door1.alpha = 0
        door2.alpha = 0
        door3.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {self.door1.alpha = 1.0}, completion: {_ in
            UIView.animate(withDuration: 0.5, animations: {self.door2.alpha = 1.0}, completion: {_ in UIView.animate(withDuration: 0.5, animations: {self.door3.alpha = 1.0})})
        })
        configureStatsButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn(){
        let providers: [FUIAuthProvider] = [
        FUIGoogleAuth()]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "DoorPressed"{
        let destination = segue.destination as! DoorViewController
        destination.doorIndex = doorIndex
        destination.gameStats = gameStats
        } else {
            let destination = segue.destination as! StatsViewController
            destination.gameStats = gameStats
        
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do {
            try authUI!.signOut()
            print("***Successfully signed out!")
            signIn()
        } catch{
            print("Couldn't sign out.")
        }
    }
    
    @IBAction func door1Pressed(_ sender: UITapGestureRecognizer) {
        doorIndex = 1
        door2.alpha = 1.0
        door3.alpha = 1.0
        
        doorSelectionLabel.text = "You chose door number: 1"
        UIView.animate(withDuration: 0.3, animations: {self.continueButton.alpha = 1.0;self.door1.alpha = 0.5; self.doorSelectionLabel.alpha = 1.0})
    }
    
    @IBAction func door2Pressed(_ sender: UITapGestureRecognizer) {
        doorIndex = 2
        door1.alpha = 1.0
        door3.alpha = 1.0
        doorSelectionLabel.isHidden = false
        doorSelectionLabel.text = "You chose door number: 2"
        UIView.animate(withDuration: 0.3, animations: {self.continueButton.alpha = 1.0;self.door2.alpha = 0.5; self.doorSelectionLabel.alpha = 1.0})
    }
    
    @IBAction func door3Pressed(_ sender: UITapGestureRecognizer) {
        doorIndex = 3
        door1.alpha = 1.0
        door2.alpha = 1.0
        doorSelectionLabel.isHidden = false
        doorSelectionLabel.text = "You chose door number: 3"
        UIView.animate(withDuration: 0.3, animations: {self.continueButton.alpha = 1.0;self.door3.alpha = 0.5; self.doorSelectionLabel.alpha = 1.0})
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        switch doorIndex {
        case 1:
            UIView.animate(withDuration: 1.0, animations: {self.door1.frame.origin.y = -(self.door1.frame.size.height + 60)}, completion: {_ in self.performSegue(withIdentifier: "DoorPressed", sender: self)})
        case 2:
            UIView.animate(withDuration: 1.0, animations: {self.door2.frame.origin.y = -(self.door1.frame.size.height + 60)}, completion: {_ in  self.performSegue(withIdentifier: "DoorPressed", sender: self)})
        case 3:
            UIView.animate(withDuration: 1.0, animations: {self.door3.frame.origin.y = -(self.door1.frame.size.height + 60)}, completion: {_ in  self.performSegue(withIdentifier: "DoorPressed", sender: self)})
        default:
            break
        }
    }
    
    @objc func segueToStatsVC() {
        performSegue(withIdentifier: "SegueToStatsVC", sender: nil)
    }
    
    func configureStatsButton() {
        if #available(iOS 11.0, *) {
            let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
        }
        
        let statsButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth - 5, y: view.frame.height - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        statsButton.setImage(UIImage(named: "statsButton"), for: .normal)
        statsButton.setImage(UIImage(named: "satsButonClicked"), for: .highlighted)
        statsButton.addTarget(self, action: #selector(segueToStatsVC), for: .touchUpInside)
        view.addSubview(statsButton)
    }
    
    
    
    func loadStats(){
        guard let statsEncoded = UserDefaults.standard.value(forKey: "gameStats") as? Data else {
            print("Couldn't return data from UserDefaults")
            return
        }
        let decoder = JSONDecoder()
        if let gameStats = try? decoder.decode(Array.self, from: statsEncoded) as [GameStatistics] {
            self.gameStats = gameStats
        }else {
            print("Couldn't decode Data")
        }
    }
}

extension ViewController: FUIAuthDelegate {
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user{
            print("****Successfully signed in with user: \(user.email!)." )
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        
        let marginInset: CGFloat = 5
        let imageY = self.view.center.y - 140
        let logoframe = CGRect(x: self.view.frame.origin.x + marginInset, y: imageY, width: self.view.frame.width - (marginInset*2) , height: 150)
        let logoImageView = UIImageView(frame: logoframe)
        logoImageView.image = UIImage(named: "TwoGoatsIntro")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
    
        return loginViewController
    }
}

