//
//  CameraPanel.h
//  CameraResearch
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraPanel : UIWindow

- (instancetype)init;
- (void)show;
- (void)hide;
- (void)toggleVisibility;

@end

NS_ASSUME_NONNULL_END