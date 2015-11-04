//
//  MainMenuViewController.h
//  Soccer
//
//  Created by Benjamin Humphries on 11/27/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GCHelper.h"

@interface MainMenuViewController : UIViewController{
 
}


@property (strong, nonatomic) IBOutlet UIButton *singlePlayer;
@property (strong, nonatomic) IBOutlet UIButton *twoPlayer;
@property (strong, nonatomic) IBOutlet UIButton *settings;
@property (strong, nonatomic) IBOutlet UIButton *noAds;

- (IBAction)singlePlayer:(UIButton *)sender;
- (IBAction)twoPlayer:(UIButton *)sender;
- (IBAction)settings:(UIButton *)sender;
- (IBAction)noAds:(UIButton *)sender;
- (IBAction)hostMatch: (id) sender;
@end
