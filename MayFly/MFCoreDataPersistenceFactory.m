#import "MFCoreDataPersistenceFactory.h"
#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataArtistPersistence.h"
#import "MFCoreDataAlbumPersistence.h"
#import "MFCoreDataTrackPersistence.h"
#import "MFCoreDataImagePersistence.h"

@interface MFCoreDataPersistenceFactory()

@property (nonatomic, readonly) MFCoreDataMOCProvider *mocProvider;

@end

@implementation MFCoreDataPersistenceFactory

- (instancetype)initWithMOCProvider:(MFCoreDataMOCProvider *)mocProvider{
    if (self = [super init]) {
        _mocProvider = mocProvider;
    }
    return self;
}


- (id<MFArtistPersistence>)artistPersistence
{
    return [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:self.mocProvider];
}

- (id<MFTrackPersistence>)trackPersistence
{
    return [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:self.mocProvider];
}

- (id<MFAlbumPersistence>)albumPersistence
{
    return [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:self.mocProvider];
}

- (id<MFImagePersistence>)imagePersistence
{
    return [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:self.mocProvider];
}

@end