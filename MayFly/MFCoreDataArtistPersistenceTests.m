#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataArtistPersistence.h"
#import "MFArtistEntity.h"
#import "MFCoreDataSqlitePSCProvider.h"
#import "MFCoreDataInMemoryPSCProvider.h"
#import "MFArtistPonso.h"
#import "MFImagePonso.h"
#import "MFImageEntity.h"
#import "MFTestUtilities.h"

@interface MFCoreDataArtistPersistenceTests : XCTestCase
{
    MFCoreDataArtistPersistence *testObject;
    id<MFCoreDataMOCProvider> mocProvider;
    NSURL *dataStoreUrl;
    
}
@end

@implementation MFCoreDataArtistPersistenceTests

- (void)setUp {
    [super setUp];
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *dataStoreDirUrl = [NSURL fileURLWithPath:[MFTestUtilityProtectedTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]]];
    [fileManager createDirectoryAtURL:dataStoreDirUrl withIntermediateDirectories:YES attributes:nil error:&error];
    dataStoreUrl = [dataStoreDirUrl URLByAppendingPathComponent:@"database.sqlite"];
    
    [fileManager createFileAtPath:dataStoreDirUrl.path contents:nil attributes:nil];
    
    MFCoreDataSqlitePSCProvider *pscProvider = [[MFCoreDataSqlitePSCProvider alloc]initWithUserStoreURL:dataStoreUrl];
    mocProvider = [[MFCoreDataMOCProvider alloc] initWithStoreProvider:pscProvider];
    
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}


#pragma mark - Helpers

- (MFArtistEntity *)fetchArtist:(NSString *)artistId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:mocProvider.mainContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", artistId];
    MFArtistEntity *artist = [[mocProvider.mainContext executeFetchRequest:fetchRequest error:nil] firstObject];
    return  artist;
}

- (NSArray *)fetchArtistsWithId:(NSString *)artistId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:mocProvider.mainContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", artistId];
    return [mocProvider.mainContext executeFetchRequest:fetchRequest error:nil];
}

- (MFImageEntity *)newImageEntityWithImagePonso:(MFImagePonso *)imagePonso
{
    MFImageEntity *imageEntity = (MFImageEntity *)imagePonso;
    imageEntity.height = imagePonso.height;
    imageEntity.width = imagePonso.width;
    imageEntity.artistId = imagePonso.artistId;
    
    return imageEntity;
}

- (void)addNewEntityWithArtistId:(NSString *)artistId
                            artistName:(NSString *)artistName
                      popularity:(NSNumber *)popularity
                      isFavorite:(NSNumber *)isFavorite
                          images:(NSSet *)images{
    NSManagedObjectContext *mainContext = mocProvider.mainContext;
    MFArtistEntity *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:mainContext];


    
    for (MFImagePonso *imagePonso in images) {
        MFImageEntity *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:mainContext];
        image.albumId = imagePonso.albumId;
        image.artistId = imagePonso.artistId;
        image.height = imagePonso.height;
        image.width = imagePonso.width;
        image.url = imagePonso.url;
        [artist addImagesObject:image];
    }
    
    artist.id = artistId;
    artist.name = artistName;
    artist.popularity = popularity;
    artist.isFavorite = isFavorite;
}

- (void)populateStoreWithTestData{
    MFImagePonso *image1 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"artistId1" height:@40 width:@40 url:@"url1"];
    MFImagePonso *image2 = [[MFImagePonso alloc] initWithAlbumId:@"albumId2" artistId:@"artistId1" height:@40 width:@40 url:@"url2"];
    NSSet *images = [NSSet setWithObjects:image1, image2, nil];
    [self addNewEntityWithArtistId:@"artistId1" artistName:@"artistName1" popularity:@1 isFavorite:@1 images:images];
    
    [self addNewEntityWithArtistId:@"artistId2" artistName:@"artistName2" popularity:@2 isFavorite:@0 images:nil];

    [self addNewEntityWithArtistId:@"artistId3" artistName:@"artistName3" popularity:@3 isFavorite:@1 images:nil];
    
    [self addNewEntityWithArtistId:@"artistId4" artistName:@"artistName4" popularity:@4 isFavorite:@0 images:nil];
    
    [self addNewEntityWithArtistId:@"artistId5" artistName:@"searchText5" popularity:@5 isFavorite:@1 images:nil];
    
    [self addNewEntityWithArtistId:@"artistId6" artistName:@"searchText6" popularity:@6 isFavorite:@0 images:nil];
    
    [self addNewEntityWithArtistId:@"artistId7" artistName:@"searchText7" popularity:@7 isFavorite:@1 images:nil];
    
    [self addNewEntityWithArtistId:@"artistId8" artistName:@"searchText8" popularity:@8 isFavorite:@0 images:nil];

    
    NSError *error;
    [mocProvider.mainContext save:&error];
}


