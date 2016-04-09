#import "AFHTTPRequestOperationManager.h"
#import "MFServiceClientFactory.h"

@interface MFServiceClientFactoryTests : XCTestCase
{
    MFServiceClientFactory *testObject;
    AFHTTPRequestOperationManager *requestOperationManager;
}
@end

@implementation MFServiceClientFactoryTests

- (void)setUp {
    [super setUp];
    requestOperationManager = SBLMock([AFHTTPRequestOperationManager class]);
    testObject = [[MFServiceClientFactory alloc] initWithRequestOperationManager:requestOperationManager];
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenRequestMultipleArtistServiceClient_thenFactoryReturnsAsExpected
{
    id objectReturned = [testObject artistServiceClient];
    XCTAssertTrue([objectReturned isKindOfClass:[MFArtistServiceClient class]]);
}

- (void)test_whenRequestArtistAlbumServiceClient_thenFactoryReturnsAsExpected
{
    id objectReturned = [testObject artistAlbumsServiceClient];
    XCTAssertTrue([objectReturned isKindOfClass:[MFArtistAlbumsServiceClient class]]);
}

- (void)test_whenRequestAlbumTrackServiceClient_thenFactoryReturnsAsExpected
{
    id objectReturned = [testObject albumTracksServiceClient];
    XCTAssertTrue([objectReturned isKindOfClass:[MFAlbumTracksServiceClient class]]);
}

- (void)test_whenRequestQueryByNameServiceClient_thenFactoryReturnsAsExpected
{
    id objectReturned = [testObject queryByNameServiceClient];
    XCTAssertTrue([objectReturned isKindOfClass:[MFQueryByNameServiceClient class]]);
}

- (void)test_whenRequestRelatedArtistsServiceClient_thenFactoryReturnsAsExpected
{
    id objectReturned = [testObject relatedArtistsServiceClient];
    XCTAssertTrue([objectReturned isKindOfClass:[MFRelatedArtistsServiceClient class]]);
}

- (void)test_whenRequestMutlipleAlbumsServiceClient_thenFactoryReturnsAsExpected
{
    id objectReturned = [testObject multipleAlbumsServiceClient];
    XCTAssertTrue([objectReturned isKindOfClass:[MFMultipleAlbumsServiceClient class]]);
}

- (void)test_whenRequestMutlipleAristsServiceClient_thenFactoryReturnsAsExpected
{
    id objectReturned = [testObject multipleArtistsServiceClient];
    XCTAssertTrue([objectReturned isKindOfClass:[MFMultipleArtistsServiceClient class]]);
}
@end