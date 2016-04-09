#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import "MFArtistAlbumsServiceClient.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface MFArtistAlbumsServiceClientTests : XCTestCase

@end

@implementation MFArtistAlbumsServiceClientTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

//- (void)test_whenDownloadCalled_thenCorrectParametersUsed
//{
//    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        return ([request.URL.path isEqualToString:@"/v1/artists/someArtistId/albums"]);
//    }withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
//        NSArray *queryParams = [[request.URL query] componentsSeparatedByString:@"&"];
//        XCTAssertEqualObjects(@(queryParams.count), @0);
//        return [OHHTTPStubsResponse responseWithJSONObject:@[@"some data"] statusCode:200 headers:nil];
//        
//    }];
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    MFArtistAlbumsServiceClient *testObject = [[MFArtistAlbumsServiceClient alloc] initWithRequestOperationManager:manager];
//    
//    NSString *signal = @"success";
//    [testObject downloadAlbumsForArtistId:@"someArtistId" completionBlock:^(NSArray *response, NSError *error) {
//        XCTAssertEqualObjects(response, @[@"some data"]);
//        [self asySignal:signal];
//    }];
//    
//    [self asyWaitForSignal:signal timeout:2];
//    
//}

@end
