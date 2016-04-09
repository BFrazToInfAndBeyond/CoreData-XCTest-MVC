#import "MFServiceClientBase.h"

@protocol MFArtistServiceClientDelegate <NSObject>

- (void)downloadSucceedForArtistServiceClientWithSerializedResponse:(NSArray *)serializedResponse;
- (void)downloadFailedForArtistServiceClient;

@end

@interface MFArtistServiceClient : MFServiceClientBase

@property (nonatomic, weak, readwrite) id<MFArtistServiceClientDelegate> delegate;
- (void)downloadArtistWithId:(NSString *)artistId;

@end