#import "MFImagePonso.h"

@protocol MFImagePersistence <NSObject>

- (void)saveImagePonso:(MFImagePonso *)imagePonso;

- (NSSet *)fetchImagesWithAlbumId:(NSString *)albumId;

- (NSSet *)fetchImagesWithArtistId:(NSString *)artistId;

@end