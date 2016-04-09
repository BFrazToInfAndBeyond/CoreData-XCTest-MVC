#import "MFMemoryStack.h"
#define MAX_SIZE 7

@interface MFMemoryStack()


@end

@implementation MFMemoryStack

- (instancetype)init
{
    if (self = [super init]) {
        _memoryStack = [NSMutableArray array];
    }
    return self;
}

- (void)pushMemoryStack:(NSArray *)serializedDataToPush
{
    if (self.memoryStack.count >= MAX_SIZE) {
        [self.memoryStack removeObjectAtIndex:0];
    }
    [self.memoryStack addObject:serializedDataToPush];
}

- (void)clearMemoryStack
{
    self.memoryStack = [NSMutableArray array];
}

-(void)clearAndPushMemoryStack:(NSArray *)serializedDataToPush
{
    [self clearMemoryStack];
    [self pushMemoryStack:serializedDataToPush];
}

- (NSArray *)popMemoryStack
{
    if (self.memoryStack.count <= 1)
    {
        return nil;
    }
    [self.memoryStack removeLastObject];
    return [self.memoryStack lastObject];
}

- (NSUInteger)memoryStackCount{
    return self.memoryStack.count;
}

- (NSArray *)lastObject
{
    return self.memoryStack.lastObject;
}

@end