#import "MFServiceClientBase.h"

@protocol MFMultipleAlbumsServiceClientDelegate <NSObject>

- (void)downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:(NSArray *)serializedResponse fromClick:(BOOL)fromClick;
- (void)downloadFailedForMultipleAlbumsServiceClient;

@end

@interface MFMultipleAlbumsServiceClient : MFServiceClientBase

@property (nonatomic, weak, readwrite) id<MFMultipleAlbumsServiceClientDelegate> delegate;
- (void)downloadMultipleAlbumsWithIds:(NSArray *)albumIds fromClick:(BOOL)fromClick;

@end