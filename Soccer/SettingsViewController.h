//
//  SettingsViewController.h
//  Soccer
//
//  Created by Benjamin Humphries on 11/28/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController<UITextFieldDelegate>{
    UISlider *ballSlider;
}
@property (strong, nonatomic) IBOutlet UITextField *playerField1;
@property (strong, nonatomic) IBOutlet UITextField *playerField2;
@property (retain, nonatomic) IBOutlet UISlider *ballSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *difficultyControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *goalSegment;

- (IBAction)playerField1:(UITextField *)sender;
- (IBAction)playerField2:(UITextField *)sender;

- (IBAction)ballSlider:(UISlider *)sender;
- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)difficultyControl:(UISegmentedControl *)sender;
- (IBAction)goalSegment:(UISegmentedControl *)sender;

@end
