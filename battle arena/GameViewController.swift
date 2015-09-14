//
//  GameViewController.swift
//  battle arena
//
//  Created by Abdul on 8/27/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import UIKit
import SpriteKit

struct NotificationConstants {
    static var pvpConnEstablishedString = "pvpConnectionEstablished"
    static var pvpConnEstablishedSelector = Selector("hideMainView")
}

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    var gameKitHelper = GameKitHelper()
    var networkingEngine = MultiplayerNetworking()
    
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MultiplayerButton: UIButton!
    @IBAction func MultiplayerButtonClick(sender: AnyObject) {
        //if NSNotificationCenter.defaultCenter().
        if gameKitHelper._enableGameCenter {
            //MenuView.hidden = true;
            NSNotificationCenter.defaultCenter().addObserver(self, selector: NotificationConstants.pvpConnEstablishedSelector, name: NotificationConstants.pvpConnEstablishedString , object: nil)
            setUpGameScene()
            initiateMultiplayerGC()
            
        }
    }
    func hideMainView() {
        MenuView.hidden = true
        //setUpGameScene()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationConstants.pvpConnEstablishedString, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let LocalPlayerIsAuthenticated = "local_player_authenticated"
        super.viewDidAppear(animated)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerAuthenticated"), name: LocalPlayerIsAuthenticated, object: nil)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    override func viewDidLoad() {

    }
    
    func setUpGameScene() {
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .ResizeFill
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    func initiateMultiplayerGC() {
    
        let skView = self.view as! SKView
        let scene = skView.scene as! GameScene!
    
        networkingEngine = MultiplayerNetworking(gameKitHelper: gameKitHelper)
        networkingEngine.delegate = scene
        scene.networkingEngine = networkingEngine
        
        gameKitHelper.findMatchWithMinPlayers(2, maxPlayers: 2, viewController: self, delegate: networkingEngine)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Landscape.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
