#import "MFSearchModelBase.h"
#import "MFArtistPonso.h"
#import "MFAlbumPonso.h"
#import "MFTrackPonso.h"
#import "MFImagePonso.h"

@interface MFSearchModelBase() <ESCObservableInternal, MFArtistAlbumsServiceClientDelegate, MFAlbumTrackServiceClientDelegate, MFRelatedArtistsServiceClientDelegate, MFArtistServiceClientDelegate, MFMultipleAlbumsServiceClientDelegate, MFMultipleArtistsServiceClientDelegate>


@end

@implementation MFSearchModelBase
@synthesize scopeIndex = _scopeIndex;


- (instancetype)initWithServiceClientFactory:(MFServiceClientFactory *)serviceClientFactory persistenceFactory:(id<MFPersistenceFactory>)persistenceFactory persistencePonsoProvider:(MFPersistencePonsoProvider *)persistencePonsoProvider memoryStack:(MFMemoryStack *)memoryStack
{
    if (self = [super init]) {
        [self escRegisterObserverProtocol:@protocol(MFSearchModelObserver)];
        _serviceClientFactory = serviceClientFactory;
        
        _scopeIndex = 0;
        _persistencePonsoProvider = persistencePonsoProvider;
        _persistenceFactory = persistenceFactory;
        
        _artistAlbumsServiceClient = [self.serviceClientFactory artistAlbumsServiceClient];
        _artistAlbumsServiceClient.delegate = self;
        
        _albumTracksServiceClient = [self.serviceClientFactory albumTracksServiceClient];
        _albumTracksServiceClient.delegate = self;
        
        _relatedArtistsServiceClient = [self.serviceClientFactory relatedArtistsServiceClient];
        _relatedArtistsServiceClient.delegate = self;
        
        _artistServiceClient = [self.serviceClientFactory artistServiceClient];
        _artistServiceClient.delegate = self;
        
        _multipleAlbumsServiceClient = [self.serviceClientFactory multipleAlbumsServiceClient];
        _multipleAlbumsServiceClient.delegate = self;
        
        _memoryStack = memoryStack;
        
        _multipleArtistsServiceClient = [self.serviceClientFactory multipleArtistsServiceClient];
        _multipleArtistsServiceClient.delegate = self;
        
    }
    return self;
}

- (void)backOne
{
    NSArray *newData = [self.memoryStack popMemoryStack];
    if (newData != nil) {
        [self setSerializedData:newData];
        if ([self.serializedData[0] isKindOfClass:[MFArtistPonso class]]) {
            [self setScopeIndex:0];
        } else if ([self.serializedData[0] isKindOfClass:[MFAlbumPonso class]]){
            [self setScopeIndex:1];
        } else if ([self.serializedData[0] isKindOfClass:[MFTrackPonso class]]){
            [self setScopeIndex:2];
        }
        [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
    }
}

- (NSInteger)scopeIndex{
    return _scopeIndex;
}

- (NSArray *)allResults
{
    return nil;
}

- (void)downloadSucceededForMultipleArtistsServiceClientWithSerializedResponse:(NSArray *)serializedResponse
{
    for (MFArtistPonso *artistPonso in serializedResponse) {
        artistPonso.isFavorite = @1;
        [self.persistencePonsoProvider savePonso:artistPonso];
    }
    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
}

- (void)downloadFailedForMultipleArtistsServiceClient{
    
}

- (void)downloadSucceedForArtistServiceClientWithSerializedResponse:(NSArray *)serializedResponse { 
    MFArtistPonso *artistPonso = serializedResponse[0];
    artistPonso.isFavorite = @1;
    [self.persistencePonsoProvider savePonso:artistPonso];
    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
}

- (void)downloadFailedForArtistServiceClient
{
    
}


- (void)downloadSucceedForRelatedArtistsServiceClientWithSerializedResponse:(NSArray *)serializedResponse
{
    [self setSerializedData:serializedResponse];
    //push
    [self.memoryStack pushMemoryStack:serializedResponse];
    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
}

- (void)downloadFailedForRelatedArtistsServiceClient {
    
}

- (void)downloadSucceededForAlbumTracksWithSerializedResponse:(NSArray *)serializedResponse isFavorite:(BOOL)isFavorite resultId:(NSString *)resultId
{
    
    if (isFavorite) {
        
        for (int i = 0; i < self.serializedData.count; i++) {
            if ([[self.serializedData[i] id] isEqualToString:resultId]) {
                //fav, turn to set and set it as tracks
                MFAlbumPonso *albumChosen = self.serializedData[i];
                albumChosen.isFavorite = @1;
                albumChosen.tracks = [NSSet setWithArray:serializedResponse];
                [self.persistencePonsoProvider savePonso:albumChosen];
                break;
            }
        }
    } else {
        [self setSerializedData:serializedResponse];
        //push
        [self.memoryStack pushMemoryStack:serializedResponse];
        [self setScopeIndex:2];
    }
    [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
}

- (void)downloadFailedForAlbumTracks
{
    
}

- (void)downloadSucceedForMultipleAlbumsServiceClientWithSerializedResponse:(NSArray *)serializedResponse fromClick:(BOOL)fromClick
{
    if (fromClick) {
        [self setSerializedData:serializedResponse];
        [self setScopeIndex:1];
        //push
        [self.memoryStack pushMemoryStack:serializedResponse];
        [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
    }
}

- (void)downloadFailedForMultipleAlbumsServiceClient
{
    
}

- (void)downloadSucceededForArtistAlbumsWithSerializedResponse:(NSArray *)serializedResponse
{
    NSMutableSet *albumIds = [NSMutableSet set];
    for (MFAlbumPonso *album in serializedResponse) {
        [albumIds addObject:album.id];
    }
    [self.multipleAlbumsServiceClient downloadMultipleAlbumsWithIds:[[albumIds copy] allObjects] fromClick:YES];
}

- (void)downloadFailedForArtistAlbums
{
    
}

- (void)setSerializedData:(NSArray *)serializedData {
    _serializedData = serializedData;
}

- (void)selectedEntityWithResult:(MFSearchResult *)result
{
    if (self.scopeIndex == MFArtistScope) {
        [self.artistAlbumsServiceClient downloadAlbumsForArtistId:result.resultId];
    } else if (self.scopeIndex == MFAlbumScope) {
        NSMutableSet *images = [NSMutableSet set];
        for (int i = 0; i < self.serializedData.count; i++) {
            if ([[self.serializedData[i] id] isEqualToString:result.resultId]) {
                [images addObjectsFromArray:[self.serializedData[i] images]];
            }
        }
        [self.albumTracksServiceClient downloadTracksForAlbumId:result.resultId images:[images copy] albumName:result.name isFavorite:NO];
    }
}

- (void)updateScopeIndex:(NSInteger)scopeIndex
{
    self.scopeIndex = scopeIndex;
}

- (void)queryWithSearchText:(NSString *)searchText
{
    // no action needed
}

- (void)selectedViewRelatedArtistsWithArtistId:(NSString *)artistId
{
    [self.relatedArtistsServiceClient downloadRelatedArtistsWithId:artistId];
}

- (void)toggledFavoriteWithResultId:(NSString *)resultId
{
    if (self.scopeIndex == MFAlbumScope) {
        
        if ([[self.persistenceFactory albumPersistence] albumWithAlbumId:resultId] != nil) {
            [[self.persistenceFactory albumPersistence] favoriteToggledWithAlbumId:resultId];
            [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
        } else {
            //download
            MFAlbumPonso *albumPonso;
            for (int i = 0; i < self.serializedData.count; i++) {
                if ([[self.serializedData[i] id] isEqualToString:resultId]) {
                    albumPonso = self.serializedData[i];
                }
            }
            [self.albumTracksServiceClient downloadTracksForAlbumId:resultId images:albumPonso.images albumName:albumPonso.name isFavorite:YES];
        }
        
    } else if (self.scopeIndex == MFTrackScope) {
        if ([[self.persistenceFactory trackPersistence] trackWithTrackId:resultId] != nil) {
            [[self.persistenceFactory trackPersistence] favoriteToggledWithTrack:resultId];
        } else {
            MFTrackPonso *trackPonso;
            for (int i = 0; i < self.serializedData.count; i++) {
                if ([[self.serializedData[i] id] isEqualToString:resultId]) {
                    trackPonso = self.serializedData[i];
                    break;
                }
            }
            trackPonso.isFavorite = @1;
            [self.persistencePonsoProvider savePonso:trackPonso];
            
        }
        [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
    } else if (self.scopeIndex == MFArtistScope) {
        if ([[self.persistenceFactory artistPersistence] artistWithArtistId:resultId]) {
            [[self.persistenceFactory artistPersistence] favoriteToggleWithArtistId:resultId];
            [self.escNotifier searchSuccessfulWithResults:[self transformDataToSearchEntities:self.serializedData]];
        } else {
            [self.artistServiceClient downloadArtistWithId:resultId];
        }
    }

}

- (NSString *)searchResultsTitle
{
    return nil;
}

- (NSArray *)scopeButtonTitles
{
    return @[@"Artists", @"Albums", @"Tracks"];
}


// TODO: When favoriting Albums AND tracks, this is VERY costly! For every element it toggles as favorite, it events to presenter to update UI.
- (void)selectedFavoriteAllEntities
{
    if (self.scopeIndex == MFArtistScope) {
        NSMutableSet *artistIds = [NSMutableSet set];
        for (MFArtistPonso *artist in self.serializedData ) {
            if (![self entityIsFavorite:artist]) {
                if ([[self.persistenceFactory artistPersistence] artistWithArtistId:[artist id]]) {
                    [[self.persistenceFactory artistPersistence] favoriteToggleWithArtistId:[artist id]];
                } else {
                    [artistIds addObject:[artist id]];
                }
            }
        }
        NSArray *ids = [NSArray arrayWithArray:[ [artistIds copy] allObjects]];
        if (ids.count) {
            [self.multipleArtistsServiceClient downloadMultipleArtistsWithArtistIds:ids];
        }

    } else{
        for (int i = 0; i < self.serializedData.count; i++) {
            if (![self entityIsFavorite:self.serializedData[i]]) {
                [self toggledFavoriteWithResultId:[(MFArtistPonso *)self.serializedData[i] id]];
            }
        }
    }
}

- (NSArray *)transformDataToSearchEntities:(NSArray *)data
{
    if (data.count == 0) {
        return @[];
    }
    NSMutableArray *searchResults = [NSMutableArray array];
    MFSearchResult *searchResult;
    NSSortDescriptor *alphabeticalOrder = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *widthOfImage = [NSSortDescriptor sortDescriptorWithKey:@"width" ascending:YES];
    NSSortDescriptor *heightOfImage = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    BOOL isFavorite;
    NSString *name;
    UIImage *image;
    NSString *resultId;
    NSString *secondaryName;
    for (int i = 0; i < data.count; i++) {
        name = [data[i] name];
        NSString *imageUrl = [(MFImagePonso *)[[[[(MFArtistPonso *)data[i] images] allObjects] sortedArrayUsingDescriptors:@[widthOfImage, heightOfImage]] firstObject] url];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        resultId = [data[i] id];
        isFavorite = [self entityIsFavorite:data[i]];
        if ([data[0] isKindOfClass:[MFArtistPonso class]]) {
            secondaryName = [data[i] genres];
        }else if ([data[0] isKindOfClass:[MFAlbumPonso class]]) {
            
            NSArray * artists = [[[data[i] artists] allObjects] sortedArrayUsingDescriptors:@[alphabeticalOrder]];
            NSString *artistsToPrint = [[artists firstObject] name];
            for (int i = 1; i < artists.count; i ++) {
                artistsToPrint = [artistsToPrint stringByAppendingString:[NSString stringWithFormat:@", %@", [artists[i] name]]];
            }
            int count = [[(MFAlbumPonso *)data[i] tracks] count];
            secondaryName = artistsToPrint;
            if ([(MFAlbumPonso *)data[i] numberOfTracks] > 0) {
                secondaryName = [secondaryName stringByAppendingString:[NSString stringWithFormat:@", %lu", (unsigned long)[(MFAlbumPonso *)data[i] numberOfTracks]]];
            } else {
                if(count > 0){
                    secondaryName = [secondaryName stringByAppendingString:[NSString stringWithFormat:@", %@", @(count)]];
                }
            }
        } else if ([data[0] isKindOfClass:[MFTrackPonso class]]) {
            secondaryName = [NSString stringWithFormat:@"%@, %@", [[[[[data[i] artists] allObjects] sortedArrayUsingDescriptors:@[alphabeticalOrder]] firstObject] name], [data[i] albumName]];
        }
        searchResult = [[MFSearchResult alloc] initWithName:name secondaryName:secondaryName image:image resultId:resultId isFavorite:isFavorite];
        [searchResults addObject:searchResult];
    }
    NSArray *sortedArray = [[searchResults copy] sortedArrayUsingDescriptors:@[alphabeticalOrder]];
    return sortedArray;
}

- (BOOL)entityIsFavorite:(id)entity
{
    if ([entity isKindOfClass:[MFArtistPonso class]]) {
        return [[self.persistenceFactory artistPersistence] isFavoriteWithArtistId:[(MFArtistPonso *)entity id]];
    } else if ([entity isKindOfClass:[MFAlbumPonso class]]) {
        return [[self.persistenceFactory albumPersistence] isFavoriteWithAlbumId:[(MFAlbumPonso *)entity id]];
    } else if ([entity isKindOfClass:[MFTrackPonso class]]) {
        return [[self.persistenceFactory trackPersistence] isFavoriteWithTrackId:[(MFTrackPonso *)entity id]];
    }
    return NO;
}

@end