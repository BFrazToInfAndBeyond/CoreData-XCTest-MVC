#import "MFServiceClientBase.h"

@protocol MFArtistAlbumsServiceClientDelegate <NSObject>

- (void)downloadSucceededForArtistAlbumsWithSerializedResponse:(NSArray *)serializedResponse;
- (void)downloadFailedForArtistAlbums;

@end


@interface MFArtistAlbumsServiceClient : MFServiceClientBase

@property (nonatomic, weak, readwrite) id<MFArtistAlbumsServiceClientDelegate> delegate;

- (void)downloadAlbumsForArtistId:(NSString *)artistId;


@end