//
//  LYViewController.m
//  LYMenuDrawerDemo
//
//  Created by Liyao on 2014/8/16.
//
//

#import "LYViewController.h"

@interface LYViewController ()

@end

@implementation LYViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_delegate enablePanGesture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_delegate disablePanGesture];
}

- (IBAction)toggleMenu:(id)sender
{
    [_delegate toggleMenuDidClicked];
}

@end