- (void)test_whenArtistIsFavoriteInDatabaseANDPersistenceRequestedItsFavoriteStatus_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    BOOL actual = [testObject isFavoriteWithArtistId:@"artistId1"];
    
    XCTAssertTrue(actual);
}

- (void)test_whenArtistIsNotFavoriteInDatabaseANDPersistenceRequestedItsFavoriteStatus_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    XCTAssertFalse([testObject isFavoriteWithArtistId:@"artistId2"]);
}

- (void)test_whenArtistIsNOTinDatabaseANDPersistenceRequestedForArtistsFavoriteStatus_thenReturnAsExpected
{
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    XCTAssertFalse([testObject isFavoriteWithArtistId:@"nonExistantID"]);
}

- (void)test_whenSearchFavoriteArtistsWithTextEqualToEmptyString_thenArtistsAreReturnedSortedProperly {
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchArtistsWithSearchText:@"" searchScope:MFSearchScopeFavorite];
    
    XCTAssertEqualObjects(@(actualResults.count), @4);
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[0]) name], @"artistName1");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[1]) name], @"artistName3");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[2]) name], @"searchText5");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[3]) name], @"searchText7");
}

- (void)test_whenSearchFavoriteArtistsWithImages_thenFetchArtistReturnsAsExpected
{
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSArray *actualResults = [testObject fetchArtistsWithSearchText:@"artistName1" searchScope:MFSearchScopeAll];
    XCTAssertEqualObjects(@(actualResults.count), @1);
    XCTAssertTrue([[[(MFArtistPonso *)actualResults[0] images]allObjects][0] isKindOfClass:[MFImagePonso class]]);
    XCTAssertTrue([actualResults[0] isKindOfClass:[MFArtistPonso class]]);
    
}

- (void)test_whenSearchNonFavoriteArtistsWithTextEqualToEmptyString_thenArtistsAreReturnedSortedProperly {
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchArtistsWithSearchText:@"" searchScope:MFSearchScopeAll];
    
    XCTAssertEqualObjects(@(actualResults.count), @8);
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[0]) name], @"artistName1");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[1]) name], @"artistName2");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[2]) name], @"artistName3");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[3]) name], @"artistName4");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[4]) name], @"searchText5");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[5]) name], @"searchText6");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[6]) name], @"searchText7");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[7]) name], @"searchText8");
}

- (void)test_whenSearchFavoriteArtistsWithTextContainingValue_thenExpectedListIsReturned{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchArtistsWithSearchText:@"searchText" searchScope:MFSearchScopeFavorite];
    
    XCTAssertEqualObjects(@(actualResults.count), @2);
    XCTAssertTrue([actualResults[0] isKindOfClass:[MFArtistPonso class]]);
    XCTAssertEqualObjects(([(id<MFArtist>)actualResults[0] name]), @"searchText5");
    XCTAssertEqualObjects(([(id<MFArtist>)actualResults[1] name]), @"searchText7");
}

- (void)test_whenSearchNonFavoriteArtistsWithTextContainingValue_thenExpectedListIsReturned {
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataArtistPersistence alloc]initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchArtistsWithSearchText:@"searchText" searchScope:MFSearchScopeAll];
    
    XCTAssertEqualObjects(@(actualResults.count), @4);
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[0]) name], @"searchText5");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[1]) name], @"searchText6");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[2]) name], @"searchText7");
    XCTAssertEqualObjects([((id<MFArtist>)actualResults[3]) name], @"searchText8");
}

- (void)test_whenRequestArtistByArtistIdANDFavoriteNonNilInDatabase_thenExpectedArtistReturned {
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    id responseObject = [testObject artistWithArtistId:@"artistId1"];
    
    XCTAssertTrue([responseObject conformsToProtocol:@protocol(MFArtist)]);
    XCTAssertEqualObjects([responseObject id], @"artistId1");
}

- (void)test_whenRequestArtistByArtistIdANDNoneInDatabase_thenExpectedArtistReturned {
    //[self populateStoreWithTestData];
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    XCTAssertNil([testObject artistWithArtistId:@"nonExistantId"]);
}

- (void)test_whenRequestArtistByArtistIdWithFavoriteNilInDatabase_thenReturnNil {
    [self addNewEntityWithArtistId:@"id1" artistName:@"artistName" popularity:@8 isFavorite:nil images:nil];
    [mocProvider.mainContext save:nil];
    NSString *artistId = @"id1";
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    req.predicate = [NSPredicate predicateWithFormat:@"id == %@", artistId];
    NSArray *fetchedEntities = [mocProvider.mainContext executeFetchRequest:req error:nil];
    XCTAssertEqualObjects(@(fetchedEntities.count), @1);
    XCTAssertNil([fetchedEntities[0] isFavorite]);

    
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    XCTAssertNil([testObject artistWithArtistId:@"id1"]);
}

