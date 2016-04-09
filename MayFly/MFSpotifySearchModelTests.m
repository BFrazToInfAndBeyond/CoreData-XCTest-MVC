#import "MFSpotifySearchModel.h"
#import "MFArtistEntity.h"


@interface MFSearchModelTests : XCTestCase
{
    MFSpotifySearchModel *testObject;
    MFServiceClientFactory *mockServiceClientFactory;
    id<MFPersistenceFactory> mockPersistenceFactory;
    MFQueryByNameServiceClient *mockQueryByNameServiceClient;
    id<MFArtistPersistence> mockArtistPersistence;
    MFPersistencePonsoProvider *mockPersistencePonsoProvider;
    MFMemoryStack *mockMemoryStack;
}
@end

@implementation MFSearchModelTests

- (void)setUp {
    [super setUp];
    
    mockServiceClientFactory = SBLMock([MFServiceClientFactory class]);
    mockPersistenceFactory = SBLMock(@protocol(MFPersistenceFactory));
    mockQueryByNameServiceClient = SBLMock([MFQueryByNameServiceClient class]);
    mockArtistPersistence = SBLMock(@protocol(MFArtistPersistence));
    mockPersistencePonsoProvider = SBLMock([MFPersistencePonsoProvider class]);
    mockMemoryStack = SBLMock([MFMemoryStack class]);
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenRequestTitle_thenModelReturnsExpected
{
    testObject = [[MFSpotifySearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    
    XCTAssertEqualObjects(@"Search Spotify", [testObject searchResultsTitle]);
}

- (MFAlbumEntity *)newAlbumEntityWithId:(NSString *)albumId name:(NSString *)name
{
    MFAlbumEntity *albumEntity;
    albumEntity.id = albumId;
    albumEntity.name = name;
    return albumEntity;
}

- (id<MFArtist>)newArtistEntityWithId:(NSString *)artistId name:(NSString *)name
{
    
    MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:nil name:nil popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistEntity *artistEntity = (MFArtistEntity *)artistPonso;
    artistEntity.id = artistId;
    artistEntity.name = name;
    return artistEntity;
}

- (void)test_whenToggledArtistAsFavoriteANDArtistIsAlreadyInDatabase_thenCallToggleFavoriteANDNeverCallDownload
{
    MFArtistEntity *artistEntity = [self newArtistEntityWithId:@"artistId1" name:@"name"];
    id<MFArtist> artist = artistEntity;
    [SBLWhen([mockArtistPersistence artistWithArtistId:SBLAny(NSString *)])thenReturn:artist];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    testObject = [[MFSpotifySearchModel alloc]initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:0];
    [testObject toggledFavoriteWithResultId:@"artistId1"];
    SBLVerify([mockArtistPersistence favoriteToggleWithArtistId:@"artistId1"]);
    SBLVerifyNever([mockArtistPersistence saveArtistPonso:SBLAny(MFArtistPonso *)]);
    
}

- (MFTrackEntity *)newTrackEntityWithId:(NSString *)id name:(NSString *)name track_number:(NSNumber *)track_number disc_number:(NSNumber *)disc_number url:(NSString *)url isFavorite:(NSNumber *)isFavorite popularity:(NSNumber *)popularity explicit:(NSNumber *)explicit albumId:(NSString *)albumId albumName:(NSString *)albumName{
    MFTrackEntity *trackEntity;
    
    trackEntity.id = id;
    trackEntity.name = name;
    trackEntity.track_number = track_number;
    trackEntity.disc_number = disc_number;
    trackEntity.url = url;
    trackEntity.isFavorite = isFavorite;
    trackEntity.popularity = popularity;
    trackEntity.explicit = explicit;
    trackEntity.albumId = albumId;
    trackEntity.albumName = albumName;
    
    return trackEntity;
}


- (void)test_whenUpdateScopeIndexWithArtist_thenSearchQueryReflectsUpdatedScope{
    [SBLWhen([mockServiceClientFactory queryByNameServiceClient])thenReturn:mockQueryByNameServiceClient];
    testObject = [[MFSpotifySearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];

    [testObject updateScopeIndex:0];
    [testObject queryWithSearchText:@"artistName"];
    
    SBLVerify([mockQueryByNameServiceClient downloadEntityWithQueryByName:@"artistName" type:MFArtistScope]);
    
    [testObject updateScopeIndex:1];
    [testObject queryWithSearchText:@"albumName"];
    
    SBLVerify([mockQueryByNameServiceClient downloadEntityWithQueryByName:@"albumName" type:MFAlbumScope]);
    
    
    [testObject updateScopeIndex:2];
    [testObject queryWithSearchText:@"trackName"];
    
    SBLVerify([mockQueryByNameServiceClient downloadEntityWithQueryByName:@"trackName" type:MFTrackScope]);
}

- (void)test_whenModelToldToUpdateEntities_thenItPerformsAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    testObject = [[MFSpotifySearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject setSerializedData:@[artistPonso1, artistPonso2, artistPonso3]];
    [testObject setScopeIndex:0];
    [testObject updateEntities];

    
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @3);
    XCTAssertEqualObjects([transformed[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformed[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformed[2] name], @"SaiBonzai Bonhomme Buns");
}

//- (void)downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:(NSArray *)serializedResponse fromClick:(BOOL)fromClick
//{
//    
//    
//    if (fromClick) {
//        [self setScopeIndex:1];
//        [self.memoryStack pushMemoryStack:serializedResponse];
//    } else {
//        [self.memoryStack clearAndPushMemoryStack:serializedResponse];
//    }
//    
//    [self setSerializedData:serializedResponse];
//    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
//}

- (void)test_whenMultipleAlbumServiceClientDelegateNotifiedOfSuccessANDFromClick_thenPerformAsExpected
{
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    testObject = [[MFSpotifySearchModel alloc]initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    NSArray *expectedResponse = @[albumPonso1, albumPonso2];
    [(id<MFMultipleAlbumsServiceClientDelegate>)testObject downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:expectedResponse fromClick:YES];
    
    XCTAssertTrue(testObject.scopeIndex == 1);
    SBLVerify([mockMemoryStack pushMemoryStack:expectedResponse]);
    SBLVerifyNever([mockMemoryStack clearAndPushMemoryStack:expectedResponse]);
    XCTAssertEqualObjects(testObject.serializedData, expectedResponse);
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @2);
    XCTAssertEqualObjects([transformedData[0] name], albumPonso2.name);
    XCTAssertEqualObjects([transformedData[1] name], albumPonso1.name);
    
}

- (void)test_whenMultipleAlbumServiceClientDelegateNotifiedOfSuccessANDNotFromClick_thenPerformAsExpected
{
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    testObject = [[MFSpotifySearchModel alloc]initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [(id<MFMultipleAlbumsServiceClientDelegate>)testObject downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:@[albumPonso1, albumPonso2] fromClick:NO];
    NSArray *expectedResponse = @[albumPonso1, albumPonso2];
    SBLVerifyNever([mockMemoryStack pushMemoryStack:expectedResponse]);
    SBLVerify([mockMemoryStack clearAndPushMemoryStack:expectedResponse]);
    XCTAssertEqualObjects(testObject.serializedData, expectedResponse);
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @2);
    XCTAssertEqualObjects([transformedData[0] name], albumPonso2.name);
    XCTAssertEqualObjects([transformedData[1] name], albumPonso1.name);
    
}

- (NSDictionary *)mockResponseSearchSpotifyByNameArtistData
{
    
    NSDictionary *data = @{@"artists" : @{
            @"href" : @"https://api.spotify.com/v1/search?query=Muse&offset=0&limit=20&type=artist",
            @"items" : @[ @{
                @"external_urls" : @{
                    @"spotify" : @"https://open.spotify.com/artist/12Chz98pHFMPJEknJQMWvI"
                },
                @"genres" : @[ ],
                @"href" : @"https://api.spotify.com/v1/artists/12Chz98pHFMPJEknJQMWvI",
                @"id" : @"12Chz98pHFMPJEknJQMWvI",
                @"images" : @[ @{
                    @"height" : @795,
                    @"url" : @"https://i.scdn.co/image/fadafc21ef4721a0666219a20c7ecd997f6b95d9",
                    @"width" : @1000
                }, @{
                    @"height" : @509,
                    @"url" : @"https://i.scdn.co/image/e47070e906297890cbd50862756070100127aa5d",
                    @"width" : @640
                }, @{
                    @"height" : @159,
                    @"url" : @"https://i.scdn.co/image/556bc16088fb5dc7eac18b4ec2bdaa635475e6d5",
                    @"width" : @200
                }, @{
                    @"height" : @51,
                    @"url" : @"https://i.scdn.co/image/589e1010856d245f3d9691ef9052be40325b8982",
                    @"width" : @64
                } ],
                @"name" : @"Muse",
                @"popularity" : @65,
                @"type" : @"artist",
                @"uri" : @"spotify:artist:12Chz98pHFMPJEknJQMWvI"
            }, @{
                @"external_urls" : @{
                    @"spotify" : @"https://open.spotify.com/artist/4L6i1I6tFpc1bKui5coGme"
                },
                @"genres" : @[ ],
                @"href" : @"https://api.spotify.com/v1/artists/4L6i1I6tFpc1bKui5coGme",
                @"id" : @"4L6i1I6tFpc1bKui5coGme",
                @"images" : @[ @{
                    @"height" : @640,
                    @"url" : @"https://i.scdn.co/image/2bc67201ad4ed2d810185697d97da86aa7128e18",
                    @"width" : @640
                }, @{
                    @"height" : @300,
                    @"url" : @"https://i.scdn.co/image/0f56c509a60ad157b8d8d4a97aa346986a93ad83",
                    @"width" : @300
                }, @{
                    @"height" : @64,
                    @"url" : @"https://i.scdn.co/image/e81320b9325ead29a959b8ff94b3ee7709c50bbc",
                    @"width" : @64
                } ],
                @"name" : @"Muse",
                @"popularity" : @17,
                @"type" : @"artist",
                @"uri" : @"spotify:artist:4L6i1I6tFpc1bKui5coGme"
            }],
        }
    };
    return data;
    
}


@end
