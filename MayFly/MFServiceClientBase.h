#import "MFEndpoint.h"
#import "AFHTTPRequestOperationManager.h"
#import <Foundation/Foundation.h>

typedef void (^MFResponsBlock)(id response, NSError *error);

@interface MFServiceClientBase : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager;

- (void)makeServiceCallForEndoint:(MFEndpoint *)endpoint
                    responseBlock:(MFResponsBlock)responseBlock
                        requestId:(NSString *)requestId;

- (NSString *)convertStringProperty:(NSString *)property;
@end