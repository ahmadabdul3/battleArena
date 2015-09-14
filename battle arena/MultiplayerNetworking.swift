//
//  MultiplayerNetworking.swift
//  battle arena
//
//  Created by Abdul on 9/5/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

protocol MultiplayerNetworkingProtocol {
    func matchEnded()
    func setCurrentPlayerIndex(index:Int)
    func movePlayerAtIndex(/*index:Int*/posX:CGFloat, posY:CGFloat)
    func syncRemotePlayerPosition(posX:CGFloat, posY:CGFloat)
    func gameOver(player1Won: Bool)
    func setPlayerAliases(playerAliases:NSArray)
}



import Foundation
import GameKit

//#define playerIdKey @"PlayerId"
//#define randomNumberKey @"randomNumber"

enum GameState:Int {
    case kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
};

enum MessageType: Int {
    case kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeGameOver,
    KMessageTypeSyncRemotePlayerPosition
}

struct Message {
    var messageType : MessageType
}

struct MessageRandomNumber {
    var message:Message
    var randomNumber: UInt32
}

struct MessageGameBegin {
    var message:Message
}

struct MessageMove {
    var message:Message
    var positionX: CGFloat
    var positionY: CGFloat
}

struct MessageGameOver {
    var message:Message
    var player1Won:Bool
}
struct MessageSyncRemotePlayerPosition {
    var message:Message
    var positionX:CGFloat
    var positionY:CGFloat
}

class MultiplayerNetworking : GameKitHelperDelegate {
    
    let playerIdKey = "PlayerId"
    let randomNumberKey = "randomNumber"
    var _ourRandomNumber: UInt32 = arc4random()
    var _gameState: GameState = GameState.kGameStateWaitingForMatch
    var _isPlayer1 = false
    var _receivedAllRandomNumbers = false
    var delegate:MultiplayerNetworkingProtocol?
    var gameKitHelper = GameKitHelper()
    var randomNumberLimit:UInt32 = 100
    var _orderOfPlayers:NSMutableArray = NSMutableArray()
    
//    func encode<T>(var value: T) -> NSData {
//        return withUnsafePointer(&value) { p in
//            NSData(bytes: p, length: sizeofValue(value))
//        }
//    }
//    
//    func decode<T>(data: NSData) -> T {
//        let pointer = UnsafeMutablePointer<T>.alloc(sizeof(T.Type))
//        data.getBytes(pointer)
//        
//        return pointer.move()
//    }
    init()
    {
        var dictionary:Dictionary = [playerIdKey: GKLocalPlayer.localPlayer().playerID, randomNumberKey: String(_ourRandomNumber)]
        _orderOfPlayers.addObject(dictionary)
    }
    convenience init(gameKitHelper:GameKitHelper) {
        self.init()
        self.gameKitHelper = gameKitHelper
    }
    
    func sendData(data:NSData)
    {
        var error = NSErrorPointer()
        //var gameKitHelper = GameKitHelper() //[GameKitHelper sharedGameKitHelper];
        
        var success = gameKitHelper._match?.sendDataToAllPlayers(data, withDataMode: GKMatchSendDataMode.Reliable, error: error)
        
        
        if let localSuccess = success {
            if !localSuccess {
                println("Error sending data:")
            }
            println("Successfully started sending data")
            //println("Error sending data:%@", error.localizedDescription)
            //[self matchEnded];
        }
    }
    func sendSyncRemotePlayerPosition(posX:CGFloat, posY:CGFloat) {
        let message = Message(messageType: MessageType.KMessageTypeSyncRemotePlayerPosition)
        var messageSync = MessageSyncRemotePlayerPosition(message: message, positionX: posX, positionY: posY)
        var data = NSData(bytes: &messageSync, length: sizeof(MessageSyncRemotePlayerPosition)) //[NSData dataWithBytes:&messageMove length:sizeof(MessageMove)];
        sendData(data)
    }
    
    func sendMove(posX:CGFloat, posY:CGFloat) {
        let message = Message(messageType: MessageType.kMessageTypeMove)
        var messageMove = MessageMove(message: message, positionX: posX, positionY: posY)
        //messageMove.message.messageType = MessageType.kMessageTypeMove;
        var data = NSData(bytes: &messageMove, length: sizeof(MessageMove)) //[NSData dataWithBytes:&messageMove length:sizeof(MessageMove)];
        sendData(data)
    }
    
