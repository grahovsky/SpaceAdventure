//
//  PauseViewController.swift
//  SpaceAdventure
//
//  Created by Konstantin on 22/10/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

protocol PauseViewControllerDelegate {
    
    func pauseViewControllerPlayButtonPressed(viewConroller: PauseViewController)
    func pauseViewControllerStoreButtonPressed(viewConroller: PauseViewController)
    func pauseViewControllerMenuButtonPressed(viewConroller: PauseViewController)
    
    func pauseViewControllerSoundButtonPressed(viewConroller: PauseViewController)
    func pauseViewControllerMusicButtonPressed(viewConroller: PauseViewController)
}

class PauseViewController: UIViewController {

    var delegate: PauseViewControllerDelegate!
    
    @IBOutlet weak var soundButton: UIButton!
    
    @IBOutlet weak var musicButton: UIButton!
    
    @IBAction func soundButtonPressed(_ sender: Any) {
        delegate.pauseViewControllerSoundButtonPressed(viewConroller: self)
    }
    
    @IBAction func musicButtonPressed(_ sender: Any) {
        delegate.pauseViewControllerMusicButtonPressed(viewConroller: self)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        delegate.pauseViewControllerPlayButtonPressed(viewConroller: self)
    }
    
    @IBAction func storeButtonPressed(_ sender: Any) {
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
