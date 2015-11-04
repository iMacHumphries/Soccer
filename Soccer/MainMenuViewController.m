//
//  MainMenuViewController.m
//  Soccer
//
//  Created by Benjamin Humphries on 11/27/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import "MainMenuViewController.h"
#import "OnlineViewController.h"
#import "AppDelegate.h"


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize singlePlayer,twoPlayer,noAds,settings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)singlePlayer:(UIButton *)sender {
    [self performSegueWithIdentifier:@"singlePlayer" sender:sender];
}

- (IBAction)twoPlayer:(UIButton *)sender {
    [self performSegueWithIdentifier:@"twoPlayer" sender:sender];
}

- (IBAction)settings:(UIButton *)sender {
    [self performSegueWithIdentifier:@"settings" sender:sender];
}

- (IBAction)noAds:(UIButton *)sender {
}

- (IBAction)hostMatch:(id) sender
{
   if ([[GCHelper sharedInstance] userAuthenticated])
       [self performSegueWithIdentifier:@"Online" sender:sender];
}

-(BOOL)prefersStatusBarHidden{
    return true;
}
@end
