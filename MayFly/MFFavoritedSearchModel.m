#import "MFFavoritedSearchModel.h"

@interface MFFavoritedSearchModel() <ESCObservableInternal>

@end


@implementation MFFavoritedSearchModel
@synthesize scopeIndex = _scopeIndex;



- (instancetype)initWithServiceClientFactory:(MFServiceClientFactory *)serviceClientFactory
                          persistenceFactory:(id<MFPersistenceFactory>)persistenceFactory
                    persistencePonsoProvider:(MFPersistencePonsoProvider *)persistencePonsoProvider
                                 memoryStack:(MFMemoryStack *)memoryStack
{
    if (self = [super initWithServiceClientFactory:serviceClientFactory persistenceFactory:persistenceFactory persistencePonsoProvider:persistencePonsoProvider memoryStack:memoryStack]) {
        
    }
    return self;
}

- (void)updateEntities
{
    if ([self.memoryStack memoryStackCount] <= 1) {
        [self queryWithSearchText:@""];
    } else {
        [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:[self.memoryStack lastObject]]];
    }
    
}

- (void)queryWithSearchText:(NSString *)searchText
{
    
    NSArray *entitiesToReturn = [self.persistencePonsoProvider queryWithSearchText:searchText type:self.scopeIndex];
    [self setSerializedData:entitiesToReturn];
    [self.memoryStack clearAndPushMemoryStack:entitiesToReturn];
    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:entitiesToReturn]];
}

- (NSString *)searchResultsTitle
{
    return @"Search Favorites";
}

@end