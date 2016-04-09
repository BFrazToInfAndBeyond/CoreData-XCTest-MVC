#import "MFPersistencePonsoProvider.h"
#import "MFCoreDataPersistenceFactory.h"

@interface MFPersistencePonsoProvider()

@property id<MFArtistPersistence> artistPersistence;
@property id<MFAlbumPersistence> albumPersistence;
@property id<MFTrackPersistence> trackPersistence;
@property id<MFImagePersistence> imagePersistence;



@end

@implementation MFPersistencePonsoProvider


- (instancetype)initWithPersistenceFactory:(id<MFPersistenceFactory>)persistenceFactory
{
    if (self = [super init]) {
        
        _persistenceFactory = persistenceFactory;
        _artistPersistence = [self.persistenceFactory artistPersistence];
        _albumPersistence = [self.persistenceFactory albumPersistence];
        _trackPersistence = [self.persistenceFactory trackPersistence];
        _imagePersistence = [self.persistenceFactory imagePersistence];
    }
    return self;
}

- (id<MFPersistenceFactory>)getPersistenceFactory{
    return self.persistenceFactory;
}

- (void)savePonso:(id)ponso{
    if ([ponso isKindOfClass:[MFTrackPonso class]]) {
        MFTrackPonso *trackPonso = ponso;
        for (MFImagePonso *image in [trackPonso images]){
            [self.imagePersistence saveImagePonso:image];
        }
        [self.trackPersistence saveTrackPonso:trackPonso];
    } else if ([ponso isKindOfClass:[MFAlbumPonso class]]) {
        MFAlbumPonso *albumPonso = ponso;
        [self.albumPersistence saveAlbumPonso:albumPonso];
    } else if ([ponso isKindOfClass:[MFArtistPonso class]]){
        MFArtistPonso *artistPonso = ponso;
        [self.artistPersistence saveArtistPonso:artistPonso];
    }
}

- (NSArray *)queryWithSearchText:(NSString *)searchText type:(MFEntityScope)type
{
    NSMutableArray *ponsosToReturn = [NSMutableArray array];
    if (type == MFArtistScope) {
        return [[self.artistPersistence fetchArtistsWithSearchText:searchText searchScope:MFSearchScopeFavorite] copy];
    } else if (type == MFAlbumScope) {
        return [[self.albumPersistence fetchAlbumsWithSearchText:searchText searchScope:MFSearchScopeFavorite] copy];
    } else if (type == MFTrackScope) {
        [ponsosToReturn addObjectsFromArray:[self.trackPersistence fetchTracksWithSearchText:searchText searchScope:MFSearchScopeFavorite]];
        for (int i = 0; i < ponsosToReturn.count; i++) {
            MFTrackPonso *trackPonso = ponsosToReturn[i];
            trackPonso.images = [self.imagePersistence fetchImagesWithAlbumId:[trackPonso albumId]];
            ponsosToReturn[i] = trackPonso;
        }
    }
    
    return [ponsosToReturn copy];
}


@end