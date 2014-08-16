//
//  LYViewController.h
//  LYMenuDrawerDemo
//
//  Created by Liyao on 2014/8/16.
//
//

#import <UIKit/UIKit.h>

#import "LYMenuDrawerDelegation.h"

@interface LYViewController : UIViewController

@property (weak, nonatomic) id<LYMenuDrawerDelegation> delegate;

@end
