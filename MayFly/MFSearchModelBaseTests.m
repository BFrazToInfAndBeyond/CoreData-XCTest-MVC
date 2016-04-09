#import "MFSearchModelBase.h"
#import "MFAlbumPonso.h"
#import "MFArtistPonso.h"
#import "MFTrackPonso.h"


@interface MFSearchModelBaseTests : XCTestCase
{
    MFSearchModelBase *testObject;
    id<MFPersistenceFactory> mockPersistenceFactory;
    MFServiceClientFactory *mockServiceClientFactory;
    MFArtistServiceClient *mockArtistServiceClient;
    MFQueryByNameServiceClient *mockQueryByNameServiceClient;
    id<MFAlbumPersistence> mockAlbumPersistence;
    id<MFArtistPersistence> mockArtistPersistence;
    id<MFTrackPersistence> mockTrackPersistence;
    MFPersistencePonsoProvider *mockPersistencePonsoProvider;
    MFRelatedArtistsServiceClient *mockRelatedArtistsServiceClient;
    MFAlbumTracksServiceClient *mockAlbumTracksServiceClient;
    MFArtistAlbumsServiceClient *mockArtistAlbumsServiceClient;
    MFMultipleArtistsServiceClient *mockMultipleArtistsServiceClient;
    MFMemoryStack *mockMemoryStack;
    MFMultipleAlbumsServiceClient *mockMultipleAlbumsServiceClient;
}
@end

@implementation MFSearchModelBaseTests

- (void)setUp {
    [super setUp];
    mockPersistenceFactory = SBLMock(@protocol(MFPersistenceFactory));
    mockServiceClientFactory = SBLMock([MFServiceClientFactory class]);
    mockArtistServiceClient = SBLMock([MFArtistServiceClient class]);
    mockQueryByNameServiceClient = SBLMock([MFQueryByNameServiceClient class]);
    mockArtistPersistence = SBLMock(@protocol(MFArtistPersistence));
    mockTrackPersistence = SBLMock(@protocol(MFTrackPersistence));
    mockAlbumPersistence = SBLMock(@protocol(MFAlbumPersistence));
    mockPersistencePonsoProvider = SBLMock([MFPersistencePonsoProvider class]);
    mockRelatedArtistsServiceClient = SBLMock([MFRelatedArtistsServiceClient class]);
    mockAlbumTracksServiceClient = SBLMock([MFAlbumTracksServiceClient class]);
    mockArtistAlbumsServiceClient = SBLMock([MFArtistAlbumsServiceClient class]);
    mockMultipleArtistsServiceClient = SBLMock([MFMultipleArtistsServiceClient class]);
    mockMemoryStack = SBLMock([MFMemoryStack class]);
    mockMultipleAlbumsServiceClient = SBLMock([MFMultipleAlbumsServiceClient class]);
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenModelRequestedScopeButtonTitles_thenModelReturnsExpected
{
    NSArray *expectedButtonTitles = @[@"Artists", @"Albums", @"Tracks"];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    NSArray *actualButtonTitles = [testObject scopeButtonTitles];
    XCTAssertEqualObjects(actualButtonTitles, expectedButtonTitles);
}

- (void)test_whenScopeIsOfArtist_thenEntityIsFavoriteCallsPersistenceAsExpected
{
    MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:@"id" name:nil popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"id"])thenReturn:@YES];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];

    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:0];
    XCTAssertTrue([testObject entityIsFavorite:artistPonso]);
    SBLVerify([mockArtistPersistence isFavoriteWithArtistId:@"id"]);
}

- (void)test_whenScopeIsOfAlbum_thenEntityIsFavoriteCallsPersistenceAsExpected
{
    MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:@"id" name:nil isFavorite:nil popularity:nil explicit:nil release_date:nil release_date_precision:nil artists:nil images:nil tracks:nil];
    [SBLWhen([mockAlbumPersistence isFavoriteWithAlbumId:@"id"])thenReturn:@YES];
    [SBLWhen([mockPersistenceFactory albumPersistence])thenReturn:mockAlbumPersistence];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:1];
    XCTAssertTrue([testObject entityIsFavorite:albumPonso]);
    SBLVerify([mockAlbumPersistence isFavoriteWithAlbumId:@"id"]);
}

