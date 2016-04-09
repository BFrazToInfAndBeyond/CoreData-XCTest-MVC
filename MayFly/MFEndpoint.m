#import "MFEndpoint.h"
#import "MFEnvironment.h"

@implementation MFEndpoint


- (instancetype)initWithURLString:(NSString *)urlString
                    andParameters:(NSDictionary *)parameters
                   defaultTimeout:(NSTimeInterval)defaultTimeout{
    
    if (self = [super init]) {
        _urlString = urlString;
        _parameters = parameters;
        _defaultTimeout = defaultTimeout;
    }
    return self;
}



+ (MFEndpoint *)endpointForArtistId:(NSString *)artistId
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/artists/%@", artistId]];
    
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:nil defaultTimeout:120];
}

+ (MFEndpoint *)endpointForSeveralArtists:(NSArray *)arrayOfArtistsIds
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/artists"]];
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:@{@"ids":[arrayOfArtistsIds componentsJoinedByString:@","]} defaultTimeout:120];
}


+ (MFEndpoint *)endpointForArtistsAlbums:(NSString *)artistId
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/artists/%@/albums", artistId]];
    
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:nil defaultTimeout:120];
}


+ (MFEndpoint *)endpointForAlbumTracks:(NSString *)albumId
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/albums/%@/tracks", albumId]];
    
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:nil defaultTimeout:120];
}

+ (MFEndpoint *)endpointForQueryingSpotifyByName:(NSString *)name type:(MFEntityScope)type
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/search"]];
    
    NSDictionary *parameters;
    if (type == MFArtistScope) {
        parameters = @{@"q":name, @"type":@"artist"};
    }else if (type == MFAlbumScope) {
        parameters = @{@"q":name,@"type":@"album"};
    }else if (type == MFTrackScope) {
        parameters = @{@"q":name,@"type":@"track"};
    }
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:parameters defaultTimeout:120];
}

+ (MFEndpoint *)endpointForRelatedArtists:(NSString *)artistId
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/artists/%@/related-artists", artistId]];
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:nil defaultTimeout:120];
}

+ (MFEndpoint *)endpointForAlbumsWithAlbumIds:(NSArray *)albumIds
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/albums"]];
    NSString *ids = [albumIds componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"ids":ids};
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:parameters defaultTimeout:120];
}

+ (MFEndpoint *)endpointforArtistsWithAritstIds:(NSArray *)artistIds
{
    NSString *baseUrl = [MFEnvironment baseURLString];
    NSString *urlString = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"/v1/artists"]];
    NSString *ids = [artistIds componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"ids":ids};
    return [[MFEndpoint alloc] initWithURLString:urlString andParameters:parameters defaultTimeout:120];
}

@end