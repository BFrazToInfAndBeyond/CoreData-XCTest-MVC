#import "MFTrackPonso.h"
#import "MFTrackEntity.h"
@protocol MFTrack;

@protocol MFTrackPersistence <NSObject>


- (id<MFTrack>)trackWithTrackId:(NSString *)trackId;

- (NSArray *)fetchTracksWithSearchText:(NSString *)searchText searchScope:(MFSearchScope)searchScope;

- (void)saveTrackPonso:(MFTrackPonso *)trackPonso;

- (BOOL)isFavoriteWithTrackId:(NSString *)trackId;

- (void)favoriteToggledWithTrack:(NSString *)trackId;

- (NSSet *)fetchTrackPonsosWithAlbumId:(NSString *)albumId albumName:(NSString *)albumName;

@end