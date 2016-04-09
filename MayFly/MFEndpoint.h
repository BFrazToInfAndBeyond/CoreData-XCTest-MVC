#import <Foundation/Foundation.h>

@interface MFEndpoint : NSObject

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, readonly) NSTimeInterval defaultTimeout;

- (instancetype)initWithURLString: (NSString *)urlString
                    andParameters:(NSDictionary *)parameters
                   defaultTimeout:(NSTimeInterval)defaultTimeout;

+ (MFEndpoint *)endpointForArtistId:(NSString *)artistId;
+ (MFEndpoint *)endpointForArtistsAlbums:(NSString *)artistId;
+ (MFEndpoint *)endpointForAlbumTracks:(NSString *)albumId;
+ (MFEndpoint *)endpointForQueryingSpotifyByName:(NSString *)name type:(MFEntityScope)type;
+ (MFEndpoint *)endpointForRelatedArtists:(NSString *)artistId;
+ (MFEndpoint *)endpointForAlbumsWithAlbumIds:(NSArray *)albumIds;
+ (MFEndpoint *)endpointforArtistsWithAritstIds:(NSArray *)artistIds;
@end