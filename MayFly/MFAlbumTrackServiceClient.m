#import "MFAlbumTracksServiceClient.h"
#import "MFImagePonso.h"
#import "MFTrackPonso.h"
#import "MFArtistPonso.h"

@implementation MFAlbumTracksServiceClient

- (void)downloadTracksForAlbumId:(NSString *)albumId images:(NSSet *)images albumName:(NSString *)albumName isFavorite:(BOOL)isFavorite{
    MFEndpoint *endpoint = [MFEndpoint endpointForAlbumTracks:albumId];
    
    [self makeServiceCallForEndoint:endpoint responseBlock:^(id response, NSError *error) {
								if(error) {
                                    [self.delegate downloadFailedForAlbumTracks];
                                } else {
                                    
                                    [self.delegate downloadSucceededForAlbumTracksWithSerializedResponse:[self serializeDataWithResponse:response images:images albumName:albumName albumId:albumId] isFavorite:isFavorite resultId:albumId];
                                    
                                }
    }  requestId:albumId];
}

- (NSArray *)serializeDataWithResponse:(NSDictionary *)response images:(NSSet *)images albumName:(NSString *)albumName albumId:(NSString *)albumId
{
    NSMutableArray * updatedResponse = [NSMutableArray arrayWithArray:[self transformTracksWithResponse:response]];
    
    for (int i = 0; i < updatedResponse.count; i++) {
        MFTrackPonso *trackPonso = updatedResponse[i];
        trackPonso.albumId = albumId;
        trackPonso.albumName = albumName;
        trackPonso.images = images;
        updatedResponse[i] = trackPonso;
        
    }
    return [updatedResponse copy];
}
        
- (NSArray *)transformTracksWithResponse:(NSDictionary *)response {
    NSMutableArray *serializedPonsos = [NSMutableArray array];
    for (NSDictionary *track in response[@"items"]) {
        
        NSMutableSet *trackImages = [NSMutableSet set];
        NSString *albumId = track[@"album"][@"id"];
        
        NSMutableSet *trackArtists = [NSMutableSet set];
        for (NSDictionary *trackArtist in track[@"artists"]) {
            
            MFArtistPonso *artistToAdd = [[MFArtistPonso alloc] initWithId:trackArtist[@"id"] name:[self convertStringProperty:trackArtist[@"name"]] popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil genres:[self convertStringProperty:trackArtist[@"genres"]]];
            //MFPartialArtistPonso *partialArtistToAdd = [[MFPartialArtistPonso alloc] initWithId:trackArtist[@"id"] name:trackArtist[@"name"] albumId:albumId];
            //[trackArtists addObject:partialArtistToAdd];
            [trackArtists addObject:artistToAdd];
        }
        
        for (NSDictionary *trackImage in track[@"album"][@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:albumId artistId:nil height:trackImage[@"height"] width:trackImage[@"width"] url:[self convertStringProperty:trackImage[@"url"]]];
            [trackImages addObject:imageToAdd];
        }
        
        
        MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:track[@"id"] name:[self convertStringProperty:track[@"name"]] albumId:albumId albumName:[self convertStringProperty:track[@"album"][@"name"]] explicit:track[@"explicit"] isFavorite:@0 disc_number:track[@"disc_number"] track_number:track[@"track_number"] url:[self convertStringProperty:track[@"preview_url"]] popularity:track[@"popularity"] artists:trackArtists  images:trackImages];
        [serializedPonsos addObject:trackPonso];
    }
    return [serializedPonsos copy];
}

        

@end