- (void)test_whenScopeIsOfTrack_thenEntityIsFavoriteCallsPersistenceAsExpected
{
    MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:@"id" name:nil albumId:nil albumName:nil explicit:nil isFavorite:nil disc_number:nil track_number:nil url:nil popularity:nil artists:nil images:nil];
    [SBLWhen([mockTrackPersistence isFavoriteWithTrackId:@"id"])thenReturn:@YES];
    [SBLWhen([mockPersistenceFactory trackPersistence])thenReturn:mockTrackPersistence];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:2];
    XCTAssertTrue([testObject entityIsFavorite:trackPonso]);
    SBLVerify([mockTrackPersistence isFavoriteWithTrackId:@"id"]);
}
- (void)test_whenArtistPonsosAreGivenToTransformToSearchEntities_thenReturnAsExpected
{
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId2"])thenReturn:@NO];
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId1"])thenReturn:@YES];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    NSString *expectedSecondaryNameFor0thElement = @"Blue as the Moon";
    NSString *expectedSecondaryNameForOtherElement = @"Good Ol' Toot Boot Scootin' Country, Country Blues";
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:expectedSecondaryNameForOtherElement];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"Bonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:expectedSecondaryNameFor0thElement];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:0];
    NSArray *actual = [testObject transformDataToSearchEntities:@[artistPonso1, artistPonso2]];
    XCTAssertEqualObjects(@"Bonzai Bonhomme Buns", [actual[0] name]);
    XCTAssertEqualObjects(@"artistId2", [actual[0] resultId]);
    XCTAssertEqualObjects(@"Fox Fur Fun", [actual[1] name]);
    XCTAssertEqualObjects(@"artistId1", [actual[1] resultId]);
    XCTAssertTrue([(MFSearchResult *)actual[0] isFavorite] == 0);
    XCTAssertTrue([(MFSearchResult *)actual[1] isFavorite] != 0);
    XCTAssertEqualObjects([actual[0] secondaryName], expectedSecondaryNameFor0thElement);
    XCTAssertEqualObjects([actual[1] secondaryName], expectedSecondaryNameForOtherElement);

    XCTAssertNil([actual[0] image]);
    XCTAssertNil([actual[1] image]);
    XCTAssertEqualObjects(@(actual.count), @2);
    XCTAssertTrue([actual[0] isKindOfClass:[MFSearchResult class]]);
}

- (void)test_whenTrackPonsosAreGivenToTransformToSearchEntites_thenReturnAsExpected
{
    
    [SBLWhen([mockTrackPersistence isFavoriteWithTrackId:@"trackId1"])thenReturn:@YES];
    [SBLWhen([mockTrackPersistence isFavoriteWithTrackId:@"trackId2"])thenReturn:@NO];
    [SBLWhen([mockPersistenceFactory trackPersistence])thenReturn:mockTrackPersistence];
    
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];

    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:2];
    NSArray *actual = [testObject transformDataToSearchEntities:@[trackPonso2, trackPonso1]];
    
    XCTAssertTrue([actual[0] isKindOfClass:[MFSearchResult class]]);
    XCTAssertEqualObjects(@(actual.count), @2);
    XCTAssertTrue([(MFSearchResult *)actual[0] isFavorite] != 0);
    XCTAssertTrue([(MFSearchResult *)actual[1] isFavorite] == 0);
    XCTAssertEqualObjects([actual[0] name], @"Forilla Fozilla");
    XCTAssertEqualObjects([actual[0] resultId], @"trackId1");
    XCTAssertEqualObjects([actual[0] secondaryName], @"Fox Fur Fun, Honest Abe & The Cherry Tree");
    XCTAssertNil([actual[0] image]);
    XCTAssertEqualObjects([actual[1] name], @"Vanilla Black Ice");
    XCTAssertEqualObjects([actual[1] resultId], @"trackId2");
    XCTAssertEqualObjects([actual[1] secondaryName], @"Howard Roark, Granular Granite");
    XCTAssertNil([actual[1] image]);
}

- (void)test_whenAlbumPonsosAreGivenToTransformToSearchEntitesANDTracksNilANDAccurateTrackCount_thenReturnAsExpected
{
    [SBLWhen([mockAlbumPersistence isFavoriteWithAlbumId:@"albumId1"])thenReturn:@NO];
    [SBLWhen([mockAlbumPersistence isFavoriteWithAlbumId:@"albumId2"])thenReturn:@YES];
    [SBLWhen([mockPersistenceFactory albumPersistence])thenReturn:mockAlbumPersistence];
    
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil tracks:nil numberOfTracks:2];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil tracks:nil];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:1];
    NSArray * actual = [testObject transformDataToSearchEntities:@[albumPonso1, albumPonso2]];
    XCTAssertTrue([actual[0] isKindOfClass:[MFSearchResult class]]);
    XCTAssertEqualObjects(@(actual.count), @2);
    XCTAssertTrue([(MFSearchResult *)actual[0] isFavorite] != 0);
    XCTAssertTrue([(MFSearchResult *)actual[1] isFavorite] == 0);
    XCTAssertEqualObjects([actual[0] name], @"Monilla Monzilla Man Eaters");
    XCTAssertEqualObjects([actual[0] resultId], @"albumId2");
    XCTAssertEqualObjects([actual[0] secondaryName], @"Fox Fur Fun, SaiBonzai Bonhomme Buns");
    XCTAssertNil([actual[0] image]);
    XCTAssertEqualObjects([actual[1] name], @"Plain Purple Platinum Planets");
    XCTAssertEqualObjects([actual[1] resultId], @"albumId1");
    XCTAssertEqualObjects([actual[1] secondaryName], @"Howard Roark, SaiBonzai Bonhomme Buns, 2");
    XCTAssertNil([actual[1] image]);
}

