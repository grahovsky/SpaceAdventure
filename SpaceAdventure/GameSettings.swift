//
//  GameSettings.swift
//  SpaceAdventure
//
//  Created by Konstantin on 29/10/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class GameSettings: NSObject {
    
    var highscore: Int
    var currentScore: Int
    var lastScore: Int
    var musicOn: Bool
    var soundOn: Bool
    var startingNumberOfLives = 3
    
    var lives: Int
    
    override init() {
        
        highscore = 0
        currentScore = 0
        lastScore = 0
        
        musicOn = true
        soundOn = true
        
        lives = startingNumberOfLives
        
        super.init()
        
        loadGameSettings()
        
        
    }
    
    func saveSettings(settings: [Bool]) {
        
        musicOn = settings[0]
        soundOn = settings[1]
        saveGameSettings()
        
    }
    
    func recordScores(score: Int) {
        
        if score > highscore {
            highscore = score
        }
        
        lastScore = score
        
        saveGameSettings()
        
    }
    
    func saveGameSettings() {
        
        UserDefaults.standard.set(highscore, forKey: "highscore")
        UserDefaults.standard.set(lastScore, forKey: "lastScore")
        UserDefaults.standard.set(musicOn, forKey: "musicOn")
        UserDefaults.standard.set(soundOn, forKey: "soundOn")
    
    }
    
    func loadGameSettings() {
       
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        lastScore = UserDefaults.standard.integer(forKey: "lastScore")
        musicOn = UserDefaults.standard.bool(forKey: "musicOn")
        soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        
    }
    
    override var description: String {
        
        return "highscore: \(self.highscore), lastScore: \(self.lastScore), currentScore: \(self.currentScore)"
        
    }
    
    func resetCurrentScore() {
        currentScore = 0
        
        lives = startingNumberOfLives
    }
    
    func resetHighscore() {
        highscore = 0
        lastScore = 0
        
        saveGameSettings()
    }

}
