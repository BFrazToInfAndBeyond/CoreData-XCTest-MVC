#import "MFCoreDataMOCProvider.h"
#import "MFAlbumPersistence.h"


@interface MFCoreDataAlbumPersistence : NSObject <MFAlbumPersistence>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider;

@end