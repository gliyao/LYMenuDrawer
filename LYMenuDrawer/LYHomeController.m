//
//  LYHomeController.m
//  LYMenuDrawer
//
//  Created by Liyao on 2014/8/16.
//
//

#import "LYHomeController.h"

@interface LYHomeController ()

@end

@implementation LYHomeController


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
