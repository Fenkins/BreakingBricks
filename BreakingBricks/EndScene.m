//
//  EndScene.m
//  BreakingBricks
//
//  Created by Fenkins on 23/07/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "EndScene.h"

@implementation EndScene

-(void) didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    endGameLabel.text = @"Game Over";
    endGameLabel.color = [SKColor whiteColor];
    endGameLabel.fontSize = 50;
    endGameLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:endGameLabel];
}

@end
