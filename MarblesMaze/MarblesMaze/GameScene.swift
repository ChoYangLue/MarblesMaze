//
//  GameScene.swift
//  MarblesMaze
//
//  Created by 15k1122 on 9/9/16.
//  Copyright (c) 2016 15k1122. All rights reserved.
//

import SpriteKit

import CoreMotion
//音楽再生用のフレームワーク
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // 各ノードを初期化
    let wallsNode = SKNode()
    var block: SKSpriteNode!
    //var goal = SKNode()
    let goal = SKSpriteNode(imageNamed:"goal.png")
    
    let background = SKSpriteNode(imageNamed:"background.jpg")
    
    let ballSprite = SKSpriteNode(imageNamed:"biidama_greenblue64.png")
    var ballVY:CGFloat = 0
    var ballVX:CGFloat = 0
    
    // BGM
    //var action : SKAction = SKAction.playSoundFileNamed("BGM02_main.mp3", waitForCompletion: true)
    
    //音楽ファイルをbackmusic.mp3とした場合
    let music = SKAudioNode.init(fileNamed: "BGM02_main.mp3")
    
    
    // スコアを用意しておく。Int!とか書いておくと何故かエラー…。
    var score: Int = 0
    var gameover: Int = 0
    
    // CMMotionManagerを生成.
    var manager: CMMotionManager!
    
    // 迷路作成用　変数
    var w = 14 // 幅（偶数）8
    var h = 10 // 高さ（偶数）13
    var x = 0
    var y = 0
    var maze: [[Int]] = []
    var last_y = 0
    //var mazey: [Int] = []
    
    var xx = 0
    var yy = 0
    var n:UInt32 = 0
    
    var lastX = 0
    var lastY = 0
    
    // フォントを指定しLabelを作成
    let myLabel = SKLabelNode(fontNamed: "Chalkduster")
    var time = 2000
    
    var GameFlag = true
    
    var location = CGPoint(x:0,y:0)
    
    // 衝突に使うBitMask.
    let ballCategory: UInt32 = 0x1 << 0
    let wallCategory: UInt32 = 0x1 << 1
    let goalCategory: UInt32 = 0x1 << 2
    
    func init_bg(){
        // 背景画像
        background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        background.size = self.size
        // zPositionを-1に設定
        background.zPosition = -1
        self.addChild(background)
        
        // BGMのループ設定
        //self.runAction(action)
        
        self.addChild(music)
        
        //プレイヤーとなるball画像
        ballSprite.position = CGPoint(x: self.size.width*0.5-64, y: self.size.height*0.5-64)
        ballSprite.zPosition = 3
        ballSprite.xScale = 0.5
        ballSprite.yScale = 0.5
        
        ballSprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.ballSprite.frame.size)
        ballSprite.physicsBody?.affectedByGravity = false
        
        ballSprite.name = "ball"
        
        self.addChild(ballSprite)

       
        
        
        // 迷路を作成
        
        // 準備 柱を作る
        for y in 0...h{
            var mazey: [Int] = []
            for x in 0...w{
                if (y % 2 == 0 && x % 2 == 0) {
                    // [偶数][偶数]
                    mazey.append(0)
                } else if (y % 2 != 0 && x % 2 != 0) {
                    // 奇数
                    mazey.append(1)
                } else {
                    // その他
                    mazey.append(0)
                }
            }
            maze.append(mazey)
        }
        //print(maze)
        
        
        // goal
        n = arc4random() % 2 // 0~1
        print(n)
        if (n==0) {
            maze[0][w] = 5
        } else if (n==1){
            maze[h][w] = 5
        }
        
        
    }
    
    func create_maze(){
        // 迷路を作成
        for y in 0...(h-1)/2 {
            for x in 1...w/2{
                last_y = (h+1)/2 - y
                yy = last_y*2-1
                xx = x*2-1
                
                //print("yy:%d",yy)
                //print("xx:%d",xx)
                
                if (maze[yy][xx-1]==2){
                    n = arc4random() % 2 // 0~1
                } else {
                    n = arc4random() % 3 // 0~2
                }
                if (y==(h-1)/2){
                    //n = arc4random() % 2 + 1// 0~1
                }
                
                switch n {
                case 0:
                    //処理 down
                    maze[yy-1][xx] = 3
                    break
                case 1:
                    //処理 right
                    maze[yy][xx+1] = 2
                    break
                case 2:
                    // 処理 left
                    maze[yy][xx-1] = 2
                    break
                case 3:
                    // 処理 up
                    maze[yy+1][xx] = 3
                    break
                default:
                    //処理
                    break
                }
                
            }
        }
        print(maze)
        
        /*
        n = arc4random() % 3 // 0~2
        for c in 0...n+1{
            n = arc4random() % 3 // 0~2
            if (maze[n][c]==0) {
                
            }
        }
        */
        
    }
    
    func draw_maze(){
        // 迷路を描画
        
        //wallsNode.position = CGPoint(x: 32,  y: 24)
        wallsNode.position = CGPoint(x: 32,  y: 66)
        self.addChild(wallsNode)
        
        wallsNode.name = "wall"
        
        //block.name = "block"
        
        
        
        for y in 0...h{
            for x in 0...w{
                switch maze[y][x] {
                case 1:
                    // 柱を表示
                    
                    self.block = SKSpriteNode(imageNamed:"wall64.jpg")
                    self.block.xScale = 0.5
                    self.block.yScale = 0.5
                    
                    // 当たり判定
                    //self.block.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(32,32))
                    self.block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
                    self.block.physicsBody?.allowsRotation = false
                    self.block.physicsBody?.dynamic = false
 
                    self.block.position = CGPoint(x: x*48,  y: y*48)
                    
                    // zPositionを0に設定
                    self.block.zPosition = 0
                    
                    
                    //let wallsprite = SKSpriteNode(imageNamed:"wall64.jpg")
                    
                    
                    wallsNode.addChild(self.block)
                    
                    break
                case 0:
                    break
                case 2:
                    // 壁を表示
                    
                    self.block = SKSpriteNode(imageNamed:"wall2.png")
                    self.block.xScale = 0.5
                    self.block.yScale = 0.5
                    
                    // 当たり判定
                    //self.block.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(32,32))
                    self.block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
                    self.block.physicsBody?.allowsRotation = false
                    self.block.physicsBody?.dynamic = false
                    
                    self.block.position = CGPoint(x: x*48,  y: y*48)
                    
                    // zPositionを0に設定
                    self.block.zPosition = 0
                    
                    wallsNode.addChild(self.block)
                    
                    break
                case 3:
                    // 壁を表示
                    
                    self.block = SKSpriteNode(imageNamed:"wall3.png")
                    self.block.xScale = 0.5
                    self.block.yScale = 0.5
                    
                    // 当たり判定
                    //self.block.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(32,32))
                    self.block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
                    self.block.physicsBody?.allowsRotation = false
                    self.block.physicsBody?.dynamic = false
                    
                    self.block.position = CGPoint(x: x*48,  y: y*48)
                    
                    // zPositionを0に設定
                    self.block.zPosition = 0
                    
                    wallsNode.addChild(self.block)
                    
                    break
                case 5:
                    // ゴールを表示
                    
                    // 当たり判定
                    //self.goal.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(32,32))
                    goal.physicsBody?.categoryBitMask = goalCategory
                    
                    //goal.physicsBody = SKPhysicsBody(rectangleOfSize: goal.frame.size)
                    goal.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 16))
                    goal.physicsBody?.allowsRotation = false
                    goal.physicsBody?.dynamic = false
                    
                    //goal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
                    goal.position = CGPoint(x: x*48,  y: y*48)
                    
                    goal.name = "goal"
                    
                    // zPositionを0に設定
                    goal.zPosition = 1
                    
                    wallsNode.addChild(goal)
                    //self.addChild(goal)
                    
                    
                    break
                default:
                    //処理
                    break
                }
            }
        }
        
        
    }

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Sceneに剛体を設定.
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        // 初期化
        init_bg()
        
        // 棒倒し法で迷路を作る
        create_maze()
        
        // 迷路を描画
        draw_maze()
        

        manager = CMMotionManager()
        
        //取得の間隔
        manager.accelerometerUpdateInterval = 0.1;
        let handler:CMAccelerometerHandler = {
            (data:CMAccelerometerData?, error:NSError?) -> Void in
         //print("x=\(data!.acceleration.x)")
         //print("y=\(data!.acceleration.y)")
         //print("z=\(data!.acceleration.z)")
            
            self.ballVX = CGFloat(data!.acceleration.x*5);
            self.ballVY = CGFloat(data!.acceleration.y*5);

        }
        
        //取得開始
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:handler)
        
        // フォントサイズを設定
        myLabel.fontSize = 40
        
        // 表示するポジションを指定
        myLabel.position = CGPoint(x:100, y:10)
        
        // 一番手前に表示
        myLabel.zPosition = 3
        
        // シーンに追加
        self.addChild(myLabel)
        
        // 剛体を生成.
        
        //self.wallsNode.physicsBody = SKPhysicsBody(rectangleOfSize: wallsNode.frame.size)
        //self.goal.physicsBody = SKPhysicsBody(rectangleOfSize: goal.frame.size)
        //self.block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)

        
        //　自身のカテゴリーを設定.
        
        
        self.ballSprite.physicsBody?.categoryBitMask = ballCategory
        self.wallsNode.physicsBody?.categoryBitMask = wallCategory
        
        //self.block.physicsBody?.categoryBitMask = wallCategory

        
        //　衝突先のBitMaskを設定.
        self.ballSprite.physicsBody?.contactTestBitMask = wallCategory
        self.wallsNode.physicsBody?.contactTestBitMask = ballCategory
        self.goal.physicsBody?.contactTestBitMask = ballCategory
        //self.block.physicsBody?.contactTestBitMask = ballCategory
        
        

        physicsWorld.contactDelegate = self

        
        
    }
    
    /*
     衝突が検知されたら呼ばれるメソッド
     */
    func didBeginContact(contact: SKPhysicsContact) {
        
        print("contactBodyA: \(contact.bodyA.node?.name)")
        print("contactBodyB: \(contact.bodyB.node?.name)")
        
        if (contact.bodyB.node?.name == "goal") {
            GameFlag = false
        }
        
        //まず、チエック用の定数を用意
        let player_enemy = ballCategory | wallCategory //playerとenemy
        let player_coin = ballCategory | goalCategory //playerとcoin
        
        //衝突ノードの和
        let check = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        //判定
        if (player_enemy == check){
            //self.paused = true
            //enemyと衝突した場合の処理
            print("wall")
        }
        else if (player_coin == check){
            //coinと衝突した場合の処理
            print("goal")
            GameFlag = false
        }
        
        
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        // タッチでも移動できるようにする
        for touch in touches {
            location = touch.locationInNode(self)
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        // 時間を更新
        time -= 1
        
        let str: String = String(time)
        myLabel.text = str
        
        if (time==0){
            gameover = 1
            GameFlag = false
        }
        
        //画面の外に出たら、反対側に移動
        if(ballSprite.position.x < 16){
            self.ballVX = 0
            self.ballSprite.position.x += 1
        }else if(ballSprite.position.x > self.frame.width - 16){
            self.ballVX = 0
            self.ballSprite.position.x -= 1
        }
        if(ballSprite.position.y < 48){
            self.ballVY = 0
            self.ballSprite.position.y += 1
        }else if(ballSprite.position.y > self.frame.height - 16){
            self.ballVY = 0
            self.ballSprite.position.y -= 1
        }
        
        //ターゲットマーカーの場所にプレイヤーを移動させる。
        if(self.ballSprite.position.x < location.x-1){
            self.ballSprite.position.x += speed;
        }else if(self.ballSprite.position.x > location.x+1){
            self.ballSprite.position.x -= speed;
        }
        if(self.ballSprite.position.y < location.y-1){
            self.ballSprite.position.y += speed;
        }else if(self.ballSprite.position.y > location.y+1){
            self.ballSprite.position.y -= speed;
        }
        

        self.ballSprite.position.x += self.ballVX
        self.ballSprite.position.y += self.ballVY
        
        if (ballSprite.position.x>self.size.width*0.5+80) {
            // right
            if (wallsNode.position.x>self.size.width*(-1)-64){
                wallsNode.position.x-=2;
            }
        } else if (ballSprite.position.x<self.size.width*0.5-80) {
            //left
            if (wallsNode.position.x<32){
                wallsNode.position.x+=2;
            }
        }
        //print(wallsNode.position.x)
        

        if (GameFlag == false){
            score = time
            
            // ユーザデフォルトにスコアを格納。
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setInteger(score, forKey: "score")
            
            ud.setInteger(gameover, forKey: "gameover")
            
            let newScene = ResultScene(size: self.scene!.size)
            newScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view!.presentScene(newScene)
        }
        
    }
}