- (void)test_whenAlbumPonsosAreGivenToTransformToSearchEntitiesANDTracksNonNilANDDefaultTrackCountOfZero_thenReturnAsExpected
{
    
    [SBLWhen([mockAlbumPersistence isFavoriteWithAlbumId:@"albumId1"])thenReturn:@NO];
    [SBLWhen([mockAlbumPersistence isFavoriteWithAlbumId:@"albumId2"])thenReturn:@YES];
    [SBLWhen([mockPersistenceFactory albumPersistence])thenReturn:mockAlbumPersistence];
    
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];
    
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil tracks:[NSSet setWithObjects:trackPonso1, trackPonso2, nil]];
   
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil tracks:nil];
                                 
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:1];
    NSArray * actual = [testObject transformDataToSearchEntities:@[albumPonso1, albumPonso2]];
    XCTAssertTrue([actual[0] isKindOfClass:[MFSearchResult class]]);
    XCTAssertEqualObjects(@(actual.count), @2);
    XCTAssertTrue([(MFSearchResult *)actual[0] isFavorite] != 0);
    XCTAssertTrue([(MFSearchResult *)actual[1] isFavorite] == 0);
    XCTAssertEqualObjects([actual[0] name], @"Monilla Monzilla Man Eaters");
    XCTAssertEqualObjects([actual[0] resultId], @"albumId2");
    XCTAssertEqualObjects([actual[0] secondaryName], @"Fox Fur Fun, SaiBonzai Bonhomme Buns");
    XCTAssertNil([actual[0] image]);
    XCTAssertEqualObjects([actual[1] name], @"Plain Purple Platinum Planets");
    XCTAssertEqualObjects([actual[1] resultId], @"albumId1");
    XCTAssertEqualObjects([actual[1] secondaryName], @"Howard Roark, SaiBonzai Bonhomme Buns, 2");
    XCTAssertNil([actual[1] image]);
    
}

- (void)test_whenViewRelatedFavoriteCalled_thenDownloadRelatedArtistsCalledAsExpected
{
    [SBLWhen([mockServiceClientFactory relatedArtistsServiceClient])thenReturn:mockRelatedArtistsServiceClient];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject selectedViewRelatedArtistsWithArtistId:@"artistId"];
    SBLVerify([mockRelatedArtistsServiceClient downloadRelatedArtistsWithId:@"artistId"]);
}

- (void)test_whenFavoriteAllEntitesANDEntityNonArtist_thenPerformAsExpected
{
    
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso3 = [[MFTrackPonso alloc] initWithId:@"trackId3" name:@"hiza horrillaNilla" albumId:@"albumId1" albumName:@"High In The Sky On Cloud 9" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@3 url:@"url3" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];

    
    
    [SBLWhen([mockTrackPersistence isFavoriteWithTrackId:@"trackId1"])thenReturn:@YES];
    [SBLWhen([mockTrackPersistence isFavoriteWithTrackId:@"trackId2"])thenReturn:@NO];
        [SBLWhen([mockTrackPersistence isFavoriteWithTrackId:@"trackId3"])thenReturn:@NO];
    [SBLWhen([mockTrackPersistence trackWithTrackId:@"trackId2"])thenReturn:trackPonso2];
    [SBLWhen([mockTrackPersistence trackWithTrackId:@"trackId3"])thenReturn:nil];
    [SBLWhen([mockPersistenceFactory trackPersistence])thenReturn:mockTrackPersistence];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:2];
    [testObject setSerializedData:@[trackPonso1, trackPonso2, trackPonso3]];

    [testObject selectedFavoriteAllEntities];
    SBLVerify([mockTrackPersistence favoriteToggledWithTrack:@"trackId2"]);
    SBLVerify([mockPersistencePonsoProvider savePonso:trackPonso3]);
    SBLVerifyNever([mockTrackPersistence favoriteToggledWithTrack:@"trackId1"]);
    
}

- (void)test_whenSelectedFavoriteAllArtistsANDAllAlreadyFavorited_thenPerformAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId1"])thenReturn:@YES];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    [SBLWhen([mockServiceClientFactory multipleArtistsServiceClient])thenReturn:mockMultipleArtistsServiceClient];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    
    [testObject setScopeIndex:0];
    [testObject setSerializedData:@[artistPonso1]];
    
    [testObject selectedFavoriteAllEntities];
    SBLVerifyNever([mockMultipleArtistsServiceClient downloadMultipleArtistsWithArtistIds:SBLAny(NSArray *)]);
    SBLVerifyNever([mockArtistPersistence favoriteToggleWithArtistId:SBLAny(NSString *)]);
    SBLVerifyNever([mockArtistPersistence artistWithArtistId:SBLAny(NSString *)]);
}

