#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Logger.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[LoginViewController alloc] init];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    [[Logger sharedLogger] logEvent:@"APP_START" message:@"login screen displayed"];
    return YES;
}

@end
