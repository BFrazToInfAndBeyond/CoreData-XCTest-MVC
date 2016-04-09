#import "MFCoreDataMOCProvider.h"
#import "MFTrackPersistence.h"

@interface MFCoreDataTrackPersistence : NSObject <MFTrackPersistence>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider;
@end

