//
//  OnlineScene.m
//  Soccer
//
//  Created by Benjamin Humphries on 12/1/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import "OnlineScene.h"

@implementation OnlineScene
@synthesize onlineViewController;

-(void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
     ourRandom = arc4random();
    [[GCHelper sharedInstance] setDelegate:self];
    
}
- (void)sceneDidAppear{
    [[GCHelper sharedInstance]findMatchWithMinPlayers:2 maxPlayers:2 viewController:self.onlineViewController delegate:self];
}
-(void)updatePos:(CGPoint )pos{
    
    NSLog(@"called");
    const int MIDDLE = screenHeight/2;
    
    if (pos.y > MIDDLE)
    {
        if (isP2Down)
            [player2 setPosition:pos];
        else {
            isP2Down = true;
            [player2 setPosition:pos];
            [self addChild:player2];
        }
    }
    else if (pos.y < MIDDLE)
    {
        if (isP1Down)
            [player1 setPosition:pos];
        else {
            isP1Down = true;
            [player1 setPosition:pos];
            [self addChild:player1];
        }
    }
    
}
-(void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    for (UITouch *touch in touches)
    {
        CGPoint loc = [touch locationInNode:self];
         [self sendMovePositionX:loc.x Y:loc.y];
        if (matchBegan && isHost)
        {
            [self sendBallPositionX:ball.position.x Y:ball.position.y];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    for (UITouch *touch in touches)
    {
        CGPoint loc = [touch locationInNode:self];
        [self sendMovePositionX:loc.x Y:loc.y];
        if (matchBegan && isHost)
        {
            [self sendBallPositionX:ball.position.x Y:ball.position.y];
        }
    }
}

- (void)setGameState:(GameState)state {

    gameState = state;
    if (gameState == kGameStateWaitingForMatch) {
        NSLog(@"Waiting for match");
    } else if (gameState == kGameStateWaitingForRandomNumber) {
       NSLog(@"Waiting for rand #");
    } else if (gameState == kGameStateWaitingForStart) {
        NSLog(@"Waiting for start");
    } else if (gameState == kGameStateActive) {
        NSLog(@"Active");
    } else if (gameState == kGameStateDone) {
        NSLog(@"Done");
    }
    
}

- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [self matchEnded];
    }
    else {
        NSLog(@"SENT DATA");
    }
}
- (void)sendMovePositionX:(int)x Y:(int)y {
    MessagePosition message;
    message.message.messageType = kMessageTypeMovePosition;
    message.x = x;
    message.y = y;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePosition)];
    [self sendData:data];
}

- (void)sendBallPositionX:(int)x Y:(int)y {
    MessageBallPosition message;
    message.message.messageType = kMessageTypeMoveBall;
    message.x = x;
    message.y = y;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageBallPosition)];
    [self sendData:data];
}

- (void)sendRandomNumber {
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = ourRandom;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameBegin {
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
}

#pragma GCHelper
- (void)inviteReceived{
    NSLog(@"invite received");

}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID{
    NSLog(@"match DATA YA!");
    Message *message = (Message *) [data bytes];
    if (message->messageType == kMessageTypeMovePosition)
    {
        MessagePosition *positionMessage = (MessagePosition*) [data bytes];
        int x = positionMessage->x;
        int y = positionMessage->y;
        [self updatePos:CGPointMake(x, y)];
        if (matchBegan && isHost)
        {
            [self sendBallPositionX:ball.position.x Y:ball.position.y];
        }
    }
    else if ( message ->messageType == kMessageTypeMoveBall)
    {
        MessageBallPosition *ballMessage = (MessageBallPosition *) [data bytes];
        int x = ballMessage->x;
        int y = ballMessage->y;
        [ball setPosition:CGPointMake(x, y)];
    }
    else if ( message ->messageType == kMessageTypeRandomNumber)
    {
        MessageRandomNumber *randomMessage = (MessageRandomNumber *) [data bytes];
        receivedRandom = randomMessage->randomNumber;
        
        if (receivedRandom == ourRandom)
        {
            ourRandom = arc4random();
            [self sendRandomNumber];
        }
        else if (receivedRandom > ourRandom)
        {
            isHost = false;
            NSLog(@"i am NOT host");
        }
        else if (receivedRandom < ourRandom)
        {
            isHost = true;
            NSLog(@"i am host");
        }
        [self sendGameBegin];
    }
    else if ( message ->messageType == kMessageTypeGameBegin)
    {
        NSLog(@"starting Game");
        matchBegan = true;
        [self setGameState:kGameStateActive];
    }

}

- (void)matchStarted{
    NSLog(@"match started");
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
}

- (void)matchEnded{
    NSLog(@"match ended");
    matchBegan = false;

}
- (void)matchCancelled{
    [self quit];
    matchBegan = false;
}
@end
