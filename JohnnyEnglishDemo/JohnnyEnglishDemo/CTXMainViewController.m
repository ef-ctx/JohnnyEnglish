//
//  CTXMainViewController.m
//  JohnnyEnglishDemo
//
//  Created by Mario on 06/10/2014.
//  Copyright (c) 2014 EF Education First. All rights reserved.
//

#import "CTXMainViewController.h"

@interface CTXMainViewController ()

@end

@implementation CTXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    UIButton *nextScreen = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextScreen setTitle:@"Next Screen" forState:UIControlStateNormal];
    nextScreen.translatesAutoresizingMaskIntoConstraints = NO;
//    [nextScreen addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>]
    [self.view addSubview:nextScreen];
    
    UIButton *startTimer1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [startTimer1 setTitle:@"Start Timer 1" forState:UIControlStateNormal];
    startTimer1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:startTimer1];
    
    UIButton *startTimer2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [startTimer1 setTitle:@"Start Timer 2" forState:UIControlStateNormal];
    startTimer2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:startTimer2];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[nextScreen]-[startTimer1]-[startTimer2]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(nextScreen, startTimer1, startTimer2)]];
    
}

- (void)startTimer1Action
{
    
}

- (void)startTimer2Action
{
    
}


@end