- (void)test_whenSelectedFavoriteAllArtistsANDNoneInDataBaseWithDuplicateIds_thenPerformAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso4 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId1"])thenReturn:@NO];
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId2"])thenReturn:@NO];
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId3"])thenReturn:@NO];
    [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId1"])thenReturn:nil];
    [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId2"])thenReturn:nil];
    [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId3"])thenReturn:nil];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    [SBLWhen([mockServiceClientFactory multipleArtistsServiceClient])thenReturn:mockMultipleArtistsServiceClient];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    
    [testObject setScopeIndex:0];
    [testObject setSerializedData:@[artistPonso1, artistPonso2, artistPonso3, artistPonso4]];
    [testObject selectedFavoriteAllEntities];
    NSArray *expectedIds = @[@"artistId1", @"artistId2", @"artistId3"];
    NSArray *actualIds;
    SBLVerify([mockMultipleArtistsServiceClient downloadMultipleArtistsWithArtistIds:SBLCapture(&actualIds)]);
    actualIds = [actualIds sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    XCTAssertEqualObjects(actualIds, expectedIds);
}

- (void)test_whenSelectedFavoriteAllArtistsANDSomeInDatabaseANDSomeNot_thenPerformAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso4 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso5 = [[MFArtistPonso alloc] initWithId:@"artistId5" name:@"Lynyrd Skynyrd" popularity:@0 isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId1"])thenReturn:@YES];
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId2"])thenReturn:@NO];
    [SBLWhen([mockArtistPersistence isFavoriteWithArtistId:@"artistId3"])thenReturn:@NO];
    [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId2"])thenReturn:artistPonso2];
    [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId3"])thenReturn:nil];
        [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId5"])thenReturn:nil];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    [SBLWhen([mockServiceClientFactory multipleArtistsServiceClient])thenReturn:mockMultipleArtistsServiceClient];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    
    [testObject setScopeIndex:0];
    [testObject setSerializedData:@[artistPonso1, artistPonso2, artistPonso3, artistPonso4, artistPonso5]];
    [testObject selectedFavoriteAllEntities];
    NSArray *expectedIds = @[@"artistId3", @"artistId5"];
    NSArray *actualIds;
    SBLVerify([mockMultipleArtistsServiceClient downloadMultipleArtistsWithArtistIds:SBLCapture(&actualIds)]);
    SBLVerifyNever([mockArtistPersistence favoriteToggleWithArtistId:@"artistId1"]);
    SBLVerify([mockArtistPersistence favoriteToggleWithArtistId:@"artistId2"]);
    SBLVerifyNever([mockArtistPersistence artistWithArtistId:@"artistId1"]);
    SBLVerify([mockArtistPersistence artistWithArtistId:@"artistId2"]);
    SBLVerify([mockArtistPersistence artistWithArtistId:@"artistId3"]);
    SBLVerify([mockArtistPersistence artistWithArtistId:@"artistId5"]);
    SBLVerifyNever([mockArtistPersistence favoriteToggleWithArtistId:@"artist5"]);
    SBLVerifyNever([mockArtistPersistence favoriteToggleWithArtistId:@"artistId3"]);
    
    actualIds = [actualIds sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    XCTAssertEqualObjects(actualIds, expectedIds);

}




- (void)test_whenToggledArtistAsFavoriteANDArtistIsNotInDatabase_thenDoNotCallToggleFavoriteOnPersistenceYetCallToDownload
{
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    [SBLWhen([mockServiceClientFactory artistServiceClient])thenReturn:mockArtistServiceClient];
    [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId1"])thenReturn:nil];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject setSerializedData:@[artistPonso1, artistPonso2, artistPonso3]];
    [testObject setScopeIndex:0];
    [testObject toggledFavoriteWithResultId:@"artistId1"];
    SBLVerifyNever([mockArtistPersistence favoriteToggleWithArtistId:@"artistId1"]);
    SBLVerifyNever([mockObserver searchSuccessfulWithResults:SBLAny(NSArray *)]);
    SBLVerify([mockArtistServiceClient downloadArtistWithId:@"artistId1"]);

}

- (void)test_whenToggledArtistAsFavoriteANDArtistIsInDatabase_thenCallToggleFavoriteOnPersistenceANDNotDownload
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    [SBLWhen([mockServiceClientFactory artistServiceClient])thenReturn:mockArtistServiceClient];
    [SBLWhen([mockArtistPersistence artistWithArtistId:@"artistId1"])thenReturn:artistPonso1];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    
    [testObject setSerializedData:@[artistPonso1, artistPonso2, artistPonso3]];
    [testObject setScopeIndex:0];
    [testObject toggledFavoriteWithResultId:@"artistId1"];
    SBLVerify([mockArtistPersistence favoriteToggleWithArtistId:@"artistId1"]);
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @3);
    XCTAssertEqualObjects([transformed[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformed[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformed[2] name], @"SaiBonzai Bonhomme Buns");
    SBLVerifyNever([mockArtistServiceClient downloadArtistWithId:@"artistId1"]);
 
}

- (void)test_whenToggledAlbumAsFavoriteANDAlbumIsInDatabase_thenCallToggleFavoriteOnPersistenceANDNotDownload
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];
    
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil tracks:[NSSet setWithObjects:trackPonso1, trackPonso2, nil]];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil tracks:nil];
    
    [SBLWhen([mockServiceClientFactory albumTracksServiceClient])thenReturn:mockAlbumTracksServiceClient];
    [SBLWhen([mockAlbumPersistence albumWithAlbumId:@"albumId1"])thenReturn:albumPonso1];
    [SBLWhen([mockPersistenceFactory albumPersistence])thenReturn:mockAlbumPersistence];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    
    [testObject setSerializedData:@[albumPonso1, albumPonso2]];
    [testObject setScopeIndex:1];
    [testObject toggledFavoriteWithResultId:@"albumId1"];
    SBLVerify([mockAlbumPersistence favoriteToggledWithAlbumId:@"albumId1"]);
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @2);
    XCTAssertEqualObjects([transformed[0] name], @"Monilla Monzilla Man Eaters");
    XCTAssertEqualObjects([transformed[1] name], @"Plain Purple Platinum Planets");
    SBLVerifyNever([mockAlbumTracksServiceClient downloadTracksForAlbumId:SBLAny(NSString *) images:SBLAny(NSSet *) albumName:SBLAny(NSString *) isFavorite:SBLAny(BOOL)]);
    
}

- (void)test_whenToggledAlbumAsFavoriteANDAlbumIsNOTInDatabase_thenDONOTCallToggleFavoriteOnPersistenceYETDownload
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:nil height:@40 width:@40 url:@"url1"];
    NSSet *imagesForAlbum1 = [NSSet setWithObject:imagePonso1];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];
    
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:imagesForAlbum1 tracks:[NSSet setWithObjects:trackPonso1, trackPonso2, nil]];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil tracks:nil];

    
    [SBLWhen([mockServiceClientFactory albumTracksServiceClient])thenReturn:mockAlbumTracksServiceClient];
    [SBLWhen([mockAlbumPersistence albumWithAlbumId:@"albumId1"])thenReturn:nil];
    [SBLWhen([mockPersistenceFactory albumPersistence])thenReturn:mockAlbumPersistence];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    
    [testObject setSerializedData:@[albumPonso1, albumPonso2]];
    [testObject setScopeIndex:1];
    [testObject toggledFavoriteWithResultId:@"albumId1"];
    SBLVerifyNever([mockAlbumPersistence favoriteToggledWithAlbumId:@"albumId1"]);
    SBLVerifyNever([mockObserver searchSuccessfulWithResults:SBLAny(NSArray *)]);
    SBLVerify([mockAlbumTracksServiceClient downloadTracksForAlbumId:@"albumId1" images:imagesForAlbum1 albumName:@"Plain Purple Platinum Planets" isFavorite:YES]);
    
}



