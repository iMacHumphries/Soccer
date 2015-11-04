//
//  AppDelegate.h
//  Soccer
//
//  Created by Benjamin Humphries on 11/20/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineViewController.h"
#import "MainMenuViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    MainMenuViewController *viewController;
   }
+(AppDelegate *)sharedInstance;
@property (nonatomic, retain) MainMenuViewController *viewController;

@property (strong, nonatomic) UIWindow *window;


@end

