//
//  ViewController.m
//  SYFlatButton
//
//  Created by Sunnyyoung on 2016/11/18.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "ViewController.h"
#import "SYFlatButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SYFlatButton *button = [[SYFlatButton alloc] initWithFrame:CGRectMake(20.0, 20.0, 60.0, 30.0)];
    button.title = @"Code";
    button.momentary = YES;
    button.cornerRadius = 4.0;
    button.backgroundNormalColor = [NSColor blueColor];
    button.backgroundHighlightColor = [NSColor redColor];
//    [self.view addSubview:button];
}

@end
