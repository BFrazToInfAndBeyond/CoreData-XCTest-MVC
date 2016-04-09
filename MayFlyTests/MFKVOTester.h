@interface MFKVOTester : NSObject

- (NSInteger)timesKeyPathFired:(NSString *)keyPath;

- (void)observeKeyPath:(NSString *)keyPath ofObject:(id)object;

@end
