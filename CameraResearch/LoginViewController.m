#import "LoginViewController.h"
#import "Logger.h"
#import "MainViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *keyField;
@property (nonatomic, strong) UIButton *startButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.06 green:0.08 blue:0.12 alpha:1.0];
    [self setupLoginUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = MIN(CGRectGetWidth(self.view.bounds) - 48.0, 320.0);
    CGFloat centerX = CGRectGetMidX(self.view.bounds);
    self.keyField.frame = CGRectMake(centerX - width / 2.0, CGRectGetMidY(self.view.bounds) - 38.0, width, 48.0);
    self.startButton.frame = CGRectMake(centerX - width / 2.0, CGRectGetMinY(self.keyField.frame) + 68.0, width, 52.0);
}

- (void)setupLoginUI {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"Camera Research";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [titleLabel.bottomAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-96.0]
    ]];

    self.keyField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.keyField.placeholder = @"Enter Key";
    self.keyField.text = @"1";
    self.keyField.textColor = [UIColor whiteColor];
    self.keyField.tintColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    self.keyField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.10];
    self.keyField.layer.cornerRadius = 10.0;
    self.keyField.layer.borderWidth = 1.0;
    self.keyField.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.18].CGColor;
    self.keyField.font = [UIFont systemFontOfSize:18.0];
    self.keyField.textAlignment = NSTextAlignmentCenter;
    self.keyField.keyboardType = UIKeyboardTypeNumberPad;
    self.keyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.keyField.accessibilityIdentifier = @"LoginKeyField";
    [self.view addSubview:self.keyField];

    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.startButton.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    self.startButton.layer.cornerRadius = 12.0;
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:21.0];
    self.startButton.accessibilityIdentifier = @"LoginStartButton";
    [self.startButton addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
}

- (void)startButtonTapped {
    NSString *enteredKey = self.keyField.text ?: @"";
    BOOL valid = [enteredKey isEqualToString:@"1"];
    [[Logger sharedLogger] logEvent:@"LOGIN_ATTEMPT"
                             message:[NSString stringWithFormat:@"key=%@ result=%@", enteredKey, valid ? @"success" : @"failure"]];

    if (!valid) {
        [self showAlertWithTitle:@"Login Failed" message:@"❌ Invalid Key" success:NO];
        return;
    }

    [[Logger sharedLogger] logEvent:@"LOGIN_SUCCESS" message:@"key accepted"];
    [self showAlertWithTitle:@"Login Success" message:@"✅ Login Success" success:YES];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message success:(BOOL)success {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(__unused UIAlertAction *action) {
        if (success) {
            [self openMainScreen];
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openMainScreen {
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UIWindow *window = self.view.window;
    [UIView transitionWithView:window
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        window.rootViewController = mainViewController;
    } completion:nil];
}

@end
