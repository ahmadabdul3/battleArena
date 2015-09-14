//
//  GameNavigationController.swift
//  battle arena
//
//  Created by Abdul on 9/6/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import UIKit

class GameNavigationController : UINavigationController {
    let PresentAuthenticationViewController = "present_authentication_view_controller"
    let gameKitHelper = GameKitHelper()
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        if let gameViewController = self.topViewController as? GameViewController {
            gameViewController.gameKitHelper = gameKitHelper
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("showAuthenticationViewController"), name: PresentAuthenticationViewController, object: nil)
        
        gameKitHelper.authenticateLocalPlayer()
    }
    func showAuthenticationViewController() {
        self.topViewController.presentViewController(gameKitHelper._authenticationViewController, animated: true, completion: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: PresentAuthenticationViewController, object: nil)
        //func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}
