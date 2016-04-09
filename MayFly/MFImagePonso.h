@interface MFImagePonso : NSObject <MFImage>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithAlbumId:(NSString *)albumId artistId:(NSString *)artistId height:(NSNumber *)height width:(NSNumber *)width url:(NSString *)url;

@end