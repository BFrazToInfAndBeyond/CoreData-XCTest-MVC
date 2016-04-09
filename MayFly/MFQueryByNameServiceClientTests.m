#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import "MFQueryByNameServiceClient.h"

@interface MFQueryByNameServiceClientTests : XCTestCase

@end

@implementation MFQueryByNameServiceClientTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}


//TODO: Get this to pass
//- (void)test_whenDownloadCalled_thenCorrectService
//{
//    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        return ([request.URL.path isEqualToString:@"/v1/search"]);
//    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
//        NSArray *queryParams = [[request.URL query] componentsSeparatedByString:@"&"];
//        XCTAssertEqualObjects(@(queryParams.count), @2);
//        XCTAssertEqualObjects(queryParams[0],@"q=artistName");
//        XCTAssertEqualObjects(queryParams[1],@"type=artist");
//        return [OHHTTPStubsResponse responseWithJSONObject:@[@"some data"] statusCode:200 headers:nil];
//    }];
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    MFQueryByNameServiceClient *testObject = [[MFQueryByNameServiceClient alloc] initWithRequestOperationManager:manager];
//    id<MFQueryByNameServiceClientDelegate> mockDelegate = SBLMock(@protocol(MFQueryByNameServiceClientDelegate));
//    testObject.delegate = mockDelegate;
//    
//    NSString *signal = @"success";
//    [SBLWhen([mockDelegate downloadSucceededForQueryWithSerializedResponse:SBLAny(NSArray *)])thenDoWithInvocation:^(NSInvocation *invocation) {
//        [self asySignal:signal];
//    }];
//    [testObject downloadEntityWithQueryByName:@"artistName" type:MFArtistScope];
//    
//    [self asyWaitForSignal:signal timeout:2];
//    
//}

//- (void)test_whenTransformingResponseDataOfArtist_thenTransformAsExpected
//{ 
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    MFQueryByNameServiceClient *testObject = [[MFQueryByNameServiceClient alloc] initWithRequestOperationManager:manager];
//   NSArray *actual = [testObject serializeDataWithResponse:[self mockResponseDataWithFilename:@"SerializedQueryArtistByName"] type:MFArtistScope];
//    NSArray *expected= @[];
//    XCTAssertEqualObjects(actual,expected);
//}
//
//- (NSDictionary *)mockResponseDataWithFilename:(NSString *)fileName
//{
//    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:fileName ofType:@"json"];
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
//    NSError *error = nil;
//    NSArray *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    return @{@"artists":response};
//}
@end
