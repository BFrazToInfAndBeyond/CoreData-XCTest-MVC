#import "MFTrackPonso.h"

@implementation MFTrackPonso

@synthesize albumId = _albumId;
@synthesize albumName = _albumName;
@synthesize explicit = _explicit;
@synthesize isFavorite = _isFavorite;
@synthesize id = _id;
@synthesize disc_number = _disc_number;
@synthesize name = _name;
@synthesize track_number = _track_number;
@synthesize url = _url;
@synthesize artists = _artists;
@synthesize popularity = _popularity;

- (instancetype)initWithId:(NSString *)id name:(NSString *)name albumId:(NSString *)albumId albumName:(NSString *)albumName explicit:(NSNumber *)explicit isFavorite:(NSNumber *)isFavorite disc_number:(NSNumber *)disc_number track_number:(NSNumber *)track_number url:(NSString *)url popularity:(NSNumber *)popularity artists:(NSSet *)artists images:(NSSet *)images{
    
    if (self = [super init]) {
        _id = id;
        _name = name;
        _albumId = albumId;
        _albumName = albumName;
        _explicit = explicit;
        _isFavorite = isFavorite;
        _disc_number = disc_number;
        _track_number = track_number;
        _url = url;
        _popularity = popularity;
        _artists = artists;
        _images = images;
    }
    return self;
}


@end