//
//  ConfigViewController.swift
//  FlappyClone
//
//  Created by Shemon on 5/2/19.
//  Copyright © 2019 Shemon. All rights reserved.
//

import UIKit
import SpriteKit

class ConfigViewController: UIViewController {
    
    var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let vc = self.tabBarController!.viewControllers![0] as? ViewController
        gameScene = vc?.scene
        
    }
    
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBAction func chngIcon(_ sender: Any) {
        switch segControl.selectedSegmentIndex{
        case 0:
            gameScene!.GhostName = "Ghost"
        case 1:
            gameScene!.GhostName = "altima2"
        case 2:
            gameScene!.GhostName = "ironman"
        case 3:
            gameScene!.GhostName = "phoenix"
        case 4:
            gameScene!.GhostName = "aziraphale"
            
        default:
            break;
        }
    }
    
    
    @IBOutlet weak var jumpForce: UILabel!
    
    @IBAction func chngJump(_ sender: UIStepper) {
        jumpForce.text = String(sender.value)
        gameScene!.jmp = Int(sender.value)
    }
}


