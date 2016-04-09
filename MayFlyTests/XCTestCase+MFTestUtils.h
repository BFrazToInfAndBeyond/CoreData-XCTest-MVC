@interface XCTestCase(MFTestUtils)

// THIS REQUIRES STUBBLE
- (void)verifyWhenTriggerMethodBlock:(void (^)())triggerBlock
                thenFirstMethodBlock:(void (^)())firstBlock
       calledBeforeSecondMethodBlock:(void (^)())secondBlock;

- (void)verifyWhenTriggerMethodBlock:(void (^)())triggerBlock
                thenFirstMethodBlock:(void (^)())firstBlock
       calledBeforeSecondMethodBlock:(void (^)())secondBlock
                               times:(NSInteger)timesFirstBlockCalled;

@end