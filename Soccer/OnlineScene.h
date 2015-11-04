//
//  OnlineScene.h
//  Soccer
//
//  Created by Benjamin Humphries on 12/1/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import "GameScene.h"
#import "OnlineViewController.h"
#import "GCHelper.h"
typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeMovePosition,
    kMessageTypeMoveBall,
    kMessageTypeGameBegin,
    kMessageTypeGameOver
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t x;
    uint32_t y;
} MessagePosition;

typedef struct {
    Message message;
    uint32_t x;
    uint32_t y;
} MessageBallPosition;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;

@class  OnlineViewController;
@interface OnlineScene : GameScene <GCHelperDelegate>{
    OnlineViewController *onlineViewController;
    BOOL matchBegan;
    BOOL isHost;
    uint32_t ourRandom;
    BOOL receivedRandom;
    GameState gameState;
}
@property (retain, nonatomic) OnlineViewController *onlineViewController;

- (void)sceneDidAppear;
-(void)updatePos:(CGPoint )pos;
@end
