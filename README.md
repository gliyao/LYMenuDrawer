LYMenuDrawer
============

Left menu drawer for iOS.

# Feature

1. Full screen pan gesture for swipe menu.
2. Two speed for menu animation.

# Setup
## Step 1. setup delegate property

in your mainController interface, set property 'delegate' for menuDelegation.
```
#import <UIKit/UIKit.h>

#import "LYMenuDrawerDelegation.h"

@interface LYViewController : UIViewController

// delegate for menu
@property (weak, nonatomic) id<LYMenuDrawerDelegation> delegate;

@end
```

## Step 2. setup delegate method

in your mainController implementation, enable/disable menuDelegate panGesture when view controller appear/dissappear. 

Binding toggle event with left bar buttion item.

```
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
```

