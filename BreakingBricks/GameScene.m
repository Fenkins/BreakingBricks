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

@implementation GameScene

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
    // add to the scene
    [self addChild:self.paddle];
}

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    
    
    // Adding physics to the scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

    
    NSLog(@"Width of the screen %f",self.size.width);
    NSLog(@"Height of the screen %f",self.size.height);
    
    
    // Changing gravity settings
    self.physicsWorld.gravity = CGVectorMake(0.0, -4.0);
    
    
    [self addBall];
    [self addPlayer];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
