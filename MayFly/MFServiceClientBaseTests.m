#import "AFHTTPRequestOperationManager+Timeout.h"
#import "MFServiceClientBase.h"
#import "MFEndpoint.h"

@interface MFServiceClientBaseTests : XCTestCase {
    MFServiceClientBase *testObject;
    AFHTTPRequestOperationManager *mockRequestOperationManager;
    AFHTTPRequestOperation *mockOperation;
    MFEndpoint *endPoint;
    NSTimeInterval timeout;
}

@end

@implementation MFServiceClientBaseTests

typedef void(^completionBlockType)(AFHTTPRequestOperation *operation, id responseObject);

- (void)setUp {
    [super setUp];
    
    mockRequestOperationManager = SBLMock([AFHTTPRequestOperationManager class]);
    mockOperation = SBLMock([AFHTTPRequestOperation class]);
    endPoint = SBLMock([MFEndpoint class]);
    
    timeout = 30;
    
    [SBLWhen([endPoint defaultTimeout])thenReturn:@(timeout)];
    
    testObject = [[MFServiceClientBase alloc] initWithRequestOperationManager:mockRequestOperationManager];
    
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_whenMakeServiceForEndpoint_jsonSerializersAreUsed {
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                   parameters:SBLAny(NSDictionary *)
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)])thenReturn:mockOperation];

    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        
    } requestId:@"1"];
    
    id requestSerializer;
    id responseSerializer;
    SBLVerify([mockRequestOperationManager setRequestSerializer:SBLCapture(&requestSerializer)]);
    SBLVerify([mockRequestOperationManager setRequestSerializer:SBLCapture(&responseSerializer)]);
    
    XCTAssertTrue([requestSerializer isKindOfClass:[AFJSONRequestSerializer class]]);
    XCTAssertTrue([responseSerializer isKindOfClass:[AFJSONRequestSerializer class]]);
}

- (void)test_whenMakeServiceCallForEndpoint_thenCorrectUrlIsUsed{
    
    NSString *expectedUrlString = @"yolo";
    
    [SBLWhen([endPoint urlString])thenReturn:expectedUrlString];
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *) parameters:SBLAny(NSDictionary *) withTimeout:timeout success:SBLAny(completionBlockType) failure:SBLAny(completionBlockType)])thenReturn:mockOperation];
    
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        
    } requestId:@"1"];
    
    NSString *actualUrlString;
    SBLVerify([mockRequestOperationManager GET:SBLCapture(&actualUrlString)
                                    parameters:SBLAny(NSDictionary *)
                                   withTimeout:timeout
                                       success:SBLAny(completionBlockType)
                                       failure:SBLAny(completionBlockType)]);
    
    XCTAssertEqualObjects(actualUrlString, expectedUrlString);

}

- (void)test_whenMakeServiceCallForEndpoint_thenUseCorrectEndpointParameters{
    NSDictionary *expectedParameters = @{@"key": @1};
    [SBLWhen([endPoint parameters])thenReturn:expectedParameters];
    
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                   parameters:SBLAny(NSDictionary *)
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)])thenReturn:mockOperation];
    
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        
    } requestId:@"1"];
    
    NSDictionary *actualParameters;
    SBLVerify([mockRequestOperationManager GET:SBLAny(NSString *)
                                    parameters:SBLCapture(&actualParameters)
                                   withTimeout:timeout
                                       success:SBLAny(completionBlockType)
                                       failure:SBLAny(completionBlockType)]);
    
    XCTAssertEqualObjects(actualParameters, expectedParameters);
    
}

- (void)test_givenICallMakeServiceCallForEndpoint_whenResponseSuccessful_theResponsePassedToCompletionBlock
{
    NSArray *responseArray = @[@1, @2, @3];
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                   parameters:SBLAny(NSDictionary *)
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)]) thenDoWithInvocation:^(NSInvocation *invocation) {
        void(^block)(AFHTTPRequestOperation *operation, id responseObject) = nil;
        [invocation getArgument:&block atIndex:5];
        [invocation setReturnValue:&mockOperation];
        block(mockOperation, responseArray);
    }];
    
    NSString *signal = @"signal";
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        XCTAssertEqualObjects(response, responseArray);
        ASYSignal(signal);
    } requestId:@"1"];
    
    ASYWaitForSignal(signal, 2);
}

- (void)test_givenICallMakeServiceCallForEndpoint_whenResponseFails_theErrorPassedToCompletionBlock{
    
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                   parameters:SBLAny(NSDictionary *)
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)])thenDoWithInvocation:^(NSInvocation *invocation) {
        void(^block)(AFHTTPRequestOperation *operation, NSError *error) = nil;
        [invocation getArgument:&block atIndex:6];
        [invocation setReturnValue:&mockOperation];
        block(mockOperation, [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil]);
    }];
    
    NSString *signal = @"signal";
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        XCTAssertNotNil(error);
        ASYSignal(signal);
    } requestId:@"1"];
    
    ASYWaitForSignal(signal, 2);
}

- (void)test_whenMakeServiceCallForEndpointIsCalledTwiceForSameRequestId_theGETOperationCalledOnlyOnce {
    [SBLWhen([endPoint parameters])thenReturn:@{@"key":@1}];
    
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                   parameters:@{@"key":@1}
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)])thenReturn:mockOperation];
    
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        
    } requestId:@"1"];
    
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        
    } requestId:@"1"];
    
    
    SBLVerifyTimes(SBLTimes(1), [mockRequestOperationManager GET:SBLAny(NSString *)
                                                      parameters:@{@"key":@1}
                                                     withTimeout:timeout
                                                         success:SBLAny(completionBlockType)
                                                         failure:SBLAny(completionBlockType)]);
    

}

