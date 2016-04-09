#import "MFPersistenceFactory.h"

@interface MFPersistencePonsoProvider : NSObject
@property (nonatomic, readonly) id<MFPersistenceFactory> persistenceFactory;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithPersistenceFactory:(id<MFPersistenceFactory>)persistenceFactory;

- (void)savePonso:(id)ponso;
- (NSArray *)queryWithSearchText:(NSString *)searchText type:(MFEntityScope)type;
@end