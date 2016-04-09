#import "MFKVOTester.h"

static void * MFKVOTesterContext = &MFKVOTesterContext;

@interface MFKVOTester ()
@property (nonatomic, strong) NSMutableDictionary *tokens;
@property (nonatomic, strong) NSMutableDictionary *objects;
@end

@implementation MFKVOTester

- (instancetype)init {
    if (self = [super init]) {
        _objects = [NSMutableDictionary dictionary];
        _tokens = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    for (NSString *keyPath in [self.tokens allKeys]) {
        [self.objects[keyPath] removeObserver:self forKeyPath:keyPath];
    }
}

- (NSInteger)timesKeyPathFired:(NSString *)keyPath {
    return [self.tokens[keyPath] integerValue];
}

- (void)observeKeyPath:(NSString *)keyPath ofObject:(id)object {
    [object addObserver:self
             forKeyPath:keyPath
                options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                context:MFKVOTesterContext];
    
    self.tokens[keyPath] = @0;
    self.objects[keyPath] = object;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &MFKVOTesterContext) {
        self.tokens[keyPath] = @([self.tokens[keyPath] intValue] + 1);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
