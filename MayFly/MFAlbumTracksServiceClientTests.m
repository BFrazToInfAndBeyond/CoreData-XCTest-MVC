#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import "MFAlbumTracksServiceClient.h"

@interface MFTracksServiceClientTests : XCTestCase


@end

@implementation MFTracksServiceClientTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

//- (void)test_whenDownloadCalled_thenCorrectService
//{
//    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        return ([request.URL.path isEqualToString:@"/v1/albums/someAlbumId/tracks"]);
//    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
//        NSArray *queryParams = [[request.URL query] componentsSeparatedByString:@"&"];
//        XCTAssertEqualObjects(@(queryParams.count), @0);
//        return [OHHTTPStubsResponse responseWithJSONObject:@[@"some data"] statusCode:200 headers:nil];
//    }];
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    MFAlbumTracksServiceClient *testObject = [[MFAlbumTracksServiceClient alloc] initWithRequestOperationManager:manager];
//    
//    NSString *signal = @"success";
//    [testObject downloadTracksForAlbumId:@"someAlbumId" completionBlock:^(NSArray *response, NSError *error) {
//        XCTAssertEqualObjects(response, @[@"some data"]);
//        [self asySignal:signal];
//    }];
//    
//    [self asyWaitForSignal:signal timeout:2];
//
//    
//}
@end
