//
//  LYMenuDrawerController.m
//  LYMenuDrawer
//
//  Created by Liyao on 2014/8/15.
//
//

#import "LYMenuDrawerController.h"

static float defaultAnimatedDuration = 0.3f;
static float fastAnimatedDuration = 0.15f;

static NSUInteger panVelocitytThreshold = 500;


@interface LYMenuDrawerController ()

@property (assign, nonatomic) BOOL isMenuOpen;
@property (assign, nonatomic) BOOL isMenuAnimating;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeTopSpace;

@property (nonatomic, weak) IBOutlet UIView *menuContainer;
@property (nonatomic, weak) IBOutlet UIView *homeContainer;
@property (strong, nonatomic) UIViewController *homeController;
@property (strong, nonatomic) UIView *homeView;

@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@property (assign, nonatomic) CGRect openMenuFrame;
@property (assign, nonatomic) CGRect closeMenuFrame;

@property (weak, nonatomic) UIWindow *window;

@end

@implementation LYMenuDrawerController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"homeNavSegue"])
    {
        // 取得homeController
        id destVC = segue.destinationViewController;
        
        if([destVC isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = segue.destinationViewController;
            _homeController = nav.viewControllers[0];
            
        }
        else if([destVC isKindOfClass:[UIViewController class]])
        {
            _homeController = destVC;
        }
        else
        {
            _homeController = nil;
        }
        
        if(_homeController)
        {
            // 用KVC 硬塞Home Controller 的 menu Delegate
            @try {
                [_homeController setValue:self forKey:@"delegate"];
            }
            @catch (NSException *exception) {
                NSLog(@"homeController 沒有 delegate 屬性");
            }
            @finally {
                
            }
        }
    }
}

#pragma - LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1)
    {
        _menuTopSpace.constant = 0.0f;
        _homeTopSpace.constant = 0.0f;
    }
    
    _isMenuOpen = NO;
    _isMenuAnimating = NO;
    
    // Gesture
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGesture:)];
    _tap.numberOfTapsRequired = 1;
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    
    
    CGFloat menuWidth = CGRectGetWidth(_menuContainer.frame),
    homeWidth = CGRectGetWidth(_homeContainer.frame),
    homeHeight = CGRectGetHeight(_homeContainer.frame);
    
    _openMenuFrame = CGRectMake(menuWidth, 0, homeWidth, homeHeight);
    _closeMenuFrame = CGRectMake(0, 0, homeWidth, homeHeight);
    
    _homeView = _homeContainer.subviews[0];
    
    _window = [[[UIApplication sharedApplication] delegate] window];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MenuDrawerDeleate
- (void)toggleMenuDidClicked
{
    if(_isMenuOpen)
    {
        [self closeMenuAnimated:YES];
    }
    else
    {
        [self openMenuAnimated:YES];
    }
}

- (void)enablePanGesture
{
    [_window addGestureRecognizer:_pan];
}

- (void)disablePanGesture
{
    [_window removeGestureRecognizer:_pan];
}

- (void)openMenuAnimated:(BOOL)animated
{
    [self openMenuAnimated:animated duration:defaultAnimatedDuration];
}

- (void)openMenuAnimated:(BOOL)animated duration:(NSTimeInterval)duration
{
    _isMenuOpen = YES;
    [_homeContainer addGestureRecognizer:_tap];
    _homeView.userInteractionEnabled = NO;
    
    // 動畫打開menu
    if(animated)
    {
        if(duration == 0){
            duration = defaultAnimatedDuration;
        }
        
        [UIView animateWithDuration:duration animations:^{
            _homeContainer.frame = _openMenuFrame;
        }];
    }
    
    // 直接打開menu
    else{
        _homeContainer.frame = _openMenuFrame;
    }
}

- (void)closeMenuAnimated:(BOOL)animated
{
    [self closeMenuAnimated:animated duration:defaultAnimatedDuration];
}

- (void)closeMenuAnimated:(BOOL)animated duration:(NSTimeInterval)duration
{
    _isMenuOpen = NO;
    [_homeContainer removeGestureRecognizer:_tap];
    _homeView.userInteractionEnabled = YES;
    
    // 動畫關閉menu
    if(animated)
    {
        if(duration == 0){
            duration = defaultAnimatedDuration;
        }
        
        [UIView animateWithDuration:duration animations:^{
            _homeContainer.frame = _closeMenuFrame;
        }];
    }
    
    // 直接關閉menu
    else{
        _homeContainer.frame = _closeMenuFrame;
    }
}

#pragma mark - Gestures
#pragma mark Tap
- (void)respondToTapGesture:(UITapGestureRecognizer *)sender
{
    if(_isMenuOpen)
    {
        [self closeMenuAnimated:YES];
    }
}

#pragma mark Drag
- (void)respondToPanGesture:(UIPanGestureRecognizer *)aPanRecognizer
{
    CGFloat homeLeft = CGRectGetMinX(_homeContainer.frame);
    CGPoint offset = [aPanRecognizer translationInView:aPanRecognizer.view];
    
    // Start drag
    if(aPanRecognizer.state == UIGestureRecognizerStateBegan){
    }
    
    // Dragging
    else if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newHomeLeft = homeLeft + offset.x;
        
        // Over left
        if(newHomeLeft <= 0.0f) return ;
        
        // Over right
        if(newHomeLeft >= _menuContainer.frame.size.width) return ;
        
        CGPoint homeCenter = _homeContainer.center;
        [_homeContainer setCenter:CGPointMake(homeCenter.x + offset.x, homeCenter.y)];
        
        
        [aPanRecognizer setTranslation:CGPointZero inView:self.view];
    }
    
    // Stop drag
    else if (aPanRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
        CGFloat speedX = fabs(velocity.x);
        
        // 結束時加速度
        NSLog(@"velocity = %f", velocity.x);
        
        // 高速時
        if(speedX > panVelocitytThreshold)
        {
            if(velocity.x > 0){
                [self openMenuAnimated:YES duration:fastAnimatedDuration];
            }
            else{
                [self closeMenuAnimated:YES duration:fastAnimatedDuration];
            }
        }
        // 速度慢慢的時候
        else
        {
            // 超過 Menu 一半打開Menu
            if(homeLeft > _menuContainer.center.x){
                [self openMenuAnimated:YES];
            }
            else{
                [self closeMenuAnimated:YES];
            }
        }
    }
}

@end
