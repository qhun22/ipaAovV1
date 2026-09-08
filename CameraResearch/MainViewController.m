#import "MainViewController.h"
#import "CameraPanel.h"
#import "Logger.h"

@interface MainViewController ()
@property (nonatomic, strong) CameraPanel *cameraPanel;
@property (nonatomic, strong) UIButton *menuToggleButton;
@property (nonatomic, assign) BOOL menuVisible;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.06 green:0.08 blue:0.12 alpha:1.0];
    self.menuVisible = NO;

    [self setupMenuToggleButton];
    self.cameraPanel = [[CameraPanel alloc] init];
    [self.cameraPanel hide];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuDidClose:)
                                                 name:@"MenuDidClose"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)setupMenuToggleButton {
    self.menuToggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.menuToggleButton.frame = CGRectMake(20.0, 54.0, 50.0, 50.0);
    self.menuToggleButton.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    self.menuToggleButton.layer.cornerRadius = 25.0;
    self.menuToggleButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.menuToggleButton.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.menuToggleButton.layer.shadowRadius = 4.0;
    self.menuToggleButton.layer.shadowOpacity = 0.5;
    [self.menuToggleButton setTitle:@"☰" forState:UIControlStateNormal];
    [self.menuToggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.menuToggleButton.titleLabel.font = [UIFont boldSystemFontOfSize:21.0];
    self.menuToggleButton.accessibilityIdentifier = @"MenuToggleButton";
    [self.menuToggleButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuToggleButton];
}

- (void)showMenu {
    if (self.menuVisible) {
        return;
    }
    self.menuVisible = YES;
    [self.cameraPanel show];
    [[Logger sharedLogger] logEvent:@"MENU" message:@"open"];
}

- (void)hideMenu {
    if (!self.menuVisible) {
        return;
    }
    self.menuVisible = NO;
    [self.cameraPanel hide];
    [[Logger sharedLogger] logEvent:@"MENU" message:@"close"];
}

- (void)toggleMenu {
    if (self.menuVisible) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

- (void)menuDidClose:(NSNotification *)notification {
    if (self.menuVisible) {
        self.menuVisible = NO;
        [[Logger sharedLogger] logEvent:@"MENU" message:@"close"];
    }
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    self.menuToggleButton.hidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