- (void)test_whenRequestToSaveArtistPonsoANDArtistInDatabaseWithNonNilFavorite_thenDoNotSave
{
    [self populateStoreWithTestData];
//    [self addNewEntityWithArtistId:@"artistId1" artistName:@"artistName1" popularity:@1 isFavorite:@1];

    MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"artistName1" popularity:@0 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    

    NSArray *fetchedObjects = [self fetchArtistsWithId:@"artistId1"];
    XCTAssertEqualObjects(@(fetchedObjects.count), @1);
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject saveArtistPonso:artistPonso];
    fetchedObjects = [self fetchArtistsWithId:@"artistId1"];
    XCTAssertEqualObjects(@(fetchedObjects.count), @1);
    XCTAssertEqualObjects([fetchedObjects[0] popularity], @1);
    XCTAssertEqualObjects([fetchedObjects[0] isFavorite], @1);
    XCTAssertEqualObjects([fetchedObjects[0] name], @"artistName1");
    
}


- (void)test_whenRequestToSaveArtistPonsoANDArtisttWithNilFavoriteInDatabase_thenEnsureItSavesAsExpected
{
    NSString *artistId = @"id1";
    [self createArtist:artistId isFavorite:nil];
    [mocProvider.mainContext save:nil];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    req.predicate = [NSPredicate predicateWithFormat:@"id == %@", artistId];
    NSArray *fetchedEntities = [mocProvider.mainContext executeFetchRequest:req error:nil];
    XCTAssertEqualObjects(@(fetchedEntities.count), @1);
    XCTAssertNil([fetchedEntities[0] isFavorite]);
    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:nil artistId:artistId height:@60 width:@50 url:@"url1"];
    
    MFImagePonso *imagePonso2 = [[MFImagePonso alloc] initWithAlbumId:nil artistId:artistId height:@60 width:@40 url:@"url2"];
    
    NSSet *images = [NSSet setWithArray:@[imagePonso1, imagePonso2]];
    
    MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:artistId name:@"artistName" popularity:@20 isFavorite:@0 albums:nil images:images relatedArtists:nil tracks:nil genres:@"Blues, Country"];
    
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    [testObject saveArtistPonso:artistPonso];
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@ AND isFavorite != nil", artistId];
    NSArray *artists = [mocProvider.mainContext executeFetchRequest:request error:nil];
    MFArtistEntity *artistEntity = [artists lastObject];
    XCTAssertEqualObjects(@(artists.count), @1);
    XCTAssertEqualObjects(artistEntity.id, artistPonso.id);
    XCTAssertEqualObjects(@(artistEntity.images.count), @2);
    
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *artistEntityImages = [[artistEntity.images allObjects]sortedArrayUsingDescriptors:@[urlDescriptor]];
    
    
    MFImageEntity *imE1 = [self newImageEntityWithImagePonso:imagePonso1];
    MFImageEntity *imE2 = [self newImageEntityWithImagePonso:imagePonso2];
    
    MFImageEntity *artistImageEntity1 = artistEntityImages[0];
    MFImageEntity *artistImageEntity2 = artistEntityImages[1];
    XCTAssertEqualObjects(artistImageEntity1.height, imE1.height);
    XCTAssertEqualObjects(artistImageEntity1.artistId, imE1.artistId);
    XCTAssertEqualObjects(artistImageEntity1.width, imE1.width);
    XCTAssertEqualObjects(artistImageEntity1.url, imE1.url);
    XCTAssertEqualObjects(artistImageEntity2.artistId, imE2.artistId);
    XCTAssertEqualObjects(artistImageEntity2.height, imE2.height);
    XCTAssertEqualObjects(artistImageEntity2.width, imE2.width);
    XCTAssertEqualObjects(artistImageEntity2.url, imE2.url);
    XCTAssertEqualObjects(artistEntity.name, artistPonso.name);
    XCTAssertEqualObjects(artistEntity.popularity, artistPonso.popularity);
    XCTAssertEqualObjects(artistEntity.isFavorite, artistPonso.isFavorite);
    XCTAssertEqualObjects(artistEntity.genres, artistPonso.genres);
}

