#import "MFImagePonso.h"

@implementation MFImagePonso

@synthesize albumId = _albumId;
@synthesize artistId = _artistId;
@synthesize height = _height;
@synthesize url = _url;
@synthesize width = _width;


- (instancetype)initWithAlbumId:(NSString *)albumId artistId:(NSString *)artistId height:(NSNumber *)height width:(NSNumber *)width url:(NSString *)url{
    if (self = [super init]) {
        _albumId = albumId;
        _artistId = artistId;
        _height = height;
        _width = width;
        _url = url;
    }
    return self;
}

@end