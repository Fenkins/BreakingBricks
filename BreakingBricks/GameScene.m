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

@end

static const uint32_t ballCategory  = 1; // 00000000000000000000000000000001
static const uint32_t brickCategory = 2; // 00000000000000000000000000000010
static const uint32_t paddleCategory = 4;// we wonna flip just one bit, no more, no less
static const uint32_t edgeCategory = 8;  // 00000000000000000000000000001000

/*
 // these are effectively the same
 static const uint32_t ballCategory = 0x1;
 static const uint32_t brickCategory = 0x1 << 1;
 static const uint32_t paddleCategory = 0x1 << 2;
 static const uint32_t edgeCategory = 0x1 << 3;
 */



@implementation GameScene

-(void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"boing");
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x, 100);
        if (location.x <= self.paddle.size.width/2) {
            self.paddle.position = CGPointMake(self.paddle.size.width/2, 100);
        } else if (location.x >= self.frame.size.width - self.paddle.size.width/2) {
            self.paddle.position = CGPointMake(self.frame.size.width - self.paddle.size.width/2, 100);
        } else self.paddle.position = newPosition;
    }
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
    // What categories we are interested to receive notifications about contact
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory;
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
    self.physicsWorld.gravity = CGVectorMake(0.0, -2.0);
    
    // Setting the contactDelegate to listen contacts from .self
    self.physicsWorld.contactDelegate = self;
    
    [self addBall];
    [self addPlayer];
    [self addBricks];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
