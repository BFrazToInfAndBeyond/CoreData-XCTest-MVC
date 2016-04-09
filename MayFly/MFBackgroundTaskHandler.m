#import "MFBackgroundTaskHandler.h"

@interface MFBackgroundTaskHandler ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation MFBackgroundTaskHandler

- (void)startBackgroundTask {
    if(UIBackgroundTaskInvalid == self.backgroundTask) {
        self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [self endBackgroundTask];
        }];
    }
}

- (void)endBackgroundTask {
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
}


@end
