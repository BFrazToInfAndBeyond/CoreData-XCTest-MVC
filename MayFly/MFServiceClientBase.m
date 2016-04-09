#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <Foundation/Foundation.h>
#import "MFServiceClientBase.h"
#import "AFHTTPRequestOperationManager+Timeout.h"

@interface MFServiceClientBase()

@property (nonatomic, strong, readonly) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSMutableSet *operationsInProgress;

@end


@implementation MFServiceClientBase

- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager {
    if(self = [super init]){
        _manager = requestOperationManager;
        _operationsInProgress = [[NSMutableSet alloc] init];
        
    }
    return self;
}

- (void)makeServiceCallForEndoint:(MFEndpoint *)endpoint responseBlock:(MFResponsBlock)responseBlock requestId:(NSString *)requestId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"requestId == %@", requestId];
    NSSet * filteredOperations = [self.operationsInProgress filteredSetUsingPredicate:predicate];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if (filteredOperations.count == 0) {
        AFHTTPRequestOperation *requestOperation = [self.manager GET:endpoint.urlString
                                                          parameters:endpoint.parameters
                                                         withTimeout:endpoint.defaultTimeout
                                                             success:^(AFHTTPRequestOperation *operation, id responseObject){
                                                                 responseBlock(responseObject, nil);
                                                                 
                                                                 [self removeOperationInProgressForRequestId:requestId];
                                                             }
                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                 responseBlock(nil,error);
                                                                 [self removeOperationInProgressForRequestId:requestId];
                                                                 
                                                             }];

        [self.operationsInProgress addObject:@{@"requestId": requestId, @"operation":requestOperation}];
    }
    
    
}

- (void)removeOperationInProgressForRequestId:(NSString *)requestId{
    //TODO: make test for this
    for(NSDictionary *element in [self.operationsInProgress copy]){
        if([[element objectForKey:@"requestId"] isEqualToString:requestId]){
            [self.operationsInProgress removeObject:element];
        }
    }
}

- (NSString *)convertStringProperty:(NSString *)property
{
    if (property == (id)[NSNull null] || property.length == 0) {
        return @"";
    }
    return property;
}

@end