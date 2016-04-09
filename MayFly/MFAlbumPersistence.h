#import "MFAlbumPonso.h"
#import "MFAlbumEntity.h"
@protocol MFAlbum;


@protocol MFAlbumPersistence <NSObject>

- (id<MFAlbum>)albumWithAlbumId:(NSString *)albumId;
- (NSArray *)fetchAlbumsWithSearchText:(NSString *)searchText searchScope:(MFSearchScope)searchScope;

- (NSArray *)imagesWithAlbumId:(NSString *)albumId;
- (NSArray *)tracksWithAlbumId:(NSString *)albumId;

- (void)saveAlbumPonso:(MFAlbumPonso *)albumPonso;

- (BOOL)isFavoriteWithAlbumId:(NSString *)albumId;

- (void)favoriteToggledWithAlbumId:(NSString *)albumId;


- (NSSet *)fetchAlbumPonsosWithArtistId:(NSString *)artistId;
- (MFAlbumPonso *)fetchAlbumPonsoWithAlbumId:(NSString*)albumId;
@end