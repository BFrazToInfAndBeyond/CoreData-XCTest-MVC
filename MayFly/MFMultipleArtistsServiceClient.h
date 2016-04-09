#import "MFServiceCLientBase.h"


@protocol MFMultipleArtistsServiceClientDelegate <NSObject>

- (void)downloadSucceededForMultipleArtistsServiceClientWithSerializedResponse:(NSArray *)serializedResponse;
- (void)downloadFailedForMultipleArtistsServiceClient;

@end

@interface MFMultipleArtistsServiceClient : MFServiceClientBase

@property (nonatomic, weak, readwrite) id<MFMultipleArtistsServiceClientDelegate> delegate;
- (void)downloadMultipleArtistsWithArtistIds:(NSArray *)artistIds;

@end