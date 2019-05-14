
import UIKit
import SpriteKit

class ScoreViewController: UIViewController {
    
    var gameScene1: GameScene?
    @IBOutlet weak var ScoreLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //code
        let vc1 = self.tabBarController!.viewControllers![0] as? ViewController
        gameScene1 = vc1?.scene

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //code
        
        ScoreLbl.text = "Max 3 Scores : \(String(describing: gameScene1!.game.scores[0])) \(String(describing: gameScene1!.game.scores[1])) \(String(describing: gameScene1!.game.scores[2]))"
        
        
    }

}
