#import "MFDispatcher.h"

@interface MFDispatcher()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation MFDispatcher

- (instancetype)initWithQueue:(dispatch_queue_t)queue{
    if (self = [super init]) {
        _queue = queue;
    }
    return self;
}

- (void)dispatchAsync:(void (^)())block{
    dispatch_async(self.queue, ^{
        if(block){
            block();
        }
    });
}

@end