    func sendRandomNumber()
    {
        //_ourRandomNumber = arc4random()
        var message = Message(messageType: MessageType.kMessageTypeRandomNumber)
        var messageRandNum = MessageRandomNumber(message: message, randomNumber: _ourRandomNumber)
        var data = NSData(bytes: &messageRandNum, length: sizeof(MessageRandomNumber)) //[NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
        sendData(data)
    }
    
    func sendGameBegin() {
        
        var message = Message(messageType: MessageType.kMessageTypeGameBegin)
        var messageGameBegin = MessageGameBegin(message: message)
        var data = NSData(bytes: &messageGameBegin, length: sizeof(MessageGameBegin)) //[NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
        sendData(data)
        
    }
    
    func sendGameEnd(player1Won:Bool) {
        var message = Message(messageType: MessageType.kMessageTypeGameOver)
        var messageGameOver = MessageGameOver(message: message, player1Won: player1Won)
        var data = NSData(bytes: &messageGameOver, length: sizeof(MessageGameOver)) //[NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
        sendData(data)
    }
    
    func indexForLocalPlayer() -> Int
    {
        var playerId = GKLocalPlayer.localPlayer().playerID;
        return indexForPlayerWithId(playerId)//[self indexForPlayerWithId:playerId];
    }
    
    func indexForPlayerWithId(playerId:String) -> Int
    {
        println("indexForPlayerWithId")
        var index = -1
        _orderOfPlayers.enumerateObjectsUsingBlock(
            {(obj, idx, stop) -> Void in
                var dictObj = obj as! NSDictionary
                var pId: AnyObject? = dictObj[self.playerIdKey]
                if(pId!.isEqualToString(playerId)) {
                    index = idx
                    //stop = true
                }
            }
        )
        println(index)
        return index;
    }
    
