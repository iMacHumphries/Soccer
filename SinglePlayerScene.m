//
//  SinglePlayerScene.m
//  Soccer
//
//  Created by Benjamin Humphries on 11/28/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import "SinglePlayerScene.h"
#define EASY 0
#define NORMAL 1
#define HARD 2
#define INSANE 3


@implementation SinglePlayerScene{
    
}

-(id)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    return self;
}
-(void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
    playerName2 = @"CPU";

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches)
    {
        const float MIDDLE = screenHeight/2;
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"pause"])
        {
            [self togglePause];
        }
        else if ([node.name isEqualToString:@"quit"])
        {
            [self quit];
        }
        else if ([node.name isEqualToString:@"resume"])
        {
            [self togglePause];
        }
        if (location.y <= MIDDLE && !isP1Down){
            //player 1
            [player1 setPosition:location];
            [self addChild:player1];
            isP1Down = true;
        }
        if (!isP2Down){
            player2.position = CGPointMake(screenWidth/2, screenHeight - player2.size.height);
            [self addChild:player2];
            isP2Down = true;
        }
           }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [player1 removeFromParent];
    isP1Down = false;
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    const float MIDDLE = screenHeight/2;
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        if (location.y <= MIDDLE)
        {
            //player 1's ZONE
            [player1 setPosition:location];
        }
    }
}

-(void)update:(NSTimeInterval)currentTime{
    
    [super update:currentTime];
    float speed = 0.4;
    if (difficulty == EASY)
        speed = 0.5;
    else if (difficulty == normal)
        speed = 0.3;
    else if (difficulty == HARD)
        speed = 0.2;
    else if (difficulty == INSANE)
        speed = 0.1;
    
    if (ball.position.y > screenHeight/2)
    {
         SKAction *moveTo = [SKAction moveTo:ball.position duration:speed];
        [player2 runAction:moveTo];
    }
    else if (ball.position.y < screenHeight/2)
    {
        SKAction *moveTo = [SKAction moveTo:CGPointMake(ball.position.x, screenHeight/1.2) duration:speed];
        [player2 runAction:moveTo];
    }
    if (ball.position.y > player2.position.y)
    {
        //SKAction *moveTo = [SKAction moveTo:CGPointMake(ball.position.x, player2.position.y) duration:1.5];
        //[player2 runAction:moveTo];

    }
}
@end