- (void)test_whenToggledTrackAsFavoriteANDTrackIsInDatabase_thenCallToggleFavoriteOnPersistence
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];
    
    
    
    [SBLWhen([mockTrackPersistence trackWithTrackId:@"trackId1"])thenReturn:trackPonso1];
    [SBLWhen([mockPersistenceFactory trackPersistence])thenReturn:mockTrackPersistence];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    
    [testObject setSerializedData:@[trackPonso1, trackPonso2]];
    [testObject setScopeIndex:2];
    [testObject toggledFavoriteWithResultId:@"trackId1"];
    SBLVerify([mockTrackPersistence favoriteToggledWithTrack:@"trackId1"]);
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @2);
    XCTAssertEqualObjects([transformed[0] name], @"Forilla Fozilla");
    XCTAssertEqualObjects([transformed[1] name], @"Vanilla Black Ice");
    SBLVerifyNever([mockPersistencePonsoProvider savePonso:SBLAny(id)]);
}

- (void)test_whenToggledTrackAsFavoriteANDTrackIsNOTInDatabase_thenDoNotCallToggleFavoriteOnPersistenceYETOnlySavePonso
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];
    
    
    
    [SBLWhen([mockTrackPersistence trackWithTrackId:@"trackId1"])thenReturn:nil];
    [SBLWhen([mockPersistenceFactory trackPersistence])thenReturn:mockTrackPersistence];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    
    [testObject setSerializedData:@[trackPonso1, trackPonso2]];
    [testObject setScopeIndex:2];
    [testObject toggledFavoriteWithResultId:@"trackId1"];
    SBLVerifyNever([mockTrackPersistence favoriteToggledWithTrack:@"trackId1"]);
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @2);
    XCTAssertEqualObjects([transformed[0] name], @"Forilla Fozilla");
    XCTAssertEqualObjects([transformed[1] name], @"Vanilla Black Ice");
    SBLVerify([mockPersistencePonsoProvider savePonso:trackPonso1]);
}

