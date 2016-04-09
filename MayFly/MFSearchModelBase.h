#import "MFServiceClientFactory.h"
#import "MFMemoryStack.h"
#import "MFSearchModelInterface.h"
#import "MFPersistenceFactory.h"
#import "MFPersistencePonsoProvider.h"
#import "MFSearchResult.h"

@interface MFSearchModelBase : NSObject <MFSearchModelInterface>

@property (nonatomic, readonly) MFServiceClientFactory *serviceClientFactory;
@property (nonatomic, readonly) id<MFPersistenceFactory> persistenceFactory;
@property (nonatomic, readonly) MFPersistencePonsoProvider *persistencePonsoProvider;
@property (nonatomic, readonly) MFAlbumTracksServiceClient *albumTracksServiceClient;
@property (nonatomic, readonly) MFArtistAlbumsServiceClient *artistAlbumsServiceClient;
@property (nonatomic, readonly) MFRelatedArtistsServiceClient *relatedArtistsServiceClient;
@property (nonatomic, readonly) MFArtistServiceClient *artistServiceClient;

@property (nonatomic, readonly) MFMultipleAlbumsServiceClient *multipleAlbumsServiceClient;
@property (nonatomic, readonly) MFMultipleArtistsServiceClient *multipleArtistsServiceClient;
@property (nonatomic, strong) NSArray *serializedData;
@property (nonatomic, strong) MFMemoryStack *memoryStack;
@property (nonatomic, readwrite) NSInteger scopeIndex;


- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithServiceClientFactory:(MFServiceClientFactory *)serviceClientFactory
                          persistenceFactory:(id<MFPersistenceFactory>)persistenceFactory
                    persistencePonsoProvider:(MFPersistencePonsoProvider *)persistencePonsoProvider
                                 memoryStack:(MFMemoryStack *)memoryStack;

- (NSArray *)transformDataToSearchEntities:(NSArray *)data;

- (BOOL)entityIsFavorite:(id)entity;

@end