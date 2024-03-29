//
//  MyScene.m
//  breakingBricks
//
//  Created by Harold_Davis on 4/13/14.
//  Copyright (c) 2014 Zendoart, inc. All rights reserved.
//

#import "MyScene.h"
#import "EndScene.h"


@interface MyScene ()

@property (nonatomic) SKSpriteNode *paddle;

@end

static const uint32_t ballCategory   = 1; // 0000000000000000000001
static const uint32_t brickCategory  = 2; // 0000000000000000000010
static const uint32_t paddleCategory = 4; // 0000000000000000000100
static const uint32_t edgeCatagory   = 8; // 0000000000000000001000
static const uint32_t bottomEdgeCategory = 16;
//static
/*static const uint32_t ballCategory   = 0x1;
    static const uint32_t ballCategory   = 0x1 << 1;
    static const uint32_t ballCategory   = 0x1 << 2;
    etc.

*/

@implementation MyScene

-(void)didBeginContact:(SKPhysicsContact *)contact {
//    if (contact.bodyA.categoryBitMask == brickCategory) {
//        NSLog(@"bodyA is a brick");
//        [contact.bodyA.node removeFromParent];
//    }
//    if (contact.bodyB.categoryBitMask == brickCategory) {
//        NSLog(@"bodyB is a brick");
//        [contact.bodyB.node removeFromParent];
//    }
//
    SKPhysicsBody *notTheBall;
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
        }else {
        notTheBall = contact.bodyA;
    
    
        }
        if (notTheBall.categoryBitMask == brickCategory) {
            SKAction *playSFX = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
            [self runAction:playSFX];
            [notTheBall.node removeFromParent];
        }
    
        if (notTheBall.categoryBitMask == paddleCategory) {
            SKAction *playSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
            [self runAction:playSFX];
        }
        if (notTheBall.categoryBitMask == bottomEdgeCategory) {
            EndScene *end = [EndScene sceneWithSize:self.size];
            
            [self.view presentScene:end transition:[SKTransition doorsCloseHorizontalWithDuration:1.0]];
        }

    

}

-(void) addBottomEdge:(CGSize) size {
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    [self addChild:bottomEdge];


}

- (void)addBall:(CGSize)size {
    //setting a vector???
    
    
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    CGPoint myPoint = CGPointMake(size.width/2, size.height/2);
    
    ball.position = myPoint;
    
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    
    ball.physicsBody.linearDamping = 0;
    
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCategory;
    //example ball.physicsBody.collisionBitMask = edgeCatagory | brickCategory;
    
    
    [self addChild:ball];
    
    // create vector
    CGVector myVector = CGVectorMake(10, 10);
    //apply vector
    [ball.physicsBody applyImpulse:myVector];
    
    ball.physicsBody.friction = 0;
    
}

-(void) addBricks:(CGSize) size {

    for (int i = 0; i < 4; i++) {
        SKSpriteNode * brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        // add a static physics body
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        brick.physicsBody.dynamic = NO;
        brick.physicsBody.categoryBitMask = brickCategory;
        
        
        
        int xPos = size.width/5 * (i+1);
        int yPos = size.height - 50;
        brick.position = CGPointMake(xPos, yPos);
        
        [self addChild:brick];
        
        
    }

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x, 100);
        
        //stop the paddle from going to far
        if (newPosition.x < self.paddle.size.width / 2){
            newPosition.x = self.paddle.size.width / 2;
        
        }
        if (newPosition.x > self.size.width - (self.paddle.size.width/2)) {
            newPosition.x = self.size.width - (self.paddle.size.width/2);
        }
        self.paddle.position =newPosition;
    }
}

-(void) addPlayer:(CGSize)size {
    //create paddle sprite...
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    self.paddle.position = CGPointMake(size.width/2,100);
    
    //add a physicsbody
    self.paddle.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    
    // make it static
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    
    
    //add paddle
    [self addChild:self.paddle];
   


}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCatagory;
        
        // setting gravity...
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        
        [self addBall:size];
        [self addPlayer:size];
        [self addBricks:size];
        [self addBottomEdge:size];
        
        
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
