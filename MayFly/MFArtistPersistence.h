#import "MFArtistPonso.h"
@protocol MFArtist;
@protocol MFArtistPersistence <NSObject>

-(id<MFArtist>)artistWithArtistId:(NSString *)artistId;

- (NSArray *)fetchArtistsWithSearchText:(NSString *)searchText searchScope:(MFSearchScope)searchScope;

- (NSArray *)albumsWithArtistId:(NSString *)artistId;

- (NSArray *)imagesWithArtistId:(NSString *)artistId;

- (NSArray *)relatedArtistsWithArtistId:(NSString *)artistId;


- (void)saveArtistPonso:(MFArtistPonso *)artist;

- (BOOL)isFavoriteWithArtistId:(NSString *)artistId;

- (void)favoriteToggleWithArtistId:(NSString *)artistId;

@end