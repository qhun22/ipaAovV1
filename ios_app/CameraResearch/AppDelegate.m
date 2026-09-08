//
//  AppDelegate.m
//  CameraResearch
//

#import "AppDelegate.h"
#import "CameraPanel.h"

@interface AppDelegate ()
@property (strong, nonatomic) CameraPanel *cameraPanel;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Tạo cửa sổ chính
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    // Tạo và hiển thị Camera Panel
    _cameraPanel = [[CameraPanel alloc] init];
    [_cameraPanel show];
    
    NSLog(@"🔬 Camera Research Panel started!");
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Clean up
    [_cameraPanel hide];
    _cameraPanel = nil;
}

@end