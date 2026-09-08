#import "FloatingIconWindow.h"
#import "CameraPanel.h"
#import "Logger.h"

@interface FloatingIconWindow ()
@property (nonatomic, strong) CameraPanel *cameraPanel;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, assign) CGPoint panStartCenter;
@end

@implementation FloatingIconWindow

- (instancetype)initWithCameraPanel:(CameraPanel *)cameraPanel {
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenBounds = screen.bounds;
    CGRect iconFrame = CGRectMake(CGRectGetMaxX(screenBounds) - 75.0, 110.0, 55.0, 55.0);
    self = [super initWithFrame:iconFrame];
    if (self) {
        self.cameraPanel = cameraPanel;
        self.windowLevel = UIWindowLevelAlert + 1.0;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.userInteractionEnabled = YES;
        self.rootViewController = [[UIViewController alloc] init];
        self.rootViewController.view.backgroundColor = [UIColor clearColor];
        [self setupIconButton];
        [self setupGestures];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuDidClose:)
                                                     name:@"MenuDidClose"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)setupIconButton {
    self.iconButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.iconButton.frame = self.rootViewController.view.bounds;
    self.iconButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.iconButton.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    self.iconButton.layer.cornerRadius = 27.5;
    self.iconButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.35].CGColor;
    self.iconButton.layer.borderWidth = 1.0;
    self.iconButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.iconButton.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    self.iconButton.layer.shadowRadius = 6.0;
    self.iconButton.layer.shadowOpacity = 0.45;
    [self.iconButton setTitle:@"⚙" forState:UIControlStateNormal];
    [self.iconButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.iconButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
    self.iconButton.accessibilityIdentifier = @"FloatingMenuIcon";
    [self.iconButton addTarget:self action:@selector(iconTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.rootViewController.view addSubview:self.iconButton];
}

- (void)setupGestures {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.cancelsTouchesInView = NO;
    [self.iconButton addGestureRecognizer:panGesture];
}

- (void)iconTapped {
    if (self.cameraPanel.hidden) {
        [self.cameraPanel show];
        [[Logger sharedLogger] logEvent:@"MENU" message:@"open"];
    } else {
        [self.cameraPanel hide];
        [[Logger sharedLogger] logEvent:@"MENU" message:@"close"];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.panStartCenter = self.center;
    }

    CGPoint translation = [gesture translationInView:self.superview ?: self];
    CGPoint newCenter = CGPointMake(self.panStartCenter.x + translation.x,
                                    self.panStartCenter.y + translation.y);
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGFloat halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0;
    newCenter.x = MAX(halfWidth, MIN(CGRectGetWidth(bounds) - halfWidth, newCenter.x));
    newCenter.y = MAX(halfHeight, MIN(CGRectGetHeight(bounds) - halfHeight, newCenter.y));
    self.center = newCenter;
}

- (void)menuDidClose:(NSNotification *)notification {
    [self.cameraPanel hide];
    [[Logger sharedLogger] logEvent:@"MENU" message:@"close"];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self hide];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [self show];
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
