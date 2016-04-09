#import "MFServiceClientBase.h"

@protocol MFQueryByNameServiceClientDelegate <NSObject>

- (void)downloadSucceededForQueryWithSerializedResponse:(NSArray *)serializedResponse;
- (void)downloadFailedForQuery:(NSString *)searchName;

@end

@interface MFQueryByNameServiceClient : MFServiceClientBase

@property (nonatomic, weak, readwrite) id<MFQueryByNameServiceClientDelegate> delegate;
- (void)downloadEntityWithQueryByName:(NSString *)name type:(MFEntityScope)type;

@end