    func tryStartGame()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.pvpConnEstablishedString, object: nil)
        println("tryStartGame")
        if (_isPlayer1 && _gameState == GameState.kGameStateWaitingForStart) {
            _gameState = GameState.kGameStateActive;
            sendGameBegin()
            
            //first player
            delegate!.setCurrentPlayerIndex(0)
            processPlayerAliases();
            
            
        }
    }
    
    func allRandomNumbersAreReceived() -> Bool
    {
        println("allrandomNumbersAreReceived")
        var receivedRandomNumbers = NSMutableArray()
        //[NSMutableArray array];
        
        for dict in _orderOfPlayers {
            if let randomNumberObject = dict[randomNumberKey] {
                println(randomNumberObject)
                receivedRandomNumbers.addObject(randomNumberObject)
            }
        }
        var set = NSSet(array: receivedRandomNumbers as [AnyObject])
        var arrayOfUniqueRandomNumbers:NSArray = set.allObjects as NSArray
        
        if let playercount = gameKitHelper._match?.players.count { //GameKitHelper.sharedGameKitHelper()._match?.players.count {
            if (arrayOfUniqueRandomNumbers.count == playercount + 1) {
                //[GameKitHelper sharedGameKitHelper].match.playerIDs.count + 1) {
                return true;
            }
        }
        return false;
    }
    
    func processReceivedRandomNumber(randomNumberDetails:NSDictionary) {
        println("processReceivedRandomNumber")
        if _orderOfPlayers.containsObject(randomNumberDetails) {
            _orderOfPlayers.removeObjectAtIndex(_orderOfPlayers.indexOfObject(randomNumberDetails))
        }
        _orderOfPlayers.addObject(randomNumberDetails)
        var sortByRandomNumber = NSSortDescriptor(key: randomNumberKey, ascending: false)
        _orderOfPlayers.sortUsingDescriptors([sortByRandomNumber])
        
        if allRandomNumbersAreReceived() {
            _receivedAllRandomNumbers = true;
        }
    }
    
    func processPlayerAliases() {
        println("processPlayerAliases")
        if (allRandomNumbersAreReceived()) {
            var playerAliases = NSMutableArray(capacity: _orderOfPlayers.count)
            for playerDetails in _orderOfPlayers {
                var playerId = playerDetails[playerIdKey]
                if let playerIdAlias = gameKitHelper.playersDict[playerId]?.alias { //GameKitHelper.sharedGameKitHelper().playersDict[playerId]?.alias {
                    playerAliases.addObject(playerIdAlias)
                }
            }
            if playerAliases.count > 0 {
                self.delegate!.setPlayerAliases(playerAliases)
            }
        }
    }
    
    func isLocalPlayerPlayer1() -> Bool
    {
        println("isLocalPlayerPalyer1")
        var dictionary:NSDictionary = _orderOfPlayers[0] as! NSDictionary
        if (dictionary[playerIdKey]!.isEqualToString(GKLocalPlayer.localPlayer().playerID)) {
            println("I'm player 1")
            return true
        }
        return false
    }
    
    //#pragma mark GameKitHelper delegate methods
    
    func matchStarted() {
        println("matchStarted")
        println("Match has started successfully")
        if (_receivedAllRandomNumbers) {
            _gameState = GameState.kGameStateWaitingForStart;
        } else {
            _gameState = GameState.kGameStateWaitingForRandomNumber;
        }
        sendRandomNumber()
        tryStartGame()
    }
    
    func matchEnded() {
        println("Match has ended");
        //[_delegate matchEnded];
    }
    
    
    
    func match(match: GKMatch!,
        didReceiveData data: NSData!,
        fromRemotePlayer player: GKPlayer!) {
    //func matchDidReceiveDataFromPlayer(match: GKMatch, data: NSData, player: GKPlayer) {
        //var mbyes = data.bytes
        println("matchDidReceiveData")
            var message = UnsafePointer<Message>(data.bytes).memory
        //var message:Message = unsafeBitCast(data.bytes, Message.self) //data.bytes as Message
        if (message.messageType == MessageType.kMessageTypeRandomNumber) {
            var messageRandomNumber = UnsafePointer<MessageRandomNumber>(data.bytes).memory //as MessageRandomNumber
            NSLog("Received random number:%d", messageRandomNumber.randomNumber)
            
            var tie = false
            if (messageRandomNumber.randomNumber == _ourRandomNumber) {
                println("Tie");
                tie = true;
                _ourRandomNumber = arc4random();
                sendRandomNumber()
            } else {
                var dictionary:Dictionary = [playerIdKey : player.playerID, randomNumberKey : String(messageRandomNumber.randomNumber)]
                processReceivedRandomNumber(dictionary)
            }
            if (_receivedAllRandomNumbers) {
                _isPlayer1 = isLocalPlayerPlayer1()
            }
            
            if (!tie && _receivedAllRandomNumbers) {
                if _gameState == GameState.kGameStateWaitingForRandomNumber {
                    _gameState = GameState.kGameStateWaitingForStart;
                }
                tryStartGame()
            }
        } else if (message.messageType == MessageType.kMessageTypeGameBegin) {
            println("Begin game message received");
            _gameState = GameState.kGameStateActive;
            delegate!.setCurrentPlayerIndex(indexForLocalPlayer())
            processPlayerAliases()
        } else if (message.messageType == MessageType.kMessageTypeMove) {
            println("Move message received");
            var messageMove = UnsafePointer<MessageMove>(data.bytes).memory// data.bytes as MessageMove
            
            delegate!.movePlayerAtIndex(/*indexForPlayerWithId(player.playerID)*/messageMove.positionX, posY:messageMove.positionY)
        } else if(message.messageType == MessageType.kMessageTypeGameOver) {
            println("Game over message received");
            var messageGameOver = UnsafePointer<MessageGameOver>(data.bytes).memory//, MessageGameOver.self)// data.bytes as MessageGameOver;
            delegate!.gameOver(messageGameOver.player1Won)
        } else if message.messageType == MessageType.KMessageTypeSyncRemotePlayerPosition {
            var messageSync = UnsafePointer<MessageSyncRemotePlayerPosition>(data.bytes).memory
            delegate!.syncRemotePlayerPosition(messageSync.positionX, posY: messageSync.positionY)
        }
    }
}