- (void)test_whenRequestToSaveArtistPonsoANDArtisttNotInDatabase_thenEnsureItSavesAsExpected
{

    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:nil artistId:@"id1" height:@60 width:@50 url:@"url1"];
    
    MFImagePonso *imagePonso2 = [[MFImagePonso alloc] initWithAlbumId:nil artistId:@"id1" height:@60 width:@40 url:@"url2"];

    NSSet *images = [NSSet setWithArray:@[imagePonso1, imagePonso2]];
    
    MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:@"id1" name:@"artistName" popularity:@20 isFavorite:@0 albums:nil images:images relatedArtists:nil tracks:nil genres:@"Blues, Country"];
    
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    [testObject saveArtistPonso:artistPonso];
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    NSArray *artists = [mocProvider.mainContext executeFetchRequest:request error:nil];
    MFArtistEntity *artistEntity = [artists lastObject];
    XCTAssertEqualObjects(@(artists.count), @1);
    XCTAssertEqualObjects(artistEntity.id, artistPonso.id);
    XCTAssertEqualObjects(@(artistEntity.images.count), @2);
    
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *artistEntityImages = [[artistEntity.images allObjects]sortedArrayUsingDescriptors:@[urlDescriptor]];
    
    
    MFImageEntity *imE1 = [self newImageEntityWithImagePonso:imagePonso1];
    MFImageEntity *imE2 = [self newImageEntityWithImagePonso:imagePonso2];
    
    MFImageEntity *artistImageEntity1 = artistEntityImages[0];
    MFImageEntity *artistImageEntity2 = artistEntityImages[1];
    XCTAssertEqualObjects(artistImageEntity1.height, imE1.height);
    XCTAssertEqualObjects(artistImageEntity1.artistId, imE1.artistId);
    XCTAssertEqualObjects(artistImageEntity1.width, imE1.width);
    XCTAssertEqualObjects(artistImageEntity1.url, imE1.url);
    XCTAssertEqualObjects(artistImageEntity2.artistId, imE2.artistId);
    XCTAssertEqualObjects(artistImageEntity2.height, imE2.height);
    XCTAssertEqualObjects(artistImageEntity2.width, imE2.width);
    XCTAssertEqualObjects(artistImageEntity2.url, imE2.url);
    XCTAssertEqualObjects(artistEntity.name, artistPonso.name);
    XCTAssertEqualObjects(artistEntity.popularity, artistPonso.popularity);
    XCTAssertEqualObjects(artistEntity.isFavorite, artistPonso.isFavorite);
    XCTAssertEqualObjects(artistEntity.genres, artistPonso.genres);
}

- (MFArtistEntity *)createArtist:(NSString *)artistId isFavorite:(NSNumber *)isFavorite
{
    MFArtistEntity * artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:mocProvider.mainContext];
    artist.id = artistId;
    artist.name = @"theArtistName";
    artist.popularity = @0;
    artist.isFavorite = isFavorite;
    
    return artist;
}


- (void)test_whenFavoriteArtistToggledAsFavoriteOnArtistWithFavoriteNonNil_thenUpdateFavoriteAttributeOnArtist
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject favoriteToggleWithArtistId:@"artistId1"];
    MFArtistEntity * artistEntity = [self fetchArtist:@"artistId1"];
    XCTAssertEqualObjects(artistEntity.id, @"artistId1");
    XCTAssertEqualObjects(artistEntity.popularity,@1);
    XCTAssertEqualObjects(artistEntity.name, @"artistName1");
    XCTAssertEqualObjects(artistEntity.isFavorite, @0);
}

- (void)test_whenNonFavoriteArtistToggledAsFavoriteOnArtistWithFavoriteNil_thenKeepFavoriteNil
{
    NSString *artistId = @"id1";
    [self createArtist:artistId isFavorite:nil];
    [mocProvider.mainContext save:nil];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    req.predicate = [NSPredicate predicateWithFormat:@"id == %@", artistId];
    NSArray *fetchedEntities = [mocProvider.mainContext executeFetchRequest:req error:nil];
    XCTAssertEqualObjects(@(fetchedEntities.count), @1);
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject favoriteToggleWithArtistId:artistId];
    MFArtistEntity * artistEntity = [self fetchArtist:artistId];
    XCTAssertEqualObjects(artistEntity.id, artistId);
    XCTAssertEqualObjects(artistEntity.popularity,@0);
    XCTAssertEqualObjects(artistEntity.name, @"theArtistName");
    XCTAssertNil(artistEntity.isFavorite);
}

- (void)test_whenNonFavoriteArtistToggledAsFavoriteOnArtistWithFavoriteNonNil_thenUpdateFavoriteAttributeOnArtist
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataArtistPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject favoriteToggleWithArtistId:@"artistId2"];
    MFArtistEntity * artistEntity = [self fetchArtist:@"artistId2"];
    XCTAssertEqualObjects(artistEntity.id, @"artistId2");
    XCTAssertEqualObjects(artistEntity.popularity,@2);
    XCTAssertEqualObjects(artistEntity.name, @"artistName2");
    XCTAssertEqualObjects(artistEntity.isFavorite, @1);
}


@end
