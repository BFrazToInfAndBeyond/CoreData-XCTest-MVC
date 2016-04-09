#import "MFPersistencePonsoProvider.h"
#import "MFArtistEntity.h"
#import "MFImageEntity.h"
#import "MFArtistPonso.h"

@interface MFPersistingPonsoProviderTests : XCTestCase
{
    MFPersistencePonsoProvider *testObject;
    id<MFPersistenceFactory> mockPersistenceFactory;
    id<MFArtistPersistence> mockArtistPersistence;
    id<MFTrackPersistence> mockTrackPersistence;
    id<MFImagePersistence> mockImagePersistence;
    id<MFAlbumPersistence> mockAlbumPersistence;
}
@end

@implementation MFPersistingPonsoProviderTests

- (void)setUp {
    [super setUp];
    mockPersistenceFactory = SBLMock(@protocol(MFPersistenceFactory));
    mockArtistPersistence = SBLMock(@protocol(MFArtistPersistence));
    mockTrackPersistence = SBLMock(@protocol(MFTrackPersistence));
    mockImagePersistence = SBLMock(@protocol(MFImagePersistence));
    mockAlbumPersistence = SBLMock(@protocol(MFAlbumPersistence));
    
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenQueryWithSearchTextANDTypeIsOfArtistANDIsFavorite_thenCallCorrectMethod
{
    MFImagePonso *imagePonso = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@10 width:@20 url:@"url1"];
    MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:@"id1" name:@"ayn rand" popularity:@80 isFavorite:@1 albums:nil images:[NSSet setWithObject:imagePonso] relatedArtists:nil tracks:nil genres:nil];
    
    [SBLWhen([mockArtistPersistence fetchArtistsWithSearchText:@"a" searchScope:MFSearchScopeFavorite])thenReturn:@[artistPonso]];
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    testObject = [[MFPersistencePonsoProvider alloc] initWithPersistenceFactory:mockPersistenceFactory];
    NSArray *actual = [testObject queryWithSearchText:@"a" type:MFArtistScope];
    NSArray *actualImages = [[(MFArtistEntity *)actual[0] images] allObjects];
    XCTAssertEqualObjects(@(actual.count), @1);
    XCTAssertEqualObjects([actual[0] name], artistPonso.name);
    XCTAssertEqualObjects([actual[0] id], artistPonso.id);
    XCTAssertEqualObjects(@(actualImages.count), @1);
    XCTAssertTrue([actual[0] isKindOfClass:[MFArtistPonso class]]);
    XCTAssertEqualObjects([(MFImagePonso *)actualImages[0] url], @"url1");
    SBLVerify([mockArtistPersistence fetchArtistsWithSearchText:@"a" searchScope:MFSearchScopeFavorite]);
    
}

- (void)test_whenQueryWithSearchTextANDPonsoIsOfTypeAlbumANDSearchScopeIsFavorite_thenFetchAlbumOnly
{
    MFAlbumPonso *albumPonsoToReturn = [[MFAlbumPonso alloc] initWithId:@"albumId" name:@"albumName" isFavorite:@1 popularity:@30 explicit:@1 release_date:@"rd" release_date_precision:@"rdp" artists:nil images:nil tracks:nil];
    [SBLWhen([mockAlbumPersistence fetchAlbumsWithSearchText:@"albumName" searchScope:MFSearchScopeFavorite])thenReturn:@[albumPonsoToReturn]];
    [SBLWhen([mockPersistenceFactory albumPersistence])thenReturn:mockAlbumPersistence];
    testObject = [[MFPersistencePonsoProvider alloc] initWithPersistenceFactory:mockPersistenceFactory];
    NSArray *actual = [testObject queryWithSearchText:@"albumName" type:MFAlbumScope];
    SBLVerify([mockAlbumPersistence fetchAlbumsWithSearchText:@"albumName" searchScope:MFSearchScopeFavorite]);
    XCTAssertEqualObjects(@(actual.count), @1);
    XCTAssertEqualObjects(actual[0], albumPonsoToReturn);
}

- (void)test_whenQueryWithSearchTextANDPonsoIsOfTypeTrackANDSearchScopeFavorite_thenFetchTracksANDImages
{
    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@10 width:@20 url:@"url1"];
    MFImagePonso *imagePonso2 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@10 width:@20 url:@"url2"];
    MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:@"trackId" name:@"trackName" albumId:@"albumId" albumName:@"albumName" explicit:@1 isFavorite:@1 disc_number:@2 track_number:@13 url:@"url" popularity:@20 artists:nil images:nil];

    [SBLWhen([mockTrackPersistence fetchTracksWithSearchText:@"trackName" searchScope:MFSearchScopeFavorite])thenReturn:@[trackPonso]];
    [SBLWhen([mockImagePersistence fetchImagesWithAlbumId:@"albumId"])thenReturn:[NSSet setWithObjects:imagePonso1, imagePonso2, nil]];
    [SBLWhen([mockPersistenceFactory imagePersistence])thenReturn:mockImagePersistence];
    [SBLWhen([mockPersistenceFactory trackPersistence])thenReturn:mockTrackPersistence];
    
    testObject = [[MFPersistencePonsoProvider alloc] initWithPersistenceFactory:mockPersistenceFactory];
    
    NSArray *actual = [testObject queryWithSearchText:@"trackName" type:MFTrackScope];
    NSSet *expectedImages = [NSSet setWithObjects:imagePonso1, imagePonso2, nil];
    XCTAssertEqualObjects(@(actual.count), @1);
    XCTAssertEqualObjects((MFTrackPonso *)actual[0], trackPonso);
    XCTAssertEqualObjects([(MFTrackPonso *)actual[0] images], expectedImages);
    SBLVerify([mockTrackPersistence fetchTracksWithSearchText:@"trackName" searchScope:MFSearchScopeFavorite]);
    
}

- (void)test_whenCallSavePonsoOnAlbumPonso_thenPerformAsExpected
{
    [SBLWhen([mockPersistenceFactory albumPersistence])thenReturn:mockAlbumPersistence];
    MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"albumName" isFavorite:@1 popularity:@20 explicit:@1 release_date:@"rd" release_date_precision:@"rdp" artists:nil images:nil tracks:nil];
    testObject = [[MFPersistencePonsoProvider alloc]initWithPersistenceFactory:mockPersistenceFactory];
    [testObject savePonso:albumPonso];
    SBLVerify([mockAlbumPersistence saveAlbumPonso:albumPonso]);
}

- (void)test_whenCallSavePonsoOnAnArtistPonso_thenPerformAsExpected
{
    [SBLWhen([mockPersistenceFactory artistPersistence])thenReturn:mockArtistPersistence];
    MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:@"id1" name:@"ayn rand" popularity:@80 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    testObject = [[MFPersistencePonsoProvider alloc] initWithPersistenceFactory:mockPersistenceFactory];
    [testObject savePonso:artistPonso];
    SBLVerify([mockArtistPersistence saveArtistPonso:artistPonso]);
    
}

- (void)test_whenCallSavePonsoOnTrackPonso_thenPerformAsExpected
{
    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@10 width:@20 url:@"url1"];
    MFImagePonso *imagePonso2 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@10 width:@20 url:@"url2"];
    MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:@"trackId" name:@"trackName" albumId:@"albumId" albumName:@"albumName" explicit:@1 isFavorite:@1 disc_number:@2 track_number:@13 url:@"url" popularity:@20 artists:nil images:[NSSet setWithObjects:imagePonso1, imagePonso2, nil]];
    [SBLWhen([mockPersistenceFactory imagePersistence])thenReturn:mockImagePersistence];
    [SBLWhen([mockPersistenceFactory trackPersistence])thenReturn:mockTrackPersistence];
    testObject = [[MFPersistencePonsoProvider alloc] initWithPersistenceFactory:mockPersistenceFactory];
    [testObject savePonso:trackPonso];
    SBLVerify([mockTrackPersistence saveTrackPonso:trackPonso]);
    SBLVerify([mockImagePersistence saveImagePonso:imagePonso1]);
    SBLVerify([mockImagePersistence saveImagePonso:imagePonso2]);
}



@end
