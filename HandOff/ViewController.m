//
//  ViewController.m
//  HandOff
//
//  Created by 石田 勝嗣 on 2014/09/02.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UISwitch *on;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //NSString *bundleName = [[NSBundle mainBundle] bundleIdentifier];
    //NSString *myActivityType =
    //[bundleName stringByAppendingString:@".browsing"];
    
    NSUserActivity* myActivity = [[NSUserActivity alloc]
                                  initWithActivityType:@"jp.neoscorp.handoff.browsing"];
    myActivity.userInfo = @{ @"text" : self.text.text,
                             @"on" : [NSNumber numberWithBool : self.on.on]};
    myActivity.title = @"Browsing";
    [myActivity becomeCurrent];
    [myActivity setDelegate:self];
    [myActivity setNeedsSave:YES];
    
    [self setUserActivity:myActivity];
    
    [self.on addTarget:self action:@selector(onChanged:)
         forControlEvents:UIControlEventValueChanged];
    [self.text addTarget:self action:@selector(textFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onChanged:(UISwitch*) sw {
    NSLog(@"Switch changed");
    [self.userActivity becomeCurrent];
    [self.userActivity setNeedsSave :YES];
}

- (void)textFieldDidChange:(UITextField*) tx {
    NSLog(@"Text changed");
    [self.userActivity becomeCurrent];
    [self.userActivity setNeedsSave :YES];
}

- (void)userActivityWasContinued:(NSUserActivity *)userActivity {
    NSLog(@"ViewController:userActivityWasContinued");
}

- (void)userActivityWillSave:(NSUserActivity *)userActivity {
    NSLog(@"ViewController:userActivityWillSave");
    NSDictionary *dictionary = @{ @"text" : self.text.text,
                                  @"on" : [NSNumber numberWithBool : self.on.on]};
    [userActivity addUserInfoEntriesFromDictionary:dictionary];
}

- (void)restoreUserActivityState:(NSUserActivity *)userActivity {
    NSLog(@"ViewController:restoreUserActivityState");
    NSDictionary *dictionary = userActivity.userInfo;
    NSLog(@"text = %@", [dictionary objectForKey:@"text"]);
    NSLog(@"on = %@", [dictionary objectForKey:@"on"]);
    [self.text setText:[dictionary objectForKey:@"text"]];
    NSNumber *i = [dictionary objectForKey:@"on"];
    BOOL b = [i boolValue];
    [self.on setOn:b];
}

@end
