#import "MFAlbumPonso.h"
@implementation MFAlbumPonso

@synthesize id = _id;
@synthesize explicit = _explicit;
@synthesize isFavorite = _isFavorite;
@synthesize name = _name;
@synthesize popularity = _popularity;
@synthesize release_date = _release_date;
@synthesize release_date_precision = _release_date_precision;
@synthesize artists = _artists;
@synthesize images = _images;
@synthesize tracks = _tracks;


- (instancetype)initWithId:(NSString *)id name:(NSString *)name isFavorite:(NSNumber *)isFavorite popularity:(NSNumber *)popularity explicit:(NSNumber *)explicit release_date:(NSString *)release_date release_date_precision:(NSString *)release_date_precision artists:(NSSet *)artists images:(NSSet *)images tracks:(NSSet *)tracks{
    return [self initWithId:id name:name isFavorite:isFavorite popularity:popularity explicit:explicit release_date:release_date release_date_precision:release_date_precision artists:artists images:images tracks:tracks numberOfTracks:0];
}


- (instancetype)initWithId:(NSString *)id name:(NSString *)name isFavorite:(NSNumber *)isFavorite popularity:(NSNumber *)popularity explicit:(NSNumber *)explicit release_date:(NSString *)release_date release_date_precision:(NSString *)release_date_precision artists:(NSSet *)artists images:(NSSet *)images tracks:(NSSet *)tracks numberOfTracks:(NSUInteger)numberOfTracks{
    if (self = [super init]){
        _id = id;
        _name = name;
        _isFavorite = isFavorite;
        _popularity = popularity;
        _explicit = explicit;
        _release_date = release_date;
        _release_date_precision = release_date_precision;
        _artists = artists;
        _images = images;
        _tracks = tracks;
        _numberOfTracks = numberOfTracks;
    }
    return self;

}
@end