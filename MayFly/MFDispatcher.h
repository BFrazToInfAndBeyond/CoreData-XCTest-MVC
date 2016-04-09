@interface MFDispatcher : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithQueue:(dispatch_queue_t)queue;

- (void)dispatchAsync:(void(^)())block;

@end