- (void)test_whenMakeServiceCallForEndpointIsCalledTwiceWithSameRequestIdANDReturnsSuccessfullFirstTime_thenGETOperationCalledTwice{
    [SBLWhen([endPoint parameters])thenReturn:@{@"key":@1}];
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                  parameters:@{@"key":@1}
                                 withTimeout:timeout
                                     success:SBLAny(completionBlockType)
                                     failure:SBLAny(completionBlockType)])thenReturn:mockOperation];
    
    NSString *signal = @"signal";
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        ASYSignal(signal);
    } requestId:@"1"];
    void(^responseBlock)(AFHTTPRequestOperation *operation, id responseObject) = nil;
    SBLVerify([mockRequestOperationManager GET:SBLAny(NSString *)
                                     parameters:@{@"key":@1}
                                    withTimeout:timeout
                                        success:SBLCapture(&responseBlock)
                                        failure:SBLAny(completionBlockType)]);
    responseBlock(mockOperation, @[]);
    ASYWaitForSignal(signal, 2);
    
    
    NSString *signal2 = @"signal2";
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        ASYSignal(signal2);
    } requestId:@"1"];
    
    void(^responseBlock2)(AFHTTPRequestOperation *operation, id responseObject);
    SBLVerify([mockRequestOperationManager GET:SBLAny(NSString *)
                                    parameters:@{@"key":@1}
                                   withTimeout:timeout
                                       success:SBLCapture(&responseBlock2)
                                       failure:SBLAny(completionBlockType)]);
    responseBlock2(mockOperation, @[]);
    ASYWaitForSignal(signal2, 2);

}

- (void)test_whenMakeServiceCallForEnpointIsCalledTwiceWithSameRequestIdANDReturnsUnsuccessfullyFirtsTime_thenGETOperationCalledTwice{
    [SBLWhen([endPoint parameters])thenReturn:@{@"key":@1}];
    
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                   parameters:@{@"key":@1}
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)])thenReturn:mockOperation];
    NSString *signal = @"signal";
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        ASYSignal(signal);
    } requestId:@"1"];
    NSError *error;
    void(^block)(AFHTTPRequestOperation *operation, NSError *error);
    SBLVerify([mockRequestOperationManager GET:SBLAny(NSString *)
                                    parameters:@{@"key":@1}
                                   withTimeout:timeout
                                       success:SBLAny(completionBlockType)
                                       failure:SBLCapture(&block)]);
    
    block(nil, error);
    
    
    NSString *signal2 = @"signal2";
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        ASYSignal(signal2);
    } requestId:@"1"];
    
    void(^responseBlock)(AFHTTPRequestOperation *operation, id responseObject);
    SBLVerify([mockRequestOperationManager GET:SBLAny(NSString *)
                                    parameters:@{@"key":@1}
                                   withTimeout:timeout
                                       success:SBLCapture(&responseBlock)
                                       failure:SBLAny(completionBlockType)]);
    responseBlock(mockOperation, nil);
    ASYWaitForSignal(signal2, 2);
}

- (void)test_whenMakeServiceCallForTwoEndpointsWithSameRequestIdsButDifferentOperations_thenGETOperationCalledTwice
{
    
    [SBLWhen([endPoint urlString])thenReturn:@"1"];

    
    AFHTTPRequestOperation *mockOperation2 = SBLMock([AFHTTPRequestOperation class]);
    
    [SBLWhen([mockRequestOperationManager GET:@"1"
                                   parameters:SBLAny(NSDictionary *)
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)])thenReturn:mockOperation];
    
    [SBLWhen([mockRequestOperationManager GET:SBLAny(NSString *)
                                   parameters:SBLAny(NSDictionary *)
                                  withTimeout:timeout
                                      success:SBLAny(completionBlockType)
                                      failure:SBLAny(completionBlockType)])thenReturn:mockOperation2];
    
    NSString *signal = @"signal";
    void(^responseBlock1)(AFHTTPRequestOperation *operation, id responseObject);
    
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        ASYSignal(signal);
    } requestId:@"1"];
    
    SBLVerify([mockRequestOperationManager GET:@"1" parameters:SBLAny(NSDictionary *) withTimeout:timeout success:SBLCapture(&responseBlock1) failure:SBLAny(completionBlockType)]);
    
    responseBlock1(mockOperation, @[]);
    ASYWaitForSignal(signal, 2);
    
    NSString *signal2 = @"signal2";
    
    void(^responseBlock2)(AFHTTPRequestOperation *operation, id responseObject);
    [testObject makeServiceCallForEndoint:endPoint responseBlock:^(id response, NSError *error) {
        ASYSignal(signal2);
    } requestId:@"1"];
    
    SBLVerify([mockRequestOperationManager GET:SBLAny(NSString *) parameters:SBLAny(NSDictionary *) withTimeout:timeout success:SBLCapture(&responseBlock2) failure:SBLAny(completionBlockType)]);
    
    responseBlock2(mockOperation2, @[]);
    ASYWaitForSignal(signal2, timeout);
}
@end
