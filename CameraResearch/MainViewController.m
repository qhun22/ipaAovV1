#import "MainViewController.h"
#import "CameraPanel.h"
#import "FloatingIconWindow.h"

@interface MainViewController ()
@property (nonatomic, strong) CameraPanel *cameraPanel;
@property (nonatomic, strong) FloatingIconWindow *floatingIconWindow;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.06 green:0.08 blue:0.12 alpha:1.0];

    self.cameraPanel = [[CameraPanel alloc] init];
    [self.cameraPanel hide];
    self.floatingIconWindow = [[FloatingIconWindow alloc] initWithCameraPanel:self.cameraPanel];
    [self.floatingIconWindow show];
}

- (void)dealloc {
    [self.floatingIconWindow hide];
    [self.cameraPanel hide];
}

@end
