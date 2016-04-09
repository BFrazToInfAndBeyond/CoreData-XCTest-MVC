#import "MFFavoritedSearchModel.h"


@interface MFDownloadedSearchModelTests : XCTestCase
{
    MFFavoritedSearchModel *testObject;
    MFServiceClientFactory *mockServiceClientFactory;
    id<MFPersistenceFactory> mockPersistenceFactory;
    MFPersistencePonsoProvider *mockPersistencePonsoProvider;
    MFMemoryStack *mockMemoryStack;
}
@end

@implementation MFDownloadedSearchModelTests

- (void)setUp {
    [super setUp];
    mockPersistenceFactory = SBLMock(@protocol(MFPersistenceFactory));
    mockServiceClientFactory = SBLMock([MFServiceClientFactory class]);
    mockPersistencePonsoProvider = SBLMock([MFPersistencePonsoProvider class]);
    mockMemoryStack = SBLMock([MFMemoryStack class]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_whenModelRequestedForSearchResultsTitle_thenModelReturnsAsExpected{
    testObject = [[MFFavoritedSearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    NSString *expectedTitle = @"Search Favorites";
    NSString *actualTitle = [testObject searchResultsTitle];
    XCTAssertEqualObjects(expectedTitle, actualTitle);
}

- (void)test_whenQueryWithSearchText_thenPerformAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    [SBLWhen([mockPersistencePonsoProvider queryWithSearchText:@"searchText" type:MFArtistScope])thenReturn:@[artistPonso1, artistPonso2, artistPonso3]];
    testObject = [[MFFavoritedSearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject queryWithSearchText:@"searchText"];
    NSArray *actual = [testObject serializedData];
    XCTAssertEqualObjects(@(actual.count), @3);
    XCTAssertEqualObjects([actual[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([actual[1] name], @"SaiBonzai Bonhomme Buns");
    XCTAssertEqualObjects([actual[2] name], @"Howard Roark");
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @3);
    XCTAssertEqualObjects([transformed[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformed[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformed[2] name], @"SaiBonzai Bonhomme Buns");
}

- (void)test_whenModelRequestedToUpdateEntitiesANDMemoryStackCountIsOne_thenItPerformsAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    [SBLWhen([mockMemoryStack memoryStackCount])thenReturn:@1];
    [SBLWhen([mockPersistencePonsoProvider queryWithSearchText:@"" type:MFArtistScope])thenReturn:@[artistPonso1, artistPonso2, artistPonso3]];
    testObject = [[MFFavoritedSearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject updateEntities];
    NSArray *actual = [testObject serializedData];
    XCTAssertEqualObjects(@(actual.count), @3);
    XCTAssertEqualObjects([actual[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([actual[1] name], @"SaiBonzai Bonhomme Buns");
    XCTAssertEqualObjects([actual[2] name], @"Howard Roark");
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @3);
    XCTAssertEqualObjects([transformed[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformed[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformed[2] name], @"SaiBonzai Bonhomme Buns");
    SBLVerifyNever([mockMemoryStack lastObject]);
}

- (void)test_whenModelRequestedToUpdateEntitiesANDMemoryStackCountIsZero_thenItPerformsAsExpected
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    [SBLWhen([mockMemoryStack memoryStackCount])thenReturn:@0];
    [SBLWhen([mockPersistencePonsoProvider queryWithSearchText:@"" type:MFArtistScope])thenReturn:@[artistPonso1, artistPonso2, artistPonso3]];
    testObject = [[MFFavoritedSearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject updateEntities];
    NSArray *actual = [testObject serializedData];
    XCTAssertEqualObjects(@(actual.count), @3);
    XCTAssertEqualObjects([actual[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([actual[1] name], @"SaiBonzai Bonhomme Buns");
    XCTAssertEqualObjects([actual[2] name], @"Howard Roark");
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @3);
    XCTAssertEqualObjects([transformed[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformed[1] name], @"Howard Roark");
    XCTAssertEqualObjects([transformed[2] name], @"SaiBonzai Bonhomme Buns");
    SBLVerifyNever([mockMemoryStack lastObject]);
}

- (void)test_whenModelRequestedToUpdateEntitesANDMemoryStackCountIsGreaterThanOne_thenItGrabsLastObjectFromStack
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    [SBLWhen([mockMemoryStack memoryStackCount])thenReturn:@2];
    [SBLWhen([mockMemoryStack lastObject])thenReturn:@[artistPonso1, artistPonso2]];
    testObject = [[MFFavoritedSearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    id<MFSearchModelObserver> mockObserver = SBLMock(@protocol(MFSearchModelObserver));
    [testObject escAddObserver:mockObserver];
    [testObject updateEntities];
    NSArray *actual = [testObject serializedData];
    // never set serialized data
    XCTAssertNil(actual);
    NSArray *transformed;
    SBLVerify([mockObserver searchSuccessfulWithResults:SBLCapture(&transformed)]);
    XCTAssertEqualObjects(@(transformed.count), @2);
    XCTAssertEqualObjects([transformed[0] name], @"Fox Fur Fun");
    XCTAssertEqualObjects([transformed[1] name], @"SaiBonzai Bonhomme Buns");
    SBLVerifyNever([mockPersistencePonsoProvider queryWithSearchText:SBLAny(NSString *) type:SBLAny(MFEntityScope)]);

}

- (void)test_whenQueryWithSearchText_thenCallClearAndPopOnMemoryStack
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"Fox Fur Fun" popularity:@0 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"SaiBonzai Bonhomme Buns" popularity:@10 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Howard Roark" popularity:@90 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    [SBLWhen([mockPersistencePonsoProvider queryWithSearchText:@"" type:MFArtistScope])thenReturn:@[artistPonso1, artistPonso2, artistPonso3]];
    testObject = [[MFFavoritedSearchModel alloc] initWithServiceClientFactory:mockServiceClientFactory persistenceFactory:mockPersistenceFactory persistencePonsoProvider:mockPersistencePonsoProvider memoryStack:mockMemoryStack];
    [testObject queryWithSearchText:@""];
    SBLVerify([mockMemoryStack clearAndPushMemoryStack:@[artistPonso1, artistPonso2, artistPonso3]]);
}


@end
