#import "AFHTTPRequestOperationManager.h"
#import "MFArtistServiceClient.h"
#import "MFArtistAlbumsServiceClient.h"
#import "MFAlbumTracksServiceClient.h"
#import "MFQueryByNameServiceClient.h"
#import "MFRelatedArtistsServiceClient.h"
#import "MFMultipleAlbumsServiceClient.h"
#import "MFMultipleArtistsServiceClient.h"


@interface MFServiceClientFactory : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager;

- (MFArtistServiceClient *)artistServiceClient;
- (MFArtistAlbumsServiceClient *)artistAlbumsServiceClient;
- (MFAlbumTracksServiceClient *)albumTracksServiceClient;
- (MFQueryByNameServiceClient *)queryByNameServiceClient;
- (MFRelatedArtistsServiceClient *)relatedArtistsServiceClient;
- (MFMultipleAlbumsServiceClient *)multipleAlbumsServiceClient;
- (MFMultipleArtistsServiceClient *)multipleArtistsServiceClient;
@end
