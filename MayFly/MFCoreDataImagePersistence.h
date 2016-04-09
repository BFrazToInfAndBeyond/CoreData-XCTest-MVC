#import "MFCoreDataMOCProvider.h"
#import "MFImagePersistence.h"


@interface MFCoreDataImagePersistence : NSObject <MFImagePersistence>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider;

@end