#import "XCTestCase+MFTestUtils.h"

@implementation XCTestCase(MFTestUtils)


- (void)verifyWhenTriggerMethodBlock:(void (^)())triggerBlock
                thenFirstMethodBlock:(void (^)())firstBlock
       calledBeforeSecondMethodBlock:(void (^)())secondBlock
{
    [self verifyWhenTriggerMethodBlock:triggerBlock	 thenFirstMethodBlock:firstBlock calledBeforeSecondMethodBlock:secondBlock times:1];
}

- (void)verifyWhenTriggerMethodBlock:(void (^)())triggerBlock
                thenFirstMethodBlock:(void (^)())firstBlock
       calledBeforeSecondMethodBlock:(void (^)())secondBlock
                               times:(NSInteger)timesFirstBlockCalled
{
    NSString *signal = @"signal";
    __block BOOL methodCalled = NO;
    [SBLWhen(secondBlock()) thenDo:^{
        methodCalled = YES;
        
        SBLVerifyTimes(SBLTimes(timesFirstBlockCalled), firstBlock());
        
        ASYSignal(signal);
    }];
    
    triggerBlock();
    
    ASYWaitForSignal(signal, 2);
    XCTAssertTrue(methodCalled);
}

@end