- (void)test_whenModelNotifiedAlbumEntitySelectd_thenDownloadTracksForAlbumIdWithCorrectParameters
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:nil height:@40 width:@40 url:@"url1"];
    NSSet *imagesForAlbum1 = [NSSet setWithObject:imagePonso1];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:nil];
    
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso3, artistPonso2, nil] images:imagesForAlbum1 tracks:[NSSet setWithObjects:trackPonso1, trackPonso2, nil]];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:[NSSet setWithObjects:artistPonso1, artistPonso2, nil] images:nil tracks:nil];

    
    [SBLWhen([mockServiceClientFactory albumTracksServiceClient])thenReturn:mockAlbumTracksServiceClient];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    MFSearchResult *searchResult = [[MFSearchResult alloc] initWithName:@"Plain Purple Platinum Planets" secondaryName:@"2nd Name" image:nil resultId:@"albumId1" isFavorite:YES];
    [testObject setScopeIndex:1];
    [testObject setSerializedData:@[albumPonso2, albumPonso1]];
    [testObject selectedEntityWithResult:searchResult];
    SBLVerify([mockAlbumTracksServiceClient downloadTracksForAlbumId:@"albumId1" images:imagesForAlbum1 albumName:@"Plain Purple Platinum Planets" isFavorite:NO]);
    
}

- (void)test_whenModelNotifiedArtistEntitySelected_thenDownloadForArtistId
{
    [SBLWhen([mockServiceClientFactory artistAlbumsServiceClient])thenReturn:mockArtistAlbumsServiceClient];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    MFSearchResult *searchResult = [[MFSearchResult alloc] initWithName:@"name" secondaryName:@"2nd Name" image:nil resultId:@"resultId" isFavorite:YES];
    [testObject selectedEntityWithResult:searchResult];
    SBLVerify([mockArtistAlbumsServiceClient downloadAlbumsForArtistId:@"resultId"]);
}

- (void)test_whenModelNotifiedToGoBackANDPoppedStackReturnsNil_thenDoNotNotifyObserverORModifyScope
{
    
    [SBLWhen([mockMemoryStack popMemoryStack])thenReturn:nil];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:0];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject backOne];
    SBLVerifyNever([mockObserver searchSuccessfulWithResults:SBLAny(NSArray *)]);
    XCTAssertTrue(testObject.scopeIndex == 0);
}

- (void)test_whenModelNotifiedToGoBackANDPoppedStackReturnsNonNil_thenNotifyObserver
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];

    [SBLWhen([mockMemoryStack popMemoryStack])thenReturn:@[artistPonso1, artistPonso2, artistPonso3]];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject backOne];
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @3);
    XCTAssertEqualObjects([transformedData[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformedData[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformedData[2] name], @"SaiBonzai Bonhomme Buns");
    XCTAssertTrue(testObject.scopeIndex == 0);
}

- (void)test_whenModelNotifiedToGoBackANDTransitionToTrackScope_thenItUpdatesScopeAsExpected
{
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:nil images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:nil images:nil];
    [SBLWhen([mockMemoryStack popMemoryStack])thenReturn:@[trackPonso1, trackPonso2]];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    XCTAssertTrue(testObject.scopeIndex == 0);
    [testObject backOne];
    XCTAssertTrue(testObject.scopeIndex == 2);
}

- (void)test_whenModelNotifiedToGoBackANDTransitionToArtistScope_thenItUpdatesScopeAsExpected
{
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    [SBLWhen([mockMemoryStack popMemoryStack])thenReturn:@[artistPonso1, artistPonso2, artistPonso3]];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:2];
    XCTAssertTrue(testObject.scopeIndex == 2);
    [testObject backOne];
    XCTAssertTrue(testObject.scopeIndex == 0);
}

- (void)test_whenModelNotifiedToGoBackANDTransitionToAlbumScope_thenItUpdatesScopeAsExpected
{
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    [SBLWhen([mockMemoryStack popMemoryStack])thenReturn:@[albumPonso1, albumPonso2]];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:2];
    XCTAssertTrue(testObject.scopeIndex == 2);
    [testObject backOne];
    XCTAssertTrue(testObject.scopeIndex == 1);
}


