#import "MFArtistPonso.h"

@implementation MFArtistPonso

@synthesize id = _id;
@synthesize name = _name;
@synthesize isFavorite = _isFavorite;
@synthesize popularity = _popularity;
@synthesize albums = _albums;
@synthesize images = _images;
@synthesize relatedArtists = _relatedArtists;
@synthesize tracks = _tracks;
@synthesize genres = _genres;

- (instancetype)initWithId:(NSString *)id name:(NSString *)name popularity:(NSNumber *)popularity isFavorite:(NSNumber *)isFavorite albums:(NSSet *)albums images:(NSSet *)images relatedArtists:(NSSet *)relatedArtists tracks:(NSSet *)tracks genres:(NSString *)genres{
    
    if (self = [super init]){
        _id = id;
        _name = name;
        _popularity = popularity;
        _isFavorite = isFavorite;
        _albums = albums;
        _images = images;
        _relatedArtists = relatedArtists;
        _tracks = tracks;
        _genres = genres;
    }
    return self;
}

@end