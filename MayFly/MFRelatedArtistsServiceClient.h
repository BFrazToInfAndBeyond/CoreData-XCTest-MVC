#import "MFServiceClientBase.h"

@protocol MFRelatedArtistsServiceClientDelegate <NSObject>

- (void)downloadSucceedForRelatedArtistsServiceClientWithSerializedResponse:(NSArray *)serializedResponse;
- (void)downloadFailedForRelatedArtistsServiceClient;

@end

@interface MFRelatedArtistsServiceClient : MFServiceClientBase

@property (nonatomic, weak, readwrite) id<MFRelatedArtistsServiceClientDelegate> delegate;
- (void)downloadRelatedArtistsWithId:(NSString *)artistId;

@end