//
//  GameViewController.m
//  BreakingBricks
//
//  Created by Fenkins on 15/07/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

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


@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // That line will set the scene size to the size of the phone screen
    scene.size = skView.bounds.size;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
