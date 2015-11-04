//
//  OnlineViewController.m
//  Soccer
//
//  Created by Benjamin Humphries on 12/1/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import "OnlineViewController.h"

@interface OnlineViewController ()

@end

@implementation OnlineViewController
@synthesize onlineScene;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [OnlineScene sceneWithSize:skView.bounds.size];
    onlineScene = (OnlineScene *)scene;
    onlineScene.onlineViewController = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [onlineScene sceneDidAppear];
   }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
