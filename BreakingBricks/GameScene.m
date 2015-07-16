//
//  GameScene.m
//  BreakingBricks
//
//  Created by Fenkins on 15/07/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    
    
    // Adding physics to the scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

    
    NSLog(@"Width of the screen %f",self.size.width);
    NSLog(@"Height of the screen %f",self.size.height);
    
    
    // Changing gravity settings
    self.physicsWorld.gravity = CGVectorMake(0.0, -5.0);
    
    
    // Setting up the ball
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    ball.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame));
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.height/2];
    [self addChild:ball];
    
    // Creating vector
    CGVector myVector = CGVectorMake(50.0, 20.0);
    // Applying vector to physicsBody
    [ball.physicsBody applyImpulse:myVector];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
