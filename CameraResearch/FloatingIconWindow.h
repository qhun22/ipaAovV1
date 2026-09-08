#import <UIKit/UIKit.h>

@class CameraPanel;

NS_ASSUME_NONNULL_BEGIN

@interface FloatingIconWindow : UIWindow

- (instancetype)initWithCameraPanel:(CameraPanel *)cameraPanel;
- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
