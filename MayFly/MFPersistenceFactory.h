#import "MFArtistPersistence.h"
#import "MFTrackPersistence.h"
#import "MFAlbumPersistence.h"
#import "MFImagePersistence.h"




@protocol MFPersistenceFactory <NSObject>

- (id<MFArtistPersistence>)artistPersistence;
- (id<MFTrackPersistence>)trackPersistence;
- (id<MFAlbumPersistence>)albumPersistence;
- (id<MFImagePersistence>)imagePersistence;


@end