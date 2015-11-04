//
//  SettingsViewController.m
//  Soccer
//
//  Created by Benjamin Humphries on 11/28/14.
//  Copyright (c) 2014 Marz Software. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize playerField1,playerField2;
@synthesize ballSlider;
@synthesize difficultyControl,goalSegment;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextFields];
    [self setupSlider];
    [self setupDifficultySegment];
    [self setupGoalSegment];
    }
-(void)setupTextFields{
    NSString *playerName1 = [[NSUserDefaults standardUserDefaults]stringForKey:@"playerName1"];
    if (!playerName1 || [playerName1 isEqualToString:@""])
        playerName1 = @"Player 1";
    NSString *playerName2 = [[NSUserDefaults standardUserDefaults]stringForKey:@"playerName2"];
    if (!playerName2 || [playerName2 isEqualToString:@""])
        playerName2 = @"Player 2";
    
    playerField1.delegate = self;
    [playerField1 setText:playerName1];
    [playerField1 setTintColor:[UIColor whiteColor]];
    [playerField1 setTextColor:[UIColor whiteColor]];
    [playerField1 setFont:[UIFont fontWithName:@"FMCollegeTeaminout" size:30]];
    
    playerField2.delegate = self;
    [playerField2 setText:playerName2];
    [playerField2 setTintColor:[UIColor whiteColor]];
    [playerField2 setTextColor:[UIColor whiteColor]];
    [playerField2 setFont:[UIFont fontWithName:@"FMCollegeTeaminout" size:30]];

}
-(void)setupSlider{
    ballSlider.maximumTrackTintColor = [UIColor whiteColor];
    ballSlider.minimumTrackTintColor = [UIColor blackColor];
    [self.ballSlider setValue:[[NSUserDefaults standardUserDefaults]floatForKey:@"ballSize"] animated:YES];
    // self.ballSlider = [[SoccerSlider alloc]init];
    [self ballSlider:ballSlider];
}
-(void)setupDifficultySegment{
    [difficultyControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"difficultyControl"]];
}
-(void)setupGoalSegment{
    int goals = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"goalSegment"];
    int index =0;
    switch (goals) {
        case 1:
            index = 0;
            break;
        case 3:
            index = 1;
            break;
        case 5:
            index = 2;
            break;
        case 10:
            index = 3;
            break;
            
        default:
            break;
    }
    
    [goalSegment setSelectedSegmentIndex:index];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playerField1:(UITextField *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:sender.text forKey:@"playerName1"];
}

- (IBAction)playerField2:(UITextField *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:sender.text forKey:@"playerName2"];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
- (IBAction)ballSlider:(UISlider *)sender {
 
    [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"ballSize"];
    if (sender.value > 40)
    {
        [sender setThumbImage:[UIImage imageNamed:@"bigBall.png"] forState:UIControlStateNormal];
    }
    else if (sender.value < 30)
    {
        [sender setThumbImage:[UIImage imageNamed:@"smallBall.png"] forState:UIControlStateNormal];
    }
    else {
         [sender setThumbImage:[UIImage imageNamed:@"ball1.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)difficultyControl:(UISegmentedControl *)sender {
    [[NSUserDefaults standardUserDefaults]setInteger:sender.selectedSegmentIndex forKey:@"difficultyControl"];
}

- (IBAction)goalSegment:(UISegmentedControl *)sender {
    int goals = 5;
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            goals = 1;
            break;
        case 1:
            goals = 3;
            break;
        case 2:
            goals = 5;
            break;
        case 3:
            goals = 10;
            break;
        default:
            goals = 5;
            break;
    }
    [[NSUserDefaults standardUserDefaults]setInteger:goals forKey:@"goalSegment"];
}


@end
