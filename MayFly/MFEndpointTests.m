#import "MFEndpoint.h"
#import <XCTest/XCTest.h>

@interface MFEndpointTests : XCTestCase

@end

@implementation MFEndpointTests

- (void)test_whenEndpointForArtistId_TheReturnCorrectURL{
    NSString *museArtistId = @"12Chz98pHFMPJEknJQMWvI";
    MFEndpoint *endpoint = [MFEndpoint endpointForArtistId:museArtistId];
    NSString *expectedUrlString = @"https://api.spotify.com/v1/artists/12Chz98pHFMPJEknJQMWvI";
    XCTAssertEqualObjects(expectedUrlString, endpoint.urlString);
    
}


- (void)test_whenEndpointForArtistsAlbums_thenReturnCorrectURL{
    NSString *artistId = @"artistId";

    MFEndpoint *endpoint = [MFEndpoint endpointForArtistsAlbums:artistId];
    
    NSString *expectedUrlString = @"https://api.spotify.com/v1/artists/artistId/albums";
    
    XCTAssertEqualObjects(expectedUrlString, endpoint.urlString);
}

- (void)test_whenEndpointForAlbumTracks_thenReturnCorrectURL{
    NSString *albumId = @"albumId";
    
    MFEndpoint *endpoint = [MFEndpoint endpointForAlbumTracks:albumId];
    
    NSString *expectedUrlString = @"https://api.spotify.com/v1/albums/albumId/tracks";
    XCTAssertEqualObjects(expectedUrlString, endpoint.urlString);
    
}

- (void)test_whenEndpointForQueryingSpotifyByNameWithOnlyAlbumNameNonNil_thenReturnCorrectURL{
    NSString *albumName = @"albumName";

    NSString *expectedString = @"https://api.spotify.com/v1/search";
    NSDictionary *expectedParameters = @{@"q":albumName,@"type":@"album"};
    
    MFEndpoint *endpoint = [MFEndpoint endpointForQueryingSpotifyByName:albumName type:MFAlbumScope];

    XCTAssertEqualObjects(expectedString, endpoint.urlString);
    XCTAssertEqualObjects(expectedParameters, endpoint.parameters);
}

- (void)test_whenEndpointForQueryingSpotifyByNameWithOnlyTrackNameNonNil_thenReturnCorrectURL {
    NSString *trackName = @"trackName";
    
    NSString *expectedString = @"https://api.spotify.com/v1/search";
    NSDictionary *expectedParameters = @{@"q":trackName,@"type":@"track"};
    
    MFEndpoint *endpoint = [MFEndpoint endpointForQueryingSpotifyByName:trackName type:MFTrackScope];
    
    XCTAssertEqualObjects(expectedString, endpoint.urlString);
    XCTAssertEqualObjects(expectedParameters, endpoint.parameters);

}


- (void)test_whenEndpointForQueryingSpotifyByNameWithOnlyArtistNameNonNil_thenReturnCorrectURL {
    NSString *artistName = @"artistName";
    
    NSString *expectedString = @"https://api.spotify.com/v1/search";
    NSDictionary *expectedParameters = @{@"q":artistName,@"type":@"artist"};
    
    MFEndpoint *endpoint = [MFEndpoint endpointForQueryingSpotifyByName:artistName type:MFArtistScope];
    
    XCTAssertEqualObjects(expectedString, endpoint.urlString);
    XCTAssertEqualObjects(expectedParameters, endpoint.parameters);
}

- (void)test_whenEndpointForRelatedArtists_thenReturnCorrectURL {
    NSString *artistId = @"someArtistId";
    
    NSString *expectedString = @"https://api.spotify.com/v1/artists/someArtistId/related-artists";
    
    MFEndpoint *endpoint = [MFEndpoint endpointForRelatedArtists:artistId];
    
    XCTAssertEqualObjects(expectedString, endpoint.urlString);
    XCTAssertNil(endpoint.parameters);
}

- (void)test_whenEndpointForSeveralAlbums_thenReturnCorrectURL
{
    NSArray *ids = @[@"albumId1", @"albumId2", @"albumId3"];
    NSDictionary *expectedParameters = @{@"ids":@"albumId1,albumId2,albumId3"};
    NSString *expectedString = @"https://api.spotify.com/v1/albums";
    MFEndpoint *endpoint = [MFEndpoint endpointForAlbumsWithAlbumIds:ids];
    
    XCTAssertEqualObjects(expectedString, endpoint.urlString);
    XCTAssertEqualObjects(expectedParameters, endpoint.parameters);
}

- (void)test_whenEndpointForMultipleArtists_thenReturnCorrectURL
{
    NSArray *ids = @[@"artistId1", @"artistId2"];
    NSDictionary *expectedParameters = @{@"ids": @"artistId1,artistId2"};
    NSString *expectedString = @"https://api.spotify.com/v1/artists";
    MFEndpoint *endpoint = [MFEndpoint endpointforArtistsWithAritstIds:ids];
    XCTAssertEqualObjects(expectedString, endpoint.urlString);
    XCTAssertEqualObjects(expectedParameters, endpoint.parameters);

}
@end
