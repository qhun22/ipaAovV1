#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Logger : NSObject

+ (instancetype)sharedLogger;
- (void)logEvent:(NSString *)event message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
