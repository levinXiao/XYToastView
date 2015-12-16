//
//  ViewController.m
//  XYToastViewExample
//
//  Created by xiaoyu on 15/12/16.
//  Copyright © 2015年 _companyname_. All rights reserved.
//

#import "ViewController.h"
#import "XYToastView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *showButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showButton setTitle:@"show" forState:UIControlStateNormal];
    showButton.frame = (CGRect){([UIScreen mainScreen].bounds.size.width-100)/2,200,100,40};
    [self.view addSubview:showButton];
    [showButton addTarget:self action:@selector(showButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *showButton2  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showButton2 setTitle:@"show2" forState:UIControlStateNormal];
    showButton2.frame = (CGRect){([UIScreen mainScreen].bounds.size.width-100)/2,300,100,40};
    [self.view addSubview:showButton2];
    [showButton2 addTarget:self action:@selector(showButton2Click) forControlEvents:UIControlEventTouchUpInside];
    
    [self performSelector:@selector(showToastWithMessage:) withObject:@"message" afterDelay:1.f];
}

- (void)showButtonClick{
    [self showToastWithMessage:@"show button click"];
}

- (void)showButton2Click{
    [self showToastWithMessage:@"show2 button click"];
}


- (void)showToastWithMessage:(NSString *)message{
    if (!message) {
        return;
    }
    [XYToastView showToastWithMessage:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
