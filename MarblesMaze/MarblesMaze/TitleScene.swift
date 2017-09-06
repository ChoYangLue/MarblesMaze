//
//  TitleScene.swift
//  MarblesMaze
//
//  Created by 15k1122 on 9/9/16.
//  Copyright © 2016 15k1122. All rights reserved.
//

import SpriteKit

//新しく作った名前「TitleScene」でSKSceneを生成する
class TitleScene: SKScene {
    
    //var title: SKSpriteNode!  各ノードを初期化
    let title = SKSpriteNode(imageNamed:"title0.jpg")
    let startLabel = SKLabelNode(fontNamed: "Copperplate")
    
    let sound = SKAction.playSoundFileNamed("BGM00.mp3", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        //スタート画面のタイトル用のラベルを作成する
        
        // 背景
        title.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        title.size = self.size
        // zPositionを-1に設定
        title.zPosition = -1
        self.addChild(title)
        
        // BGM
        self.runAction(sound)
        
        // 「Start」を表示。
        startLabel.text = "Start"
        startLabel.fontSize = 36
        startLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 200)
        //タップしたときの名前を設定する
        startLabel.name = "Start"
        self.addChild(startLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            //STARTをタップするとゲームを始めるようにする
            if (touchedNode.name != nil) {
                if (touchedNode.name == "Start"){
                    let newScene = GameScene(size: self.scene!.size)
                    newScene.scaleMode = SKSceneScaleMode.AspectFill
                    self.view!.presentScene(newScene)
                }
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
