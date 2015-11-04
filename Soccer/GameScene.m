//
//  GameScene.m
//  Soccer
//
//  Created by Benjamin Humphries on 11/20/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    PLAYER = 0x1<<0;
    BALL   = 0x1<<1;
    self.physicsWorld.contactDelegate=self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    [self setupScreenSize];
    [self setupNames];
    [self setupFieldAndBall];
    [self setupPlayers];
    [self setupBounds];
    [self setupLabels];
    [self setupPauseMenu];
    self.backgroundColor = [UIColor whiteColor];
    
    goalLimit = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"goalSegment"];
    if (goalLimit <= 0 )
    {
        goalLimit = 5;
    }
    if (goalLimit == 1)
        [self goalScoredBy:1 displayMsg:@"GOLDEN GOAL" fontSize:25];
    else
        [self goalScoredBy:1 displayMsg:[NSString stringWithFormat:@"FIRST TO %i",goalLimit] fontSize:25];
    
    difficulty = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"difficultyControl"];
   
}
-(void)setupNames{
    playerName1 = [[NSUserDefaults standardUserDefaults]stringForKey:@"playerName1"];
    if (!playerName1|| [playerName1 isEqualToString:@""])
        playerName1 = @"Player 1";
    playerName2 = [[NSUserDefaults standardUserDefaults]stringForKey:@"playerName2"];
    if (!playerName2 || [playerName2 isEqualToString:@""])
        playerName2 = @"Player 2";
}
-(void)setupScreenSize{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth  =  screenSize.width;
    screenHeight = screenSize.height;
}
-(void)setupFieldAndBall{
    ball = [[SKSpriteNode alloc]initWithImageNamed:@"ball1.png"];
    field = [[SKSpriteNode alloc]initWithImageNamed:@"field.png"];
    
    [field setSize:CGSizeMake(screenWidth, screenHeight)];
    [field setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    float ballSize = [[NSUserDefaults standardUserDefaults]floatForKey:@"ballSize"];
    if (ballSize <=0)
    {
        ballSize = 38.0;
    }
    [ball setSize:CGSizeMake(ballSize, ballSize)];
    [ball setScale:screenHeight/568];
    [ball setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    
    [self addChild:field];
    [self addChild:ball];
    
    SKPhysicsBody *phBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
    phBody.dynamic = true;
    phBody.categoryBitMask = BALL;
    phBody.collisionBitMask = PLAYER;
    [phBody setRestitution:0.5];
    [phBody setFriction:0.5];
    [phBody setAllowsRotation:true];
    [phBody setUsesPreciseCollisionDetection:true];
    
    [ball setPhysicsBody:phBody];

}
-(void)setupPlayers{
    player1 = [self newPlayer];
    player2 = [self newPlayer];
    
    player1.name = @"p1";
    player2.name = @"p2";
    
    isP1Down = false;
    isP2Down = false;
    
    playerScore1 = 0;
    playerScore2 = 0;
}
-(SKSpriteNode *)newPlayer{

    SKSpriteNode *p = [[SKSpriteNode alloc]init];
    SKPhysicsBody *p1Body = [SKPhysicsBody bodyWithCircleOfRadius:24.5];
    p1Body.dynamic = false;
    p1Body.affectedByGravity = false;
    p1Body.usesPreciseCollisionDetection = true;
    p1Body.categoryBitMask = PLAYER;
    p1Body.collisionBitMask = BALL;
    p1Body.contactTestBitMask = BALL;
    
    [p setPhysicsBody:p1Body];
    
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"touch" ofType:@"sks"];
    SKEmitterNode *touchCircle = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    touchCircle.position = p.position;
    [touchCircle setScale:screenHeight/580];
    [p addChild:touchCircle];
    return p;
}

-(void)setupBounds{
    NSMutableArray *bodies = [[NSMutableArray alloc]init];
    
    CGPoint bl = CGPointMake(0, 0);
    CGPoint tl = CGPointMake(0, screenHeight);
    CGPoint br = CGPointMake(screenWidth, 0);
    CGPoint tr = CGPointMake(screenWidth, screenHeight);
    
    SKPhysicsBody *lFrame = [SKPhysicsBody bodyWithEdgeFromPoint:bl toPoint:tl];
    [bodies addObject:lFrame];
    
    SKPhysicsBody *rFrame = [SKPhysicsBody bodyWithEdgeFromPoint:br toPoint:tr];
    [bodies addObject:rFrame];
    
    SKPhysicsBody *topLeft = [SKPhysicsBody bodyWithEdgeFromPoint:tl toPoint:CGPointMake(screenWidth/3, screenHeight)];
    [bodies addObject:topLeft];
    
    SKPhysicsBody *topRight = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(screenWidth/1.5, screenHeight) toPoint:tr];
    [bodies addObject:topRight];
    
    SKPhysicsBody *botLeft = [SKPhysicsBody bodyWithEdgeFromPoint:bl toPoint:CGPointMake(screenWidth/3, 0)];
    [bodies addObject:botLeft];
    
    SKPhysicsBody *botRight = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(screenWidth/1.5, 0) toPoint:br];
    [bodies addObject:botRight];
    

    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithBodies:bodies];
    body.collisionBitMask = BALL;
    body.dynamic = false;
    body.usesPreciseCollisionDetection = true;

    self.physicsBody = body;
   }
-(void)setupLabels{
    const int SCR_SIZE = 50;
    scoreLabel1 = [[SKLabelNode alloc] initWithFontNamed:@"FMCollegeTeaminout"];
    [scoreLabel1 setFontSize:SCR_SIZE];
    [scoreLabel1 setText:@"0"];
    [scoreLabel1 runAction:[SKAction rotateToAngle:M_PI/2 duration:0.0]];
    [scoreLabel1 setPosition:CGPointMake(screenWidth/1.1, screenHeight/2 - screenHeight/19)];
    
    scoreLabel2 = [[SKLabelNode alloc] initWithFontNamed:@"FMCollegeTeaminout"];
    [scoreLabel2 setFontSize:SCR_SIZE];
    [scoreLabel2 setText:@"0"];
    [scoreLabel2 runAction:[SKAction rotateToAngle:M_PI/2 duration:0.0]];
    [scoreLabel2 setPosition:CGPointMake(screenWidth/1.1, screenHeight/2 + screenHeight/19)];
    
    [self addChild:scoreLabel1];
    [self addChild:scoreLabel2];
    
    [scoreLabel1 setScale:screenHeight/568];
    [scoreLabel2 setScale:screenHeight/568];
    
    SKSpriteNode *pauseButton = [[SKSpriteNode alloc]initWithImageNamed:@"pause.png"];
    pauseButton.alpha = 0.7;
    [pauseButton setPosition:CGPointMake(screenWidth/1.15, screenHeight/2)];
    [pauseButton setName:@"pause"];
    [pauseButton setScale:screenHeight/700];
    [self addChild:pauseButton];
    
}
-(float)distanceFromA:(CGPoint )a toB:(CGPoint)b{
    float dist = 0.0;
    // squareroot (x2-x1^2 + y2-y1^2)
    float dx = a.x - b.x;
    float dy = a.y - b.y;
    dist = sqrt( (dx * dx) + ( dy * dy) );
    return dist;
}
-(void)setupPauseMenu{
    pauseMenu = [[SKSpriteNode alloc] initWithImageNamed:@"pauseMenu.png"];
    [pauseMenu setPosition:CGPointMake(screenWidth/2,screenHeight/2)];
    
    quit = [[SKSpriteNode alloc]initWithImageNamed:@"quit.png"];
    [quit setPosition:CGPointMake(-quit.size.width, 0)];
    [quit setZPosition:100];
    [quit setName:@"quit"];
    
    resume = [[SKSpriteNode alloc]initWithImageNamed:@"play.png"];
    [resume setPosition:CGPointMake(resume.size.width , 0)];
    [resume setName:@"resume"];
    
    [pauseMenu addChild:quit];
    [pauseMenu addChild:resume];
    
    winner = [SKLabelNode labelNodeWithFontNamed:@"FMCollegeTeaminout"];
    [winner setText:@""];
    [winner setPosition:CGPointMake(0, 50)];
    [winner setFontColor:[UIColor blackColor]];
    [pauseMenu addChild:winner];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches)
    {
        const float MIDDLE = screenHeight/2;
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        NSLog(@"%@",node.name);
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
        
        if (location.y > MIDDLE && !isP2Down)
        {
            //player 2
            [player2 setPosition:location];
            [self addChild:player2];
            isP2Down = true;
        }
        else if (!isP1Down){
            //player 1
            [player1 setPosition:location];
            [self addChild:player1];
            isP1Down = true;
        }
    }
}
-(void)quit{
    /*
    [gameViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
     */
    //SKPhysicsBody
   [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches)
    {
        const float MIDDLE = screenHeight/2;
        CGPoint location = [touch locationInNode:self];
        if (location.y > MIDDLE)
        {
            //player2 zone
            
            if (!isP2Down)
            {
                [player1 removeFromParent];
                isP1Down = false;
            }
            else
            {
                [player2 removeFromParent];
                isP2Down = false;
            }
        }
        else
        {
            //player 1 zone
            if (!isP1Down)
            {
                [player2 removeFromParent];
                isP2Down = false;
            }
            else
            {
                [player1 removeFromParent];
                isP1Down = false;
            }
            
        }
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    const float MIDDLE = screenHeight/2;

    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        if (location.y > MIDDLE )
        {
            //player 2's ZONE
            [player2 setPosition:location];
        }
        else if (location.y < MIDDLE)
        {
            //player 1's ZONE
            [player1 setPosition:location];
        }
    }
}
-(void)togglePause{
    if (isPaused)
    {
        [winner setText:@""];
        [pauseMenu removeFromParent];
        [ball.physicsBody applyImpulse:lastV];
        ball.physicsBody.dynamic = true;
        isPaused = false;
    }
    else
    {
        [self addChild:pauseMenu];
        lastV = ball.physicsBody.velocity;
        ball.physicsBody.dynamic = false;
        isPaused = true;
    }

}
-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKSpriteNode *player;
     if (contact.bodyA.node.physicsBody.categoryBitMask==BALL && contact.bodyB.node.physicsBody.categoryBitMask== PLAYER)
    {
        player = (SKSpriteNode *)contact.bodyB.node;
        CGVector force = CGVectorMake(contact.contactPoint.x-player.position.x, contact.contactPoint.y-player.position.y);
        [ball.physicsBody applyImpulse:force atPoint:contact.contactPoint];
    }
}
-(void)update:(CFTimeInterval)currentTime {
    
    
    if (ball.position.x > screenWidth + ball.size.width/2 || ball.position.x < 0 - ball.size.width/2)
    {
        [ball removeFromParent];
        ball.position = CGPointMake(screenWidth/2, screenHeight/2);
        [self addChild:ball];
    }
    if (ball.position.y > screenHeight + ball.size.width  && ball.position.x >= screenWidth/6 && ball.position.x <= screenWidth/1.15)
    {
        [self player1Scored];
    }
    else if (ball.position.y <  -ball.size.width  && ball.position.x >= screenWidth/6 && ball.position.x <= screenWidth/1.15)
    {
        [self player2Scored];
    }

}
-(void)player1Scored{
   // NSLog(@"player 1 Scored!");
    [ball removeFromParent];
    ball.position = CGPointMake(screenWidth/2, screenHeight/2);
    [self addChild:ball];
    playerScore1++;
    [scoreLabel1 setText:[NSString stringWithFormat:@"%i",playerScore1]];
    [self goalScoredBy:1 displayMsg:[NSString stringWithFormat:@"GOAL"] fontSize:50];
    if (playerScore1 >= goalLimit){
        [self playerWin1];
    }
}
-(void)player2Scored{
   // NSLog(@"player 2 Scored!");
    [ball removeFromParent];
    ball.position = CGPointMake(screenWidth/2, screenHeight/2);
    [self addChild:ball];
    playerScore2++;
    [scoreLabel2 setText:[NSString stringWithFormat:@"%i",playerScore2]];
    [self goalScoredBy:2 displayMsg:@"GOAL" fontSize:50];
    if (playerScore2 >= goalLimit){
        [self playerWin2];
    }
}
-(void)playerWin1{
    [self goalScoredBy:1 displayMsg:playerName1 fontSize:40];
    [winner setText:[NSString stringWithFormat:@"%@ Wins!",playerName1]];
    [self reset];
}
-(void)playerWin2{
    [self goalScoredBy:2 displayMsg:playerName2 fontSize:40];
    [winner setText:[NSString stringWithFormat:@"%@ Wins!",playerName2]];
    [self reset];
}
-(void)reset{
    playerScore1 = 0;
    playerScore2 = 0;
    scoreLabel1.text = @"0";
    scoreLabel2.text = @"0";
    ball.position = CGPointMake(screenWidth/2, screenHeight/2);
    
    
    SKAction *pause = [SKAction runBlock:^{
        [self togglePause];
    }];
    SKAction *wait = [SKAction waitForDuration:1.5];
    
    [self runAction:[SKAction sequence:@[wait,pause]]];
    
}
-(void)goalScoredBy:(int)_player displayMsg:(NSString *)message fontSize:(int)size{
    goalLabel = [[SKLabelNode alloc]initWithFontNamed:@"FMCollegeTeaminout"];
    [goalLabel setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [goalLabel setText:message];
    [goalLabel setFontSize:size];
    
    float rotateAngle = 0.0;
    if (_player == 1)
        rotateAngle =2 * M_PI;
    else
        rotateAngle = 3 * M_PI;
    
    [self addChild:goalLabel];
    
    SKAction *scale = [SKAction scaleTo:3.5 duration:0.4];
    SKAction *rotate = [SKAction rotateToAngle:rotateAngle duration:0.1];
    SKAction *custom = [SKAction customActionWithDuration:0.5 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        [goalLabel runAction:scale];
        [goalLabel runAction:rotate];
    }];
    SKAction *addStars = [SKAction runBlock:^{
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"stars" ofType:@"sks"];
        SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        [stars setScale:screenHeight/568];
        stars.position = goalLabel.position;
        [stars runAction:rotate];
        [self addChild:stars];
    }];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *fade = [SKAction fadeAlphaTo:0.1 duration:0.5];
    
    SKAction *seq = [SKAction sequence:@[custom,addStars,wait,fade,remove]];
    
    [goalLabel runAction:seq];
}
-(void)setGameViewController:(UIViewController *)_gameView{
    gameViewController = _gameView;
}
@end
