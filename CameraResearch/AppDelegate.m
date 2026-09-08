#import "AppDelegate.h"
#import "CameraPanel.h"

@interface AppDelegate ()
@property (strong, nonatomic) CameraPanel *cameraPanel;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];

    _cameraPanel = [[CameraPanel alloc] init];
    [_cameraPanel show];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_cameraPanel hide];
    _cameraPanel = nil;
}

@end