- (void)test_whenRelatedArtistsDelegateNotifiesSuccess_thenPerformAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];

    NSArray *expectedArtists = @[artistPonso1, artistPonso2, artistPonso3];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];

    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];

    [(id<MFRelatedArtistsServiceClientDelegate>)testObject downloadSucceedForRelatedArtistsServiceClientWithSerializedResponse:@[artistPonso1, artistPonso2, artistPonso3]];
    
    SBLVerify([mockMemoryStack pushMemoryStack:expectedArtists]);
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @3);
    XCTAssertEqualObjects([transformedData[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformedData[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformedData[2] name], @"SaiBonzai Bonhomme Buns");
    XCTAssertTrue(testObject.scopeIndex == 0);
    
    XCTAssertEqualObjects([testObject serializedData], expectedArtists);
}

- (void)test_whenArtistServiceClientDelegateNotifiesSuccess_thenPerformAsExpected
{
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setSerializedData:@[artistPonso1, artistPonso2, artistPonso3]];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];

    
    [(id<MFArtistServiceClientDelegate>)testObject downloadSucceedForArtistServiceClientWithSerializedResponse:@[artistPonso2]];
    MFArtistPonso *actualArtist;
    SBLVerify([mockPersistencePonsoProvider savePonso:SBLCapture(&actualArtist)]);
    XCTAssertEqualObjects(actualArtist.name, artistPonso2.name);
    XCTAssertEqualObjects(actualArtist.id, artistPonso2.id);
    XCTAssertEqualObjects(actualArtist.isFavorite, @1);
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @3);
    XCTAssertEqualObjects([transformedData[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformedData[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformedData[2] name], @"SaiBonzai Bonhomme Buns");
    
    XCTAssertTrue(testObject.scopeIndex == 0);

}

- (void)test_whenArtistAlbumsServiceClientDelegateNotifiesSuccess_thenPerformAsExpected
{
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    MFAlbumPonso *albumPonso2Duplicate = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    [SBLWhen([mockServiceClientFactory multipleAlbumsServiceClient])thenReturn:mockMultipleAlbumsServiceClient];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];

    
    
    [(id<MFArtistAlbumsServiceClientDelegate>)testObject downloadSucceededForArtistAlbumsWithSerializedResponse:@[albumPonso1, albumPonso2, albumPonso2Duplicate]];
    NSArray *albumIds;
    SBLVerify([mockMultipleAlbumsServiceClient downloadMultipleAlbumsWithIds:SBLCapture(&albumIds) fromClick:YES]);
    NSArray *sortedAlbumIds = [albumIds sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    XCTAssertEqualObjects(@(sortedAlbumIds.count), @2);
    XCTAssertEqualObjects(sortedAlbumIds[0], @"albumId1");
    XCTAssertEqualObjects(sortedAlbumIds[1], @"albumId2");    
}

- (void)test_whenMultipleArtistsServiceClientDelegateNotifiesSuccess_thenPerformAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];

    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setSerializedData:@[artistPonso1, artistPonso3, artistPonso2]];
    
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    
    [(id<MFMultipleArtistsServiceClientDelegate>)testObject downloadSucceededForMultipleArtistsServiceClientWithSerializedResponse:@[artistPonso1, artistPonso3, artistPonso2]];
    
    MFArtistPonso *actualArtist;
    
    SBLVerifyTimes(SBLTimes(3), [mockPersistencePonsoProvider savePonso:SBLAny(MFArtistPonso *)]);

    SBLVerify([mockPersistencePonsoProvider savePonso:SBLCapture(&actualArtist)]);
    XCTAssertEqualObjects(actualArtist.isFavorite, @YES);
    XCTAssertEqualObjects(actualArtist.id, artistPonso2.id);

    
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @3);
    XCTAssertEqualObjects([transformedData[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformedData[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformedData[2] name], @"SaiBonzai Bonhomme Buns");
    XCTAssertTrue(testObject.scopeIndex == 0);
}


- (void)test_whenMultipleAlbumsServiceClientNotifesDelegateWithResponseSuccessANDFromClickAsYES_thenPerformAsExpected
{
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject setSerializedData:@[albumPonso1]];
    [testObject setScopeIndex:0];
    [(id<MFMultipleAlbumsServiceClientDelegate>)testObject downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:@[albumPonso1, albumPonso2] fromClick:YES];
    SBLVerify([mockMemoryStack pushMemoryStack:@[albumPonso1, albumPonso2]]);
    XCTAssertEqualObjects(@(testObject.serializedData.count), @2);
    XCTAssertEqualObjects([testObject.serializedData[0] id], @"albumId1");
    XCTAssertEqualObjects([testObject.serializedData[1] id], @"albumId2");
    XCTAssertTrue(testObject.scopeIndex == 1);
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @2);
    XCTAssertEqualObjects([transformed[0] name], @"Monilla Monzilla Man Eaters");
    XCTAssertEqualObjects([transformed[1] name], @"Plain Purple Platinum Planets");
}

