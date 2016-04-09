#import "MFArtistServiceClient.h"
#import "MFImagePonso.h"
#import "MFArtistPonso.h"
@implementation MFArtistServiceClient

- (void)downloadArtistWithId:(NSString *)artistId
{
    MFEndpoint *endpoint = [MFEndpoint endpointForArtistId:artistId];
    NSString *requestId = [NSString stringWithFormat:@"%@", endpoint.urlString];
    [self makeServiceCallForEndoint:endpoint responseBlock:^(id response, NSError *error) {
								if(error) {
                                    [self.delegate downloadFailedForArtistServiceClient];
                                } else {
                                    
                                    [self.delegate downloadSucceedForArtistServiceClientWithSerializedResponse:[self serializeDataWithResponse:response]];
                                    
                                }
    }
                          requestId:requestId];
}

- (NSArray *)serializeDataWithResponse:(NSDictionary *)response
{

        return [self transformArtistsWithResponse:response];

}

- (NSArray *)transformArtistsWithResponse:(NSDictionary *)response{
    NSMutableArray *serializedPonsos = [NSMutableArray array];
    //for (NSDictionary *artist in response[@"items"]) {
        NSMutableSet *artistsImages = [NSMutableSet set];
        NSString *artistId = response[@"id"];
        for (NSDictionary *artistImage in response[@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:nil artistId:artistId height:artistImage[@"height"] width:artistImage[@"width"] url:[self convertStringProperty:artistImage[@"url"]]];
            [artistsImages addObject:imageToAdd];
        }
        MFArtistPonso *artistPonso = [[MFArtistPonso alloc]initWithId:response[@"id"] name:[self convertStringProperty:response[@"name"]] popularity:response[@"popularity"] isFavorite:@0 albums:nil images:[artistsImages copy] relatedArtists:nil tracks:nil genres:[self convertStringProperty:[response[@"genres"] componentsJoinedByString:@", "]]];
        [serializedPonsos addObject:artistPonso];
    //}
    
    return [serializedPonsos copy];
}

@end