//
//  GameKitHelper.swift
//  battle arena
//
//  Created by Abdul on 9/1/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import GameKit

protocol GameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
    func match(match: GKMatch!,
        didReceiveData data: NSData!,
        fromRemotePlayer player: GKPlayer!)
}
class GameKitHelper : NSObject, GKMatchmakerViewControllerDelegate, GKMatchDelegate
{
    var _authenticationViewController = UIViewController()
    var _lastError = NSError()
    var _match:GKMatch?
    var _delegate:GameKitHelperDelegate?
    var playersDict = NSMutableDictionary()
    let PresentAuthenticationViewController = "present_authentication_view_controller"
    let LocalPlayerIsAuthenticated = "local_player_authenticated"
    var _enableGameCenter = false
    var _matchStarted = false
    //static var numOfInstances = 0
    static var gkHelperInstance:GameKitHelper?
    
    
    static func sharedGameKitHelper() -> GameKitHelper//instancetype
    {
        if let localGkHelperInstance = gkHelperInstance {
            return localGkHelperInstance
        }
        
        var sharedGameKitHelper = GameKitHelper()
        gkHelperInstance = sharedGameKitHelper
        //numOfInstances = 1
        return sharedGameKitHelper
        
        //var onceToken = dispatch_once_t() //onceToken;
        //dispatch_once(&onceToken, {(onceToken) -> Void in sharedGameKitHelper = GameKitHelper()})
        
        //dispatch_once(&onceToken, { sharedGameKitHelper = [[GameKitHelper alloc] init];});
        //return sharedGameKitHelper.self;
    }
    
    override init() //-> id
    {
        super.init()
        _enableGameCenter = true;
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if (localPlayer.authenticated) {
            NSNotificationCenter.defaultCenter().postNotificationName(self.LocalPlayerIsAuthenticated, object: nil)
            return;
        }
        localPlayer.authenticateHandler = {(viewController, error) in
            //self.setLastError(error)
            if viewController != nil {
                self.setAuthenticationViewController(viewController)
            } else if(GKLocalPlayer.localPlayer().authenticated) {
                self._enableGameCenter = true;
                NSNotificationCenter.defaultCenter().postNotificationName(self.LocalPlayerIsAuthenticated, object: nil)
            } else {
                self._enableGameCenter = false;
            }
        }
    }

        
    func lookupPlayers() {
    
        println("Looking up %lu players...", _match!.players.count as Int);
        //GKPlayer.loadPlayersForIdentifiers(<#identifiers: [AnyObject]!#>, withCompletionHandler: <#(([AnyObject]!, NSError!) -> Void)!##([AnyObject]!, NSError!) -> Void#>)
        GKPlayer.loadPlayersForIdentifiers(_match?.playerIDs, withCompletionHandler: {
            (players, error) -> Void in
            if error != nil {
                println("Error retrieving player info: %@", error.localizedDescription)
                self._matchStarted = false
                self._delegate?.matchEnded()
            } else {
                self.playersDict = NSMutableDictionary(capacity: players.count)
                for player in players as! [GKPlayer] {
                    println("Found player: %@", player.alias)
                    self.playersDict[player.playerID] = player
                }
                self.playersDict.setObject(GKLocalPlayer.localPlayer(), forKey: GKLocalPlayer.localPlayer().playerID)
                self._matchStarted = true
                self._delegate?.matchStarted()
            }
        })
    }
    
    func findMatchWithMinPlayers(minPlayers:Int, maxPlayers: Int, viewController:UIViewController, delegate: GameKitHelperDelegate) {
        
        if !_enableGameCenter {
            return
        }
        
        _matchStarted = false
        self._match = nil
        _delegate = delegate
        //viewController.dismissViewControllerAnimated(false, completion: nil)
        //[viewController dismissViewControllerAnimated: false completion:nil]
        
        var request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        var mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc.matchmakerDelegate = self
        //viewController.presentViewController(<#viewControllerToPresent: UIViewController#>, animated: <#Bool#>, completion: <#(() -> Void)?##() -> Void#>)
        viewController.presentViewController(mmvc, animated: true, completion: nil)
    }
    
