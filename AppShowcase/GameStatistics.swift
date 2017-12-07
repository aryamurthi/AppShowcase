//
//  GameStatistics.swift
//  AppShowcase
//
//  Created by Arya Murthi on 12/1/17.
//  Copyright © 2017 Arya Murthi. All rights reserved.
//

import Foundation

class GameStatistics: Codable {
    
    var numberOfWins: Int
    var numberOfLosses: Int
    var winPercentage: Double
    var numberOfSwitches: Int
    var numberOfStays: Int
    var numberOfWinsHadYouSwitchedEveryTime: Int
    var winPercentageHadYouSwitched: Double
    var numberOfAttempts: Int
    
    
    
    
    init(numberOfWins: Int, numberOfLosses: Int, winPercentage: Double, numberOfSwitches: Int, numberOfStays: Int, winPercentageHadYouSwitched: Double, numberOfWinsHadYouSwitchedEveryTime: Int, numberOfAttempts: Int){
        self.numberOfWins = numberOfWins
        self.numberOfLosses = numberOfLosses
        self.winPercentage = winPercentage
        self.numberOfSwitches = numberOfSwitches
        self.numberOfStays = numberOfStays
        self.winPercentageHadYouSwitched = winPercentageHadYouSwitched
        self.numberOfWinsHadYouSwitchedEveryTime = numberOfWinsHadYouSwitchedEveryTime
        self.numberOfAttempts = numberOfAttempts
        
    }
        
    
}
