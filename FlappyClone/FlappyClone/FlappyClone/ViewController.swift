//
// Shemon
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    var skView: SKView!
    var scene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameScene()

    }
    
    
    func setupGameScene() {
        scene = GameScene(size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        scene!.scaleMode = .aspectFill
        skView = self.view as? SKView
        scene!.size = self.view.bounds.size
        skView.presentScene(scene)
    
    
    }
    
}