    func setAuthenticationViewController(authenticationViewController: UIViewController) {
        
        _authenticationViewController = authenticationViewController
        NSNotificationCenter.defaultCenter().postNotificationName(PresentAuthenticationViewController, object: self)
    
    }
    
    func setLastError(error: NSError){
        _lastError = error.copy() as! NSError//[error copy];
        //if _lastError != nil {
            println("GameKitHelper ERROR: %@", _lastError.userInfo!.description) //[[_lastError userInfo] description]);
        //}
    }


    @objc func matchmakerViewController(viewController: GKMatchmakerViewController!, didFindPlayers playerIDs: [AnyObject]!) {
        
    }
    @objc func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController!) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    @objc func matchmakerViewController(viewController: GKMatchmakerViewController!, didFailWithError error: NSError!) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        println("Error finding match: %@", error.localizedDescription)
    }
    @objc func matchmakerViewController(viewController: GKMatchmakerViewController!, didFindMatch match: GKMatch!){
        viewController.dismissViewControllerAnimated(true, completion: nil)
        self._match = match
        match.delegate = self
        if !_matchStarted && match.expectedPlayerCount == 0 {
            println("Ready to start match!")
            self.lookupPlayers()
        }
    }
    
            
    
    @objc func matchmakerViewController(viewController: GKMatchmakerViewController!,
        didFindHostedPlayers players: [AnyObject]!) {
            
    }
    @objc func matchmakerViewController(viewController: GKMatchmakerViewController!,
        hostedPlayerDidAccept player: GKPlayer!) {
            
    }
    
    //#pragma mark GKMatchDelegate
    
    // The match received data sent from the player.
    @objc func match(match: GKMatch!,
        didReceiveData data: NSData!,
        fromRemotePlayer player: GKPlayer!) {
        if _match != match {return}
        _delegate?.match(match, didReceiveData: data, fromRemotePlayer: player)
        
        //_delegate?.matchDidReceiveDataFromPlayer(match, data: data, player: player)
    }
    
    @objc func match(match: GKMatch!,
        player: GKPlayer!,
        didChangeConnectionState state: GKPlayerConnectionState) {
    
    // The player state changed (eg. connected or disconnected)
    //@objc func match(match: GKMatch!, player: GKPlayer!, didChangeConnectionState state: GKPlayerConnectionState) {
    //func matchPlayerDidChangeState(match: GKMatch, playerID: NSString, state:GKPlayerConnectionState) {
        if _match != match { return }
    
        switch (state) {
        case GKPlayerConnectionState.StateConnected:
            // handle a new player connection.
            println("Player connected!");
    
            if !_matchStarted && match.expectedPlayerCount == 0 {
                println("Ready to start match!")
                self.lookupPlayers()
            }
        
            break
        case GKPlayerConnectionState.StateDisconnected:
            println("Player disconnected!");
            _matchStarted = false
            _delegate?.matchEnded()
            break
        
        case GKPlayerConnectionState.StateUnknown:
            break
        }
    
    }
    @objc func match(match: GKMatch!, shouldReinviteDisconnectedPlayer player: GKPlayer!) -> Bool {
            return true
    }
    
    
    // The match was unable to connect with the player due to an error.
    @objc func matchConnectionWithPlayerFailedWithError(match:GKMatch, playerID:NSString, error:NSError) {
    
        if _match != match { return }
    
        println("Failed to connect to player with error: %@", error.localizedDescription);
        _matchStarted = false
        _delegate?.matchEnded()
    }
    
    
    // The match was unable to be established with any players due to an error.
    @objc func match(match: GKMatch!, didFailWithError error: NSError!) {
    //func matchDidFailWithError(match: GKMatch, error:NSError) {
    
        if _match != match { return }
    
        println("Match failed with error: %@", error.localizedDescription)
        _matchStarted = false
        
        _delegate?.matchEnded()
    }
    
    
}
