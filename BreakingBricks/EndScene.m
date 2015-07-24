//
//  EndScene.m
//  BreakingBricks
//
//  Created by Fenkins on 23/07/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "EndScene.h"

@interface EndScene()
@property (strong,nonatomic) SKAction *playGameOverSound;
@end

@implementation EndScene

-(void) didMoveToView:(SKView *)view {
    self.playGameOverSound = [SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:NO];
    [self runAction:self.playGameOverSound];
    
    self.backgroundColor = [SKColor blackColor];
    SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    endGameLabel.text = @"Game Over";
    endGameLabel.color = [SKColor whiteColor];
    endGameLabel.fontSize = 50;
    endGameLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

    SKLabelNode *restartGame = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    restartGame.text = @"Touch the screen to restart";
    restartGame.color = [SKColor whiteColor];
    restartGame.fontSize = 25;
    restartGame.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.height/10);
    
    [self addChild:endGameLabel];
    [self addChild:restartGame];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *scene = [GameScene sceneWithSize:self.size];
    [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:0.3]];
}

@end
