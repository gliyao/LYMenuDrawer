//
//  LYMenuDrawerDelegation.h
//  LYMenuDrawer
//
//  Created by Liyao on 2014/8/16.
//
//

#import <Foundation/Foundation.h>

@protocol LYMenuDrawerDelegation <NSObject>

- (void)openMenuAnimated:(BOOL)animated;
- (void)closeMenuAnimated:(BOOL)animated;

- (void)toggleMenuDidClicked;

- (void)enablePanGesture;
- (void)disablePanGesture;

@end
