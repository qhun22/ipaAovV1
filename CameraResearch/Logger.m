#import "Logger.h"

@implementation Logger

+ (instancetype)sharedLogger {
    static Logger *logger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [[Logger alloc] init];
    });
    return logger;
}

- (void)logEvent:(NSString *)event message:(NSString *)message {
    if (event.length == 0) {
        return;
    }

    @synchronized (self) {
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        if (documentsPath.length == 0) {
            return;
        }

        NSString *logPath = [documentsPath stringByAppendingPathComponent:@"CameraResearch.log"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:logPath]) {
            [fileManager createFileAtPath:logPath contents:nil attributes:nil];
        }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *line = [NSString stringWithFormat:@"[%@] [%@] %@\n",
                      [formatter stringFromDate:[NSDate date]], event, message ?: @""];

        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:logPath];
        if (handle == nil) {
            return;
        }

        [handle seekToEndOfFile];
        [handle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    }
}

@end
