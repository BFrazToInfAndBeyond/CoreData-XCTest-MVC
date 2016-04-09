#import "MFPersistenceFactory.h"
#import "MFCoreDataPersistenceFactory.h"

@class MFCoreDataMOCProvider;

@interface MFCoreDataPersistenceFactory :  NSObject <MFPersistenceFactory>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithMOCProvider:(MFCoreDataMOCProvider *)mocProvider;

@end