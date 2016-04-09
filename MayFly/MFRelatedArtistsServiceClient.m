#import "MFRelatedArtistsServiceClient.h"
#import "MFImagePonso.h"
#import "MFArtistPonso.h"
@implementation MFRelatedArtistsServiceClient

- (void)downloadRelatedArtistsWithId:(NSString *)artistId
{
    MFEndpoint *endpoint = [MFEndpoint endpointForRelatedArtists:artistId];
    NSString *requestId = [NSString stringWithFormat:@"%@", endpoint.urlString];
    [self makeServiceCallForEndoint:endpoint responseBlock:^(id response, NSError *error) {
								if(error) {
                                    [self.delegate downloadFailedForRelatedArtistsServiceClient];
                                } else {
                                    
                                    [self.delegate downloadSucceedForRelatedArtistsServiceClientWithSerializedResponse:[self serializeDataWithResponse:response]];
                                    
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
    for (NSDictionary *artist in response[@"artists"]) {
        NSMutableSet *artistsImages = [NSMutableSet set];
        NSString *artistId = artist[@"id"];
        for (NSDictionary *artistImage in artist[@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:nil artistId:artistId height:artistImage[@"height"] width:artistImage[@"width"] url:[self convertStringProperty:artistImage[@"url"]]];
            [artistsImages addObject:imageToAdd];
        }
        MFArtistPonso *artistPonso = [[MFArtistPonso alloc]initWithId:artist[@"id"] name:[self convertStringProperty:artist[@"name"]] popularity:artist[@"popularity"] isFavorite:@0 albums:nil images:[artistsImages copy] relatedArtists:nil tracks:nil genres:[self convertStringProperty:[artist[@"genres"] componentsJoinedByString:@", "]]];
        [serializedPonsos addObject:artistPonso];
    }
    
    return [serializedPonsos copy];
}

@end