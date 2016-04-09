#import "MFArtistAlbumsServiceClient.h"
#import "MFImagePonso.h"
#import "MFAlbumPonso.h"
@implementation MFArtistAlbumsServiceClient

- (void)downloadAlbumsForArtistId:(NSString *)artistId;
{
    MFEndpoint *endpoint = [MFEndpoint endpointForArtistsAlbums:artistId];
    
    [self makeServiceCallForEndoint:endpoint responseBlock:^(id response, NSError *error) {
								if(error) {
                                    [self.delegate downloadFailedForArtistAlbums];
                                } else {
                                    
                                    [self.delegate downloadSucceededForArtistAlbumsWithSerializedResponse:[self serializeDataWithResponse:response]];
                                    
                                }
    }  requestId:artistId];

}

- (NSArray *)serializeDataWithResponse:(NSDictionary *)response
{
    return [self transformAlbumsWithResponse:response];
}

- (NSArray *)transformAlbumsWithResponse:(NSDictionary *)response{
    NSMutableArray *serializedPonsos = [NSMutableArray array];
    for (NSDictionary *album in response[@"items"]) {
        NSMutableSet *albumsImages = [NSMutableSet set];
        NSString *albumId = album[@"id"];
        for (NSDictionary *albumImage in album[@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:albumId artistId:nil height:albumImage[@"height"] width:albumImage[@"width"] url:[self convertStringProperty:albumImage[@"url"]]];
            [albumsImages addObject:imageToAdd];
        }
        MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:albumId name:[self convertStringProperty:album[@"name"]] isFavorite:@0 popularity:nil explicit:nil release_date:nil release_date_precision:nil artists:nil images:albumsImages tracks:nil];
        [serializedPonsos addObject:albumPonso];
    }
    
    return [serializedPonsos copy];
}

@end