- (void)test_whenMultipleAlbumsServiceClientNotifesDelegateWithResponseSuccessANDFromClickAsNo_thenPerformAsExpected
{
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    MFAlbumPonso *albumPonso2 = [[MFAlbumPonso alloc] initWithId:@"albumId2" name:@"Monilla Monzilla Man Eaters" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"04/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setSerializedData:@[albumPonso1]];
    [testObject setScopeIndex:0];
    [(id<MFMultipleAlbumsServiceClientDelegate>)testObject downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:@[albumPonso1, albumPonso2] fromClick:NO];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    SBLVerifyNever([mockMemoryStack pushMemoryStack:SBLAny(NSArray *)]);
    SBLVerifyNever([mockObserver searchSuccessfulWithResults:SBLAny(NSArray *)]);
    XCTAssertEqualObjects(@(testObject.serializedData.count), @1);
    XCTAssertEqualObjects([testObject.serializedData[0] id], @"albumId1");
    XCTAssertTrue(testObject.scopeIndex == 0);
}


- (void)test_whenAlbumTracksServiceClientNotifiesDelegateOfSuccessANDIsFavorite_thenPerformAsExpected
{
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:nil images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:nil images:nil];
    
    MFAlbumPonso *modifiedAlbumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    MFAlbumPonso *otherAlbumPonso = [[MFAlbumPonso alloc] initWithId:@"otherAlbumId" name:@"Who is John Gault?" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:nil];
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject setSerializedData:@[otherAlbumPonso, modifiedAlbumPonso1]];
    [(id<MFAlbumTrackServiceClientDelegate>)testObject downloadSucceededForAlbumTracksWithSerializedResponse:@[trackPonso1, trackPonso2] isFavorite:YES resultId:modifiedAlbumPonso1.id];
    MFAlbumPonso *actualAlbum;
    SBLVerify([mockPersistencePonsoProvider savePonso:SBLCapture(&actualAlbum)]);
    XCTAssertEqualObjects(actualAlbum.id, modifiedAlbumPonso1.id);
    XCTAssertTrue(actualAlbum.tracks.count == 2);
    NSArray *tracksOfAlbum = [actualAlbum.tracks allObjects];
    [tracksOfAlbum sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]]];
    XCTAssertEqualObjects([tracksOfAlbum[0] id], trackPonso1.id);
    XCTAssertEqualObjects([tracksOfAlbum[1] id], trackPonso2.id);
    XCTAssertEqualObjects([tracksOfAlbum[0] name], trackPonso1.name);
    XCTAssertEqualObjects([tracksOfAlbum[1] name], trackPonso2.name);
    XCTAssertEqualObjects(actualAlbum.isFavorite, @1);
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @2);
    XCTAssertEqualObjects([transformedData[0] name], @"Plain Purple Platinum Planets");
    XCTAssertEqualObjects([transformedData[1] name], @"Who is John Gault?");
    XCTAssertEqualObjects(@(testObject.serializedData.count), @2);
    XCTAssertEqualObjects([testObject.serializedData[0] id], @"otherAlbumId");
    XCTAssertEqualObjects([testObject.serializedData[1] id], @"albumId1");
    XCTAssertTrue(testObject.scopeIndex != 2);
    SBLVerifyNever([mockMemoryStack pushMemoryStack:SBLAny(NSArray *)]);
}

- (void)test_whenAlbumTracksServiceClientNotifiesDelegateOfSuccessANDIsNotFavorite_thenPerformAsExpected
{
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"Forilla Fozilla" albumId:@"albumId1" albumName:@"Honest Abe & The Cherry Tree" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url1" popularity:@20 artists:nil images:nil];
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Vanilla Black Ice" albumId:@"albumId2" albumName:@"Granular Granite" explicit:@1 isFavorite:@0 disc_number:@2 track_number:@3 url:@"url2" popularity:@30 artists:nil images:nil];
    
    MFAlbumPonso *albumPonso1 = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"Plain Purple Platinum Planets" isFavorite:@0 popularity:@20 explicit:@1 release_date:@"03/21/11" release_date_precision:@"MM/DD/YY" artists:nil images:nil tracks:[NSSet setWithObjects:trackPonso1, trackPonso2, nil]];
    
    
    testObject = [[MFSearchModelBase alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject setScopeIndex:0];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [(id<MFAlbumTrackServiceClientDelegate>)testObject downloadSucceededForAlbumTracksWithSerializedResponse:@[trackPonso1, trackPonso2] isFavorite:NO resultId:albumPonso1.id];
    SBLVerify([mockMemoryStack pushMemoryStack:@[trackPonso1, trackPonso2]]);
    NSArray *transformedData;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformedData)]);
    XCTAssertEqualObjects(@(transformedData.count), @2);
    XCTAssertEqualObjects([transformedData[0] name], @"Forilla Fozilla");
    XCTAssertEqualObjects([transformedData[1] name],  @"Vanilla Black Ice");
    XCTAssertEqualObjects(@(testObject.serializedData.count), @2);
    XCTAssertEqualObjects([testObject.serializedData[0] id], @"trackId1");
    XCTAssertEqualObjects([testObject.serializedData[1] id], @"trackId2");
    XCTAssertTrue(testObject.scopeIndex == 2);
    SBLVerifyNever([mockPersistencePonsoProvider savePonso:SBLAny(id)]);
}

@end
