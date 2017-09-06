//
//  ResultScene.swift
//  MarblesMaze
//
//  Created by 15k1122 on 9/9/16.
//  Copyright © 2016 15k1122. All rights reserved.
//

import SpriteKit

class ResultScene: SKScene {
    
    var action : SKAction = SKAction.playSoundFileNamed("BGM03.mp3", waitForCompletion: true)
    
    override func didMoveToView(view: SKView) {
        
        self.runAction(action)
        
        // スコアとハイスコアをユーザデフォルトから取っておく。
        let ud = NSUserDefaults.standardUserDefaults()
        let score = ud.integerForKey("score")
        let gameover = ud.integerForKey("gameover")
        var hi_score = ud.integerForKey("hi_score")
        
        // スコアを表示
        let scoreLabel = SKLabelNode(fontNamed:"Copperplate")
        scoreLabel.text = "SCORE:\(score)";
        scoreLabel.fontSize = 72;
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(scoreLabel)
        
        
        // スコアがハイスコアを上回ったら、ハイスコアを更新！
        if score > hi_score {
            ud.setInteger(score, forKey: "hi_score")
            hi_score = score
        }
        
        // ハイスコアを表示。
        let hiLabel = SKLabelNode(fontNamed:"Copperplate")
        hiLabel.text = "過去最高得点:\(hi_score)";
        hiLabel.fontSize = 36;
        hiLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-200);
        self.addChild(hiLabel)
 
        if (gameover == 1){
            let gamestateLabel = SKLabelNode(fontNamed: "Copperplate")
            gamestateLabel.text = "Game Over"
            gamestateLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 380)
            self.addChild(gamestateLabel)
        } else {
            let gamestateLabel = SKLabelNode(fontNamed: "Copperplate")
            gamestateLabel.text = "Game Clear"
            gamestateLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 380)
            self.addChild(gamestateLabel)
        }
        
        
        
        // 戻るための「Back」ラベルを作成。
        let backLabel = SKLabelNode(fontNamed: "Copperplate")
        backLabel.text = "Back"
        backLabel.fontSize = 36
        backLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 200)
        backLabel.name = "Back"
        self.addChild(backLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            //BACKをタップすると戻る
            if (touchedNode.name != nil) {
                if (touchedNode.name == "Back"){
                    let newScene = TitleScene(size: self.scene!.size)
                    newScene.scaleMode = SKSceneScaleMode.AspectFill
                    self.view!.presentScene(newScene)
                }
            }
        }
    }
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let location = touches.locationInNode(self)
        //let touch: AnyObject = touches.anyObject()
        let location = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)
        
        if touchedNode.name {
            if touchedNode.name == "Back" {
                
                let newScene = TitleScene(size: self.scene.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                self.view.presentScene(newScene)
            }
        }
    }*/
    
    override func update(currentTime: CFTimeInterval) {}
}
