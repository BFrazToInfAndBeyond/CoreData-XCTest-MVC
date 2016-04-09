#import "MFDispatcher.h"

@interface MFDispatcherTests : XCTestCase
{
    MFDispatcher *testObject;
}
@end

@implementation MFDispatcherTests


- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenDispatchAsyncCalledForMainQueue_thenBlockExecutedOnMainThread
{
    testObject = [[MFDispatcher alloc] initWithQueue:dispatch_get_main_queue()];
    NSString *signal = @"success";
    [testObject dispatchAsync:^{
        XCTAssertTrue([NSThread isMainThread]);
        ASYSignal(signal);
    }];

    ASYWaitForSignal(signal, 2);
}

- (void)test_whenDispatchAsyncCalledForNonMainQueue_thenBlockExecutedOnBackgroundThread
{
    testObject = [[MFDispatcher alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    NSString *signal = @"success";
    [testObject dispatchAsync:^{
        XCTAssertFalse([NSThread isMainThread]);
        ASYSignal(signal);
    }];
    ASYWaitForSignal(signal, 2);
}

- (void)test_whenDispatchAsyncCalledWithNilBlock_thenDispatcherDoesNotCrash
{
    testObject = [[MFDispatcher alloc] initWithQueue:dispatch_get_main_queue()];
    [testObject dispatchAsync:nil];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
}


@end