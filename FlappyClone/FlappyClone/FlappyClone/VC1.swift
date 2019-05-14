//
//  VC1.swift
//  FlappyClone
//
//  Created by Shemon on 5/3/19.
//  Copyright © 2019 Shemon. All rights reserved.
//

import UIKit
import SpriteKit

class VC1: UIViewController{
    
    var gameScene1: GameScene?
    

    @IBOutlet weak var scoreLbl1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.navigationController!.viewControllers[0] as? ViewController
        gameScene1 = vc?.scene1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        scoreLbl1.text = "Max 3 Scores : \(String(describing: gameScene1?.game.scores[0])) \t \(String(describing: gameScene1?.game.scores[1])) \t \(String(describing: gameScene1?.game.scores[2]))"
        
        
    }
    
    
    
}
