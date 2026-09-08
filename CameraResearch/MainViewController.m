#import "MainViewController.h"
#import "CameraPanel.h"
#import "Logger.h"

@interface MainViewController ()
@property (nonatomic, strong) CameraPanel *cameraPanel;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *menuToggleButton;
@property (nonatomic, assign) BOOL menuVisible;
@property (nonatomic, assign) BOOL hasStarted;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.06 green:0.08 blue:0.12 alpha:1.0];
    self.menuVisible = NO;
    self.hasStarted = NO;

    [self setupStartButton];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.startButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

- (void)setupStartButton {
    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.startButton.frame = CGRectMake(0, 0, 210, 58);
    self.startButton.backgroundColor = [UIColor colorWithRed:0.12 green:0.55 blue:0.95 alpha:1.0];
    self.startButton.layer.cornerRadius = 14;
    self.startButton.layer.shadowColor = [UIColor colorWithRed:0.12 green:0.55 blue:0.95 alpha:0.5].CGColor;
    self.startButton.layer.shadowOffset = CGSizeMake(0, 4);
    self.startButton.layer.shadowRadius = 8;
    self.startButton.layer.shadowOpacity = 1.0;
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.startButton addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
}

- (void)setupMenuToggleButton {
    self.menuToggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.menuToggleButton.frame = CGRectMake(20, 54, 52, 52);
    self.menuToggleButton.backgroundColor = [UIColor colorWithRed:0.12 green:0.55 blue:0.95 alpha:1.0];
    self.menuToggleButton.layer.cornerRadius = 26;
    self.menuToggleButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.menuToggleButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.menuToggleButton.layer.shadowRadius = 4;
    self.menuToggleButton.layer.shadowOpacity = 0.5;
    [self.menuToggleButton setTitle:@"☰" forState:UIControlStateNormal];
    [self.menuToggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.menuToggleButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.menuToggleButton.hidden = YES;
    [self.menuToggleButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuToggleButton];
}

- (void)startButtonTapped {
    self.hasStarted = YES;
    self.startButton.hidden = YES;
    self.menuToggleButton.hidden = NO;
    [[Logger sharedLogger] logEvent:@"START"];
    [self showMenu];
}

- (void)showMenu {
    self.menuVisible = YES;
    [self.cameraPanel show];
    [[Logger sharedLogger] logEvent:@"MENU_OPEN"];
}

- (void)hideMenu {
    self.menuVisible = NO;
    [self.cameraPanel hide];
    [[Logger sharedLogger] logEvent:@"MENU_CLOSE"];
}

- (void)toggleMenu {
    if (self.menuVisible) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.menuVisible) {
        [self hideMenu];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)menuDidClose:(NSNotification *)notification {
    self.menuVisible = NO;
    [[Logger sharedLogger] logEvent:@"MENU_CLOSE"];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    if (self.hasStarted) {
        self.menuToggleButton.hidden = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end