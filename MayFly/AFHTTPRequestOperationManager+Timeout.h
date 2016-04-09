#import <AFNetworking/AFHTTPRequestOperationManager.h>
@interface AFHTTPRequestOperationManager (Timeout)

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                    withTimeout:(NSTimeInterval)timeoutInterval
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end