#import "MFSpotifySearchModel.h"

@interface MFSpotifySearchModel() <ESCObservableInternal, MFQueryByNameServiceClientDelegate>

@property (nonatomic, strong) MFQueryByNameServiceClient *queryByNameServiceClient;
@end

@implementation MFSpotifySearchModel
@synthesize scopeIndex = _scopeIndex;

- (instancetype)initWithServiceClientFactory:(MFServiceClientFactory *)serviceClientFactory
                          persistenceFactory:(id<MFPersistenceFactory>)persistenceFactory persistencePonsoProvider:(MFPersistencePonsoProvider *)persistencePonsoProvider memoryStack:(MFMemoryStack *)memoryStack{
    if (self = [super initWithServiceClientFactory:serviceClientFactory persistenceFactory:persistenceFactory persistencePonsoProvider:persistencePonsoProvider memoryStack:memoryStack]) {
        _queryByNameServiceClient = [self.serviceClientFactory queryByNameServiceClient];
        _queryByNameServiceClient.delegate = self;
        
    }
    return self;
}

- (void)downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:(NSArray *)serializedResponse fromClick:(BOOL)fromClick
{

    
    if (fromClick) {
        [self setScopeIndex:1];
        [self.memoryStack pushMemoryStack:serializedResponse];
    } else {
        [self.memoryStack clearAndPushMemoryStack:serializedResponse];
    }
    
    [self setSerializedData:serializedResponse];
    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
}

- (void)downloadFailedForMultipleAlbumsServiceClient
{
    
}

- (void)downloadSucceededForQueryWithSerializedResponse:(NSArray *)serializedResponse
{
    if (self.scopeIndex == MFAlbumScope) {
        NSMutableSet *albumIds = [NSMutableSet set];
        for (MFAlbumPonso *album in serializedResponse) {
            [albumIds addObject:album.id];
        }
        [self.multipleAlbumsServiceClient downloadMultipleAlbumsWithIds:[[albumIds copy] allObjects] fromClick:NO];
    }else {
        [self setSerializedData:serializedResponse];
        [self.memoryStack clearAndPushMemoryStack:serializedResponse];
        [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
    }
}

- (void)downloadFailedForQuery:(NSString *)searchName
{
    [self.memoryStack clearMemoryStack];
    self.serializedData = nil;
    //TODO: transform
    [self.escNotifier searchSuccessfulWithResults:self.serializedData];
}

- (void)updateEntities
{
    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
}

- (void)queryWithSearchText:(NSString *)searchText
{
    if ([self scopeIndex] == MFArtistScope) {
        [self.queryByNameServiceClient downloadEntityWithQueryByName:searchText type:MFArtistScope];
    } else if (self.scopeIndex == MFAlbumScope) {
        [self.queryByNameServiceClient downloadEntityWithQueryByName:searchText type:MFAlbumScope];
    } else if (self.scopeIndex == MFTrackScope) {
        [self.queryByNameServiceClient downloadEntityWithQueryByName:searchText type:MFTrackScope];
    }
}

- (NSString *)searchResultsTitle{
    return @"Search Spotify";
}

@end