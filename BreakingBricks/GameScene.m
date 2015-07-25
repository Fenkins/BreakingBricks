//
//  GameScene.m
//  BreakingBricks
//
//  Created by Fenkins on 15/07/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (nonatomic) SKSpriteNode *paddle;

@property (strong,nonatomic) SKAction *playBallBlipSound;
@property (strong,nonatomic) SKAction *playBrickHitSound;

@end

static const uint32_t ballCategory  = 1; // 00000000000000000000000000000001
static const uint32_t brickCategory = 2; // 00000000000000000000000000000010
static const uint32_t paddleCategory = 4;// we wonna flip just one bit, no more, no less
static const uint32_t edgeCategory = 8;  // 00000000000000000000000000001000
static const uint32_t bottomEdgeCategory = 16; // line at the bottom of the screen

/*
 // these are effectively the same
 static const uint32_t ballCategory = 0x1;
 static const uint32_t brickCategory = 0x1 << 1;
 static const uint32_t paddleCategory = 0x1 << 2;
 static const uint32_t edgeCategory = 0x1 << 3;
 */



@implementation GameScene

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *notTheBall;
    // Detecting whether if bodyA or bodyB is or is not the ball, this is based on the fact that ball has a smallest category number (00...01)
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
    } else {
        notTheBall = contact.bodyA;
    }
    
    // So we determined notTheBrick contacts, now we could figure out when the ball is contacting with the bricks to remove them
    if (notTheBall.categoryBitMask == brickCategory) {
        [self runAction:self.playBrickHitSound];
        [notTheBall.node removeFromParent];
    }
    if (notTheBall.categoryBitMask == paddleCategory) {
        [self runAction:self.playBallBlipSound];
    }
    if (notTheBall.categoryBitMask == bottomEdgeCategory) {
        EndScene *end = [EndScene sceneWithSize:self.size];
        [self.view presentScene:end transition:[SKTransition doorsCloseHorizontalWithDuration:0.4]];
    }
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x, 100);
        // limiting the place where the paddle could go on the screen
        if (location.x <= self.paddle.size.width/2) {
            self.paddle.position = CGPointMake(self.paddle.size.width/2, 100);
        } else if (location.x >= self.frame.size.width - self.paddle.size.width/2) {
            self.paddle.position = CGPointMake(self.frame.size.width - self.paddle.size.width/2, 100);
        } else self.paddle.position = newPosition; // setting the paddle position according to touches position
    }
}

- (void)addBottomEdge {
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(self.size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    [self addChild:bottomEdge];
}

- (void)addBricks {
    for (int i=0; i<4; i++) {
        SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        // adding a physics body
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        brick.physicsBody.dynamic = NO;
        // Giving the brick its own category
        brick.physicsBody.categoryBitMask = brickCategory;
        
        int xPos = self.frame.size.width/5 * (i+1);
        int yPos = self.frame.size.height - 50;
        brick.position = CGPointMake(xPos, yPos);
        [self addChild:brick];
    }
}

- (void)addBall {
    // Setting up the ball
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    ball.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame));
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.height/2];
    // The roughness of the surface of the physicsBody
    ball.physicsBody.friction = 0.000001;
    // The resistance ball encounters while moving trough the scene
    ball.physicsBody.linearDamping = 0;
    // Bounciness of the physicsBody
    ball.physicsBody.restitution = 1;
    // Giving the ball its own category
    ball.physicsBody.categoryBitMask = ballCategory;
    // What categories we are interested to receive notifications about contact (didBeginContact or didEndContact)
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCategory;
    // CollisionMask are all on by default (0000 etc) by overriding its behaviour we are making it (0000 etc) so ball will interact only with categories named below
    //ball.physicsBody.collisionBitMask = edgeCategory | paddleCategory;
    
    // Add the sprite node to the scene
    [self addChild:ball];
    
    // Creating vector
    CGVector myVector = CGVectorMake(20.0, 10.0);
    // Applying vector to physicsBody
    [ball.physicsBody applyImpulse:myVector];
}

-(void) addPlayer {
    // create a paddle sprite
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    // positioning it
    self.paddle.position = CGPointMake(self.frame.size.width/2, 100);
    // add a physics body
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    // make it static
    self.paddle.physicsBody.dynamic = NO;
    // Giving the paddle its own category
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    
    // add to the scene
    [self addChild:self.paddle];
}

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    
    
    // Adding physics to the scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // Giving the edge of the screen its own category
    self.physicsBody.categoryBitMask = edgeCategory;

    
    NSLog(@"Width of the screen %f",self.size.width);
    NSLog(@"Height of the screen %f",self.size.height);
    
    
    // Changing gravity settings
    self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
    
    // Setting the contactDelegate to listen contacts from .self
    self.physicsWorld.contactDelegate = self;
    
    [self addBall];
    [self addPlayer];
    [self addBricks];
    [self addBottomEdge];
    
    // init sounds
    self.playBallBlipSound = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
    self.playBrickHitSound = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
