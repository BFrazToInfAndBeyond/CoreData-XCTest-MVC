#import "MFMultipleAlbumsServiceClient.h"
#import "MFImagePonso.h"
#import "MFArtistPonso.h"
#import "MFAlbumPonso.h"
@implementation MFMultipleAlbumsServiceClient

- (void)downloadMultipleAlbumsWithIds:(NSArray *)albumIds fromClick:(BOOL)fromClick
{
    MFEndpoint *endpoint = [MFEndpoint endpointForAlbumsWithAlbumIds:albumIds];
    NSString *requestId = [NSString stringWithFormat:@"%@", endpoint.urlString];
    [self makeServiceCallForEndoint:endpoint responseBlock:^(id response, NSError *error) {
        if (error) {
            [self.delegate downloadFailedForMultipleAlbumsServiceClient];
        } else {
            [self.delegate downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:[self serializeDataWithResponse:response] fromClick:fromClick];
        }
    } requestId:requestId];
}



- (NSArray *)serializeDataWithResponse:(NSDictionary *)response
{
    
    return [self transformAlbumsWithResponse:response];
    
}

- (NSArray *)transformAlbumsWithResponse:(NSDictionary *)response{
    NSMutableArray *serializedPonsos = [NSMutableArray array];
    for (NSDictionary *album in response[@"albums"]) {
        
        NSMutableSet *albumArtists = [NSMutableSet set];
        for (NSDictionary *albumArtist in album[@"artists"]) {
            MFArtistPonso *artistToAdd = [[MFArtistPonso alloc] initWithId:albumArtist[@"id"] name:[self convertStringProperty:albumArtist[@"name"]] popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil genres:[self convertStringProperty:albumArtist[@"genres"]]];
            [albumArtists addObject:artistToAdd];
        }
        
        NSMutableSet *albumsImages = [NSMutableSet set];
        NSString *albumId = album[@"id"];
        for (NSDictionary *albumImage in album[@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:albumId artistId:nil height:albumImage[@"height"] width:albumImage[@"width"] url:albumImage[@"url"]];
            [albumsImages addObject:imageToAdd];
        }
        MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:albumId name:album[@"name"] isFavorite:@0 popularity:nil explicit:nil release_date:nil release_date_precision:nil artists:[albumArtists copy] images:[albumsImages copy] tracks:nil numberOfTracks:[album[@"tracks"][@"items"] count]];
        [serializedPonsos addObject:albumPonso];
    }
    
    return [serializedPonsos copy];
}


@end
