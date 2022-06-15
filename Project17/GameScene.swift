//
//  GameScene.swift
//  Project17
//
//  Created by Olibo moni on 20/02/2022.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "tv", "hammer"]
    var gameTimer : Timer?
    var isGameOver = false
    
    var score = 0 {
        didSet{
            scoreLabel.text = "score:" + "\(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
       
            starfield = SKEmitterNode(fileNamed: "starfield")!
            starfield.position = CGPoint(x: 1024, y: 384)
            starfield.advanceSimulationTime(10)
            addChild(starfield)
            
            starfield.zPosition = -1
        
        
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer: )))
        self.view?.addGestureRecognizer(pinchRecognizer)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300{
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
        
       
        
        
    }
    
    @objc func createEnemy(){
        guard let enemy = possibleEnemies.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: enemy)
        if !isGameOver{
            sprite.position = CGPoint(x: 1000, y: CGFloat.random(in: 50...736))
            addChild(sprite)
        }
        
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668{
            location.y = 668
        }
        player.position = location
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        isGameOver = true
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        
    
        let gameOver = SKLabelNode(fontNamed: "Chalkduster")
        gameOver.text = "Game Over"
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.fontSize = 65
        gameOver.zPosition = 1
        gameOver.horizontalAlignmentMode = .center
        addChild(gameOver)
        
        gameOverLabel = SKLabelNode(fontNamed: "chalkDuster")
        gameOverLabel.text = "Pinch to restart"
        gameOverLabel!.position = CGPoint(x: 512, y: 600)
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .red
        gameOverLabel!.zPosition = 1
        addChild(gameOverLabel)
        
        return
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        player.position = location
    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer){
        if recognizer.state == .ended {
            restartGame()
        }
    }
    
    @objc func restartGame(){
         isUserInteractionEnabled = true
         isGameOver = false
        
        let transition = SKTransition.fade(with: .white, duration: 2)
        let restartScene = GameScene()
        restartScene.size = CGSize(width: 1024, height: 768)
        
        self.view?.presentScene(restartScene, transition: transition)
        
     }
    
}
