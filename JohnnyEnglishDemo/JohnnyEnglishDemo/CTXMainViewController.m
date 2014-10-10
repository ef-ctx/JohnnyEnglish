//
//  CTXMainViewController.m
//  JohnnyEnglishDemo
//
//  Created by Mario Araújo on 06/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXMainViewController.h"
#import "CTXSecondViewController.h"
#import "CTXThirdViewController.h"

#import <objc/runtime.h>


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIButton (AssociatedObjects)

@property (nonatomic) void (^CTXAlertViewButtonActionHandler)();

@end

@implementation UIButton (AssociatedObjects)
@dynamic CTXAlertViewButtonActionHandler;

- (void (^)())CTXAlertViewButtonActionHandler
{
    return objc_getAssociatedObject(self, @selector(CTXAlertViewButtonActionHandler));
}

- (void)setCTXAlertViewButtonActionHandler:(void (^)())CTXAlertViewButtonActionHandler
{
    objc_setAssociatedObject(self, @selector(CTXAlertViewButtonActionHandler), CTXAlertViewButtonActionHandler, OBJC_ASSOCIATION_COPY);
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CTXMainViewController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


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
    
    __weak typeof(self) weakself = self;
    
    [self addButtonWithLabel:@"Second Screen" action:^{
        CTXSecondViewController *viewController = [[CTXSecondViewController alloc] init];
        [weakself.navigationController pushViewController:viewController animated:YES];
    }];
    
    [self addButtonWithLabel:@"Third Screen" action:^{
        CTXThirdViewController *viewController = [[CTXThirdViewController alloc] init];
        [weakself.navigationController pushViewController:viewController animated:YES];
    }];
    
    [self addButtonWithLabel:@"Start Timer" action:^{
        [weakself startTimer];
    }];
    
    [self addButtonWithLabel:@"Stop Timer" action:^{
        [weakself stopTimer];
    }];
    
    [self addButtonWithLabel:@"Dispatch Event" action:^{
        [weakself dispatchEvent];
    }];
    
    [self addButtonWithLabel:@"Start Session" action:^{
        [weakself startSession];
    }];
    
    [self addButtonWithLabel:@"Stop Session" action:^{
        [weakself stopSession];
    }];
}

- (void)tapButtonAction:(UIButton *)sender
{
    __weak typeof(self) weakself = self;
    if(sender.CTXAlertViewButtonActionHandler) {
        sender.CTXAlertViewButtonActionHandler(weakself);
    }
}

- (void)addButtonWithLabel:(NSString *)label action:(void (^)(void))action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:label forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setCTXAlertViewButtonActionHandler:action];
    [button addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.view removeConstraints:self.view.constraints];
    
    NSMutableDictionary *buttonDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *buttonsFormat = [NSMutableArray array];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        NSString *buttonName = [NSString stringWithFormat:@"button%lu", (unsigned long)idx];
        [buttonsFormat addObject:buttonName];
        [buttonDictionary setObject:obj forKey:buttonName];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[obj]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(obj)]];
    }];
    
    NSString *visualFormat = [NSString stringWithFormat:@"V:|-100-[%@]", [buttonsFormat componentsJoinedByString:@"]-["]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                      options:0
                                                                      metrics:nil
                                                                        views:buttonDictionary]];
}

- (void)startTimer
{
    
}

- (void)stopTimer
{
    
}

- (void)dispatchEvent
{
    
}

- (void)startSession
{
    
}

- (void)stopSession
{
    
}

@end


