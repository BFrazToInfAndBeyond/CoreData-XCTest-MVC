#import "MFCoreDataMOCProvider.h"
#import "MFArtistPersistence.h"

@interface MFCoreDataArtistPersistence : NSObject <MFArtistPersistence>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider;

@end