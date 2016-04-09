#import "MFCoreDataPSCProvider.h"

@interface MFCoreDataSqlitePSCProvider : NSObject <MFCoreDataPSCProvider>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithUserStoreURL:(NSURL*)storeURL;

@end