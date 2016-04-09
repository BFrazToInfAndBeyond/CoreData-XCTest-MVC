#import "MFServiceClientBase.h"

@protocol MFAlbumTrackServiceClientDelegate <NSObject>

- (void)downloadSucceededForAlbumTracksWithSerializedResponse:(NSArray *)serializedResponse isFavorite:(BOOL)isFavorite resultId:(NSString *)resultId;
- (void)downloadFailedForAlbumTracks;

@end

@interface MFAlbumTracksServiceClient : MFServiceClientBase

@property (nonatomic, weak, readwrite) id<MFAlbumTrackServiceClientDelegate> delegate;

- (void)downloadTracksForAlbumId:(NSString *)albumId images:(NSSet *)images albumName:(NSString *)albumName isFavorite:(BOOL)isFavorite;


@end