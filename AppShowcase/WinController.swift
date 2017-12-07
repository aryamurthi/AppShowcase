//
//  WinController.swift
//  AppShowcase
//
//  Created by Arya Murthi on 11/24/17.
//  Copyright © 2017 Arya Murthi. All rights reserved.
//

import UIKit

class WinController: UIViewController {
    
    @IBOutlet weak var gifView: UIImageView!
    var doorIndex = 0
    var carIndex = 0
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    var stayed = false
    var switched = false
    var gameStats = [GameStatistics]()
    
    @IBOutlet weak var prize: UIImageView!
    @IBOutlet weak var winOrLoseLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifView.loadGif(name: "background4")
        configureStatsButton()
        
        self.prize.bounds = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        
        if doorIndex == carIndex {
            winOrLoseLabel.text = "You won a car!"
            prize.image = UIImage(named: "car")
            
            UIView.animate(withDuration: 0.001, animations:{self.prize.alpha = 0.0}, completion:{_ in UIView.animate(withDuration: 3.0, animations: {self.prize.bounds = CGRect(x: 213, y: 123, width: 240, height: 128); self.prize.alpha = 1.0})})
        }else {
            winOrLoseLabel.text = "I'm sorry, you won a goat!"
            prize.image = UIImage(named:"goat")
            
            UIView.animate(withDuration: 0.001, animations:{self.prize.alpha = 0.0}, completion:{_ in UIView.animate(withDuration: 3.0, animations: {self.prize.bounds = CGRect(x: 213, y: 123, width: 240, height: 128); self.prize.alpha = 1.0})})
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayAgain" {
            let destination = segue.destination as! ViewController
            destination.gameStats = gameStats
        }else {
            let destination = segue.destination as! StatsViewController
            destination.gameStats = gameStats
        }
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "PlayAgain", sender: self)
    }
    
    @objc func segueToStatsVC() {
        performSegue(withIdentifier: "ShowStats", sender: nil)
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
    
}
