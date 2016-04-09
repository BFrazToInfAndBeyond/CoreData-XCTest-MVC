#import "MFArtistServiceClient.h"
#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface MFArtistServiceClientTests : XCTestCase

@end

@implementation MFArtistServiceClientTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

//- (void)test_whenDownloadCalled_thenCorrectServiceParametersUsed
//{
//    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        return ([request.URL.path isEqualToString:@"/v1/artists/artistId"]);
//    }withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
//        NSArray *queryParams = [[request.URL query] componentsSeparatedByString:@"&"];
//        XCTAssertEqualObjects(@(queryParams.count), @0);
//        return [OHHTTPStubsResponse responseWithJSONObject:@[@"some data"] statusCode:200 headers:nil];
//        
//    }];
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    MFArtistServiceClient *testObject = [[MFArtistServiceClient alloc] initWithRequestOperationManager:manager];
//    
//    NSString *signal = @"success";
//    [testObject downloadArtistWithId:@"artistId" completionBlock:^(NSArray *response, NSError *error) {
//        XCTAssertEqualObjects(response, @[@"some data"]);
//        [self asySignal:signal];
//        
//    }];
//    
//    [self asyWaitForSignal:signal timeout:2];
//    
//}

@end
