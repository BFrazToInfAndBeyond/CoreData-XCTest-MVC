
@interface MFMemoryStack : NSObject

@property NSMutableArray *memoryStack;

- (void)pushMemoryStack:(NSArray *)serializedDataToPush;
- (void)clearMemoryStack;
- (void)clearAndPushMemoryStack:(NSArray *)serializedDataToPush;
- (NSArray *)popMemoryStack;
- (NSUInteger)memoryStackCount;
- (NSArray *)lastObject;

@end