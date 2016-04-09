#import "AFHTTPRequestOperationManager.h"
#import "MFServiceClientFactory.h"

@interface MFServiceClientFactory()

@property (nonatomic, readonly) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation MFServiceClientFactory

- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
{
    if (self = [super init]) {
        _requestOperationManager = requestOperationManager;
    }
    return self;
}

- (MFAlbumTracksServiceClient *)albumTracksServiceClient
{
    return [[MFAlbumTracksServiceClient alloc] initWithRequestOperationManager:self.requestOperationManager];
}

- (MFArtistAlbumsServiceClient *)artistAlbumsServiceClient
{
    return [[MFArtistAlbumsServiceClient alloc] initWithRequestOperationManager:self.requestOperationManager];
}

- (MFArtistServiceClient *)artistServiceClient
{
    return [[MFArtistServiceClient alloc] initWithRequestOperationManager:self.requestOperationManager];
}

- (MFQueryByNameServiceClient *)queryByNameServiceClient
{
    return [[MFQueryByNameServiceClient alloc] initWithRequestOperationManager:self.requestOperationManager];
}

- (MFRelatedArtistsServiceClient *)relatedArtistsServiceClient
{
    return [[MFRelatedArtistsServiceClient alloc] initWithRequestOperationManager:self.requestOperationManager];
}

- (MFMultipleAlbumsServiceClient *)multipleAlbumsServiceClient
{
    return [[MFMultipleAlbumsServiceClient alloc] initWithRequestOperationManager:self.requestOperationManager];
}

- (MFMultipleArtistsServiceClient *)multipleArtistsServiceClient
{
    return [[MFMultipleArtistsServiceClient alloc] initWithRequestOperationManager:self.requestOperationManager];
}
@end