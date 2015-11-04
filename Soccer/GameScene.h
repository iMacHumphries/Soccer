//
//  GameScene.h
//  Soccer
//

//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
@class GameViewController;
@interface GameScene : SKScene<SKPhysicsContactDelegate>{
    SKSpriteNode *ball;
    SKSpriteNode *field;
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    uint32_t PLAYER;
    uint32_t BALL;
    
    SKSpriteNode *player1;
    SKSpriteNode *player2;
    
    BOOL isP1Down;
    BOOL isP2Down;
    
    int playerScore1;
    int playerScore2;
    
    SKLabelNode *scoreLabel1;
    SKLabelNode *scoreLabel2;
    
    SKLabelNode *goalLabel;
    
    SKSpriteNode *pauseMenu;
    SKSpriteNode *quit;
    SKSpriteNode *resume;
    SKLabelNode *winner;
    
    BOOL isPaused;
    
    CGVector lastV;
    
    UIViewController *gameViewController;
    
    int goalLimit;
    BOOL gameOver;
    
    int difficulty;
    
    NSString *playerName1;
    NSString *playerName2;
}
-(void)setGameViewController:(UIViewController *)_gameView;
-(void)quit;
-(void)togglePause;
@end
