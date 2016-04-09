#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataTrackPersistence.h"
#import "MFTrackEntity.h"
#import "MFTrackPonso.h"
#import "MFImageEntity.h"
#import "MFAlbumEntity.h"
#import "MFImage.h"
#import "MFImagePonso.h"
#import "MFArtistPonso.h"
#import "MFArtistEntity.h"
#import "MFAlbumEntity.h"
#import "MFCoreDataSqlitePSCProvider.h"
#import "MFCoreDataInMemoryPSCProvider.h"
#import "MFTestUtilities.h"

@interface MFCoreDataTrackPersistenceTracks : XCTestCase
{
    MFCoreDataTrackPersistence *testObject;
    id<MFCoreDataMOCProvider> mocProvider;
    NSURL *dataStoreUrl;
}
@end

@implementation MFCoreDataTrackPersistenceTracks

- (void)setUp {
    [super setUp];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *dataStoreDirUrl = [NSURL fileURLWithPath:[MFTestUtilityProtectedTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]]];
    
    [fileManager createDirectoryAtURL:dataStoreDirUrl withIntermediateDirectories:YES attributes:nil error:&error];
    
    dataStoreUrl = [dataStoreDirUrl URLByAppendingPathComponent:@"database.sqlite"];
    [fileManager createFileAtPath:dataStoreDirUrl.path contents:nil attributes:nil];
    
    MFCoreDataSqlitePSCProvider *pscProvider = [[MFCoreDataSqlitePSCProvider alloc] initWithUserStoreURL:dataStoreUrl];
    
    mocProvider = [[MFCoreDataMOCProvider alloc] initWithStoreProvider:pscProvider];
    
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

#pragma mark - Helpers

- (MFTrackEntity *)fetchTrack:(NSString *)trackId {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:mocProvider.mainContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", trackId];
    MFTrackEntity *track = [[mocProvider.mainContext executeFetchRequest:fetchRequest error:nil] firstObject];
    
    return track;
}

- (NSArray *)fetchTracksWithTrackId:(NSString *)trackId {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:mocProvider.mainContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", trackId];
    return [mocProvider.mainContext executeFetchRequest:fetchRequest error:nil];

}


- (void)addNewEntityWithTrackId:(NSString *)trackId
                        albumId:(NSString *)albumId
                       isExplicit:(NSNumber *)isExplicit
                    trackNumber:(NSNumber *)trackNumber
                    disc_number:(NSNumber *)disc_number
                            url:(NSString *)url
                     isFavorite:(NSNumber *)isFavorite
                     popularity:(NSNumber *)popularity
                      trackName:(NSString *)trackName
                      albumName:(NSString *)albumName {
    
    NSManagedObjectContext *mainContext = mocProvider.mainContext;
    MFTrackEntity *track = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:mainContext];
    
    track.id = trackId;
    track.albumId = albumId;
    track.explicit = isExplicit;
    track.track_number = trackNumber;
    track.url = url;
    track.isFavorite = isFavorite;
    track.name = trackName;
    track.albumName = albumName;
    track.disc_number = disc_number;
}

- (void)populateStoreWithTestData {
    [self addNewEntityWithTrackId:@"trackId12" albumId:@"albumId1" isExplicit:@1 trackNumber:@2 disc_number:@1 url:@"url12" isFavorite:@0 popularity:@20 trackName:@"track12" albumName:@"albumName1"];
    [self addNewEntityWithTrackId:@"trackId13" albumId:@"albumId1" isExplicit:@0 trackNumber:@3 disc_number:@1 url:@"url13" isFavorite:@1 popularity:@1 trackName:@"track13" albumName:@"albumName1"];
    [self addNewEntityWithTrackId:@"trackId11" albumId:@"albumId1" isExplicit:@1 trackNumber:@1 disc_number:@2 url:@"url11" isFavorite:@1 popularity:@3 trackName:@"track11" albumName:@"albumName1"];
    
    [self addNewEntityWithTrackId:@"trackId14" albumId:@"albumId1" isExplicit:@1 trackNumber:@4 disc_number:@1 url:@"url14" isFavorite:@1 popularity:@14 trackName:@"searchText14" albumName:@"albumName1"];
    
    [self addNewEntityWithTrackId:@"trackId15" albumId:@"albumId1" isExplicit:@0 trackNumber:@5 disc_number:@1 url:@"url15" isFavorite:@0 popularity:@15 trackName:@"searchText15" albumName:@"albumName1"];
    
    
    [self addNewEntityWithTrackId:@"trackId23" albumId:@"albumId2" isExplicit:@0 trackNumber:@3 disc_number:@1 url:@"url23" isFavorite:@0 popularity:@23 trackName:@"track23" albumName:@"albumName2"];
    [self addNewEntityWithTrackId:@"trackId21" albumId:@"albumId2" isExplicit:@0 trackNumber:@1 disc_number:@1 url:@"url21" isFavorite:@0 popularity:@21 trackName:@"track21" albumName:@"albumName2"];
    [self addNewEntityWithTrackId:@"trackId22" albumId:@"albumId2" isExplicit:@1 trackNumber:@2 disc_number:@2 url:@"url22" isFavorite:@1 popularity:@22 trackName:@"track22" albumName:@"albumName2"];
    
    [self addNewEntityWithTrackId:@"trackId24" albumId:@"albumId2" isExplicit:@0 trackNumber:@4 disc_number:@2 url:@"url24" isFavorite:@0 popularity:@24 trackName:@"searchText24" albumName:@"albumName2"];
    [self addNewEntityWithTrackId:@"trackId25" albumId:@"albumId2" isExplicit:@1 trackNumber:@5 disc_number:@2 url:@"url25" isFavorite:@1 popularity:@25 trackName:@"searchText25" albumName:@"albumName2"];
    
    NSError *error;
    [mocProvider.mainContext save:&error];
}

- (void)test_whenRequestToFetchTracksWithAlbumIdANDNoneInDatabase_thenReturnAsExpected
{
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    XCTAssertNil([testObject fetchTrackPonsosWithAlbumId:@"nonExistantId" albumName:@"name"]);
}

- (void)test_whenRequestToFetchTrackWithAlbumIdANDMultipleInDatabase_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSSortDescriptor *alphabeticalByTrackName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSet *actual = [testObject fetchTrackPonsosWithAlbumId:@"albumId1" albumName:@"albumName1"];
    NSArray *actualAsSortedArray = [NSArray arrayWithArray:[[actual allObjects] sortedArrayUsingDescriptors:@[alphabeticalByTrackName]]];
    XCTAssertEqualObjects(@(actualAsSortedArray.count), @5);
    XCTAssertTrue([actualAsSortedArray[0] isKindOfClass:[MFTrackPonso class]]);
    XCTAssertTrue([actualAsSortedArray[1] isKindOfClass:[MFTrackPonso class]]);
    XCTAssertEqualObjects([actualAsSortedArray[0] name], @"searchText14");
    XCTAssertEqualObjects([actualAsSortedArray[1] name], @"searchText15");
    XCTAssertEqualObjects([actualAsSortedArray[2] name], @"track11");
    XCTAssertEqualObjects([actualAsSortedArray[3] name], @"track12");
    XCTAssertEqualObjects([actualAsSortedArray[4] name], @"track13");
    XCTAssertEqualObjects([actualAsSortedArray[0] albumName], @"albumName1");
    XCTAssertEqualObjects([actualAsSortedArray[1] albumName], @"albumName1");
    XCTAssertEqualObjects([actualAsSortedArray[2] albumName], @"albumName1");
    XCTAssertEqualObjects([actualAsSortedArray[3] albumName], @"albumName1");
    XCTAssertEqualObjects([actualAsSortedArray[4] albumName], @"albumName1");
}

- (void)test_whenTrackIsFavoriteInDatabaseANDPersistenceRequestedItsFavoriteStatus_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    BOOL actual = [testObject isFavoriteWithTrackId:@"trackId13"];
    
    XCTAssertTrue(actual);
}

- (void)test_whenTrackIsNotFavoriteInDatabaseANDPersistenceRequestedItsFavoriteStatus_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    XCTAssertFalse([testObject isFavoriteWithTrackId:@"trackId12"]);
}

- (void)test_whenTrackIsNOTinDatabaseANDPersistenceRequestedForTracksFavoriteStatus_thenReturnAsExpected
{
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    XCTAssertFalse([testObject isFavoriteWithTrackId:@"nonExistantID"]);
}

- (void)test_whenFetchFavoriteTracksWithTextEqualToEmptyString_thenFavoriteTracksSortedByAlbumNameThenTrackNumberAreReturned{
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchTracksWithSearchText:@"" searchScope:MFSearchScopeFavorite];
    
    XCTAssertEqualObjects(@(actualResults.count), @5);
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[0] name]), @"track11");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[1] name]), @"track13");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[2]  name]), @"searchText14");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[3] name]), @"track22");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[4]  name]), @"searchText25");

}

- (void)test_whenFavoriteTracksWithTextContainingNonEmptySearchString_thenFavoriteTracksSortedByTrackNameAreReturned{
    
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSArray *actualResults = [testObject fetchTracksWithSearchText:@"searchText" searchScope:MFSearchScopeFavorite];
    
    XCTAssertEqualObjects(@(actualResults.count), @2);
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[0] name]), @"searchText14");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[1] name]), @"searchText25");
    
}

- (void)test_whenFetchAllTracksWithEmptyText_thenAllTracksSortedByAlbumNameThenTrackNumberAreReturned {
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchTracksWithSearchText:@"" searchScope:MFSearchScopeAll];
    
    XCTAssertEqualObjects(@(actualResults.count), @10);
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[0] name]), @"track11");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[1] name]), @"track12");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[2]  name]), @"track13");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[3] name]), @"searchText14");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[4]  name]), @"searchText15");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[5] name]), @"track21");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[6] name]), @"track22");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[7]  name]), @"track23");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[8] name]), @"searchText24");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[9]  name]), @"searchText25");
}


- (void)test_whenFetchAllTracksWithSearchText_thenAllTracksSortedByTrackNameAreReturned{
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchTracksWithSearchText:@"searchText" searchScope:MFSearchScopeAll];
    XCTAssertEqualObjects(@(actualResults.count), @4);
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[0] name]), @"searchText14");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[1] name]), @"searchText15");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[2]  name]), @"searchText24");
    XCTAssertEqualObjects(([(id<MFTrack>)actualResults[3] name]), @"searchText25");
}

- (void)test_whenCallTrackWithId_thenItReturnsExpectedProtocol{
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    id responseObject = [testObject trackWithTrackId:@"trackId11"];
    
    XCTAssertTrue([responseObject conformsToProtocol:@protocol(MFTrack)]);
    XCTAssertEqualObjects([responseObject id], @"trackId11");
}

- (MFArtistEntity *)newArtistsEntityWithArtistPonso:(MFArtistPonso *)artistPonso
{
    MFArtistEntity *artistEntity = (MFArtistEntity *)artistPonso;
    artistEntity.id = artistPonso.id;
    artistEntity.name = artistPonso.name;
    return artistEntity;
}

- (MFImageEntity *)newImageEntityWithImagePonso:(MFImagePonso *)imagePonso
{
    MFImageEntity *imageEntity = (MFImageEntity *)imagePonso;
    imageEntity.height = imagePonso.height;
    imageEntity.width = imagePonso.width;
    imageEntity.artistId = imagePonso.artistId;
    imageEntity.albumId = imagePonso.albumId;
    
    return imageEntity;
}

- (MFAlbumEntity *)newAlbumEntityWithId:(NSString *)albumId
{
    id<MFAlbum> album;
    album.id = albumId;
    return album;
}

- (void)test_whenRequestToSaveTrackPonsoANDTrackIsNotInDatabase_thenDoNotSave
{
    [self populateStoreWithTestData];
    MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:@"trackId12" name:@"trackModified12" albumId:@"id2" albumName:@"name" explicit:@2 isFavorite:@0 disc_number:@1 track_number:@2 url:@"url13" popularity:@100 artists:nil images:nil];
    

    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSArray *fetchedObjects = [self fetchTracksWithTrackId:@"trackId12"];
    XCTAssertEqualObjects(@(fetchedObjects.count), @1);
    [testObject saveTrackPonso:trackPonso];
    fetchedObjects = [self fetchTracksWithTrackId:@"trackId12"];
    XCTAssertEqualObjects(@(fetchedObjects.count), @1);
    XCTAssertEqualObjects([fetchedObjects[0] name], @"track12");
    XCTAssertEqualObjects([fetchedObjects[0] albumId], @"albumId1");
    XCTAssertEqualObjects([fetchedObjects[0] albumName], @"albumName1");
    
}

- (void)test_whenFetchTrackWithSearch_thenEnsurePonsosAreRetrieved
{
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"The Sleet Slickers" popularity:@100 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"El Rio Riders" popularity:@20 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    NSSet *artists = [NSSet setWithObjects:artistPonso1, artistPonso2, nil];
    
    MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"The Purple Potatoe Eaters" albumId:@"albumId1" albumName:@"The Steak Stick Slappers" explicit:@1 isFavorite:@1 disc_number:@1 track_number:@1 url:@"url1" popularity:@78 artists:artists images:nil];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    [testObject saveTrackPonso:trackPonso];
    NSArray *actual = [testObject fetchTracksWithSearchText:@"The Purple Potatoe Eaters" searchScope:MFSearchScopeFavorite];
    NSArray *actualArtists = [[(MFTrackPonso *)actual[0] artists] allObjects];
    XCTAssertTrue([actual[0] isKindOfClass:[MFTrackPonso class]]);
    XCTAssertTrue([actualArtists[0] isKindOfClass:[MFArtistPonso class]]);
    
}

- (void)test_whenRequestToSaveTrackPonsoANDTrackIsInDatabase_thenSaveAsExpected
{
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"The Sleet Slickers" popularity:@100 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];

    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"El Rio Riders" popularity:@20 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    NSSet *artists = [NSSet setWithObjects:artistPonso1, artistPonso2, nil];
    
    MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"The Purple Potatoe Eaters" albumId:@"albumId1" albumName:@"The Steak Stick Slappers" explicit:@1 isFavorite:@1 disc_number:@1 track_number:@1 url:@"url1" popularity:@78 artists:artists images:nil];
    
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    [testObject saveTrackPonso:trackPonso];
    
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Track"];
    NSArray *tracks = [mocProvider.mainContext executeFetchRequest:request error:nil];
    MFTrackEntity *trackEntity = [tracks lastObject];
    XCTAssertEqualObjects(@(tracks.count), @1);
    XCTAssertEqualObjects(trackEntity.id, trackPonso.id);
    XCTAssertEqualObjects(trackEntity.name, trackPonso.name);
    XCTAssertEqualObjects(trackEntity.track_number, trackPonso.track_number);
    XCTAssertEqualObjects(trackEntity.disc_number, trackPonso.disc_number);
    XCTAssertEqualObjects(trackEntity.url, trackPonso.url);
    XCTAssertEqualObjects(trackEntity.isFavorite, trackPonso.isFavorite);
    XCTAssertEqualObjects(trackEntity.explicit, trackPonso.explicit);
    XCTAssertEqualObjects(trackEntity.albumId, trackPonso.albumId);
    XCTAssertEqualObjects(trackEntity.popularity, trackPonso.popularity);
    
    NSSortDescriptor *artistIdDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *trackEntityArtists = [[trackEntity.artists allObjects]sortedArrayUsingDescriptors:@[artistIdDescriptor]];
    
    MFArtistEntity *a1 = [self newArtistsEntityWithArtistPonso:artistPonso1];
    MFArtistEntity *a2 = [self newArtistsEntityWithArtistPonso:artistPonso2];
    
    MFArtistEntity *trackArtistEntity1 = trackEntityArtists[0];
    MFArtistEntity *trackArtistEntity2 = trackEntityArtists[1];
    XCTAssertEqualObjects(@(trackEntity.artists.count), @2);
    XCTAssertEqualObjects(trackArtistEntity1.name, a1.name);
    XCTAssertEqualObjects(trackArtistEntity1.id, a1.id);
    XCTAssertEqualObjects(trackArtistEntity2.name, a2.name);
    XCTAssertEqualObjects(trackArtistEntity2.id, a2.id);
    
}

- (void)test_whenNonFavoriteTrackToggledAsFavorite_thenUpdateFavoriteAttributeAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject favoriteToggledWithTrack:@"trackId12"];
    MFTrackEntity * trackEntity = [self fetchTrack:@"trackId12"];
    XCTAssertEqualObjects(trackEntity.id, @"trackId12");
    XCTAssertEqualObjects(trackEntity.albumId, @"albumId1");
    XCTAssertEqualObjects(trackEntity.explicit, @1);
    XCTAssertEqualObjects(trackEntity.track_number, @2);
    XCTAssertEqualObjects(trackEntity.url, @"url12");
    XCTAssertEqualObjects(trackEntity.isFavorite, @1);
    XCTAssertEqualObjects(trackEntity.name, @"track12");
    XCTAssertEqualObjects(trackEntity.albumName, @"albumName1");
    
}

- (void)test_whenFavoriteTrackToggledAsFavorite_thenUpdateFavoriteAttributeAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataTrackPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject favoriteToggledWithTrack:@"trackId11"];
    MFTrackEntity * trackEntity = [self fetchTrack:@"trackId11"];
    XCTAssertEqualObjects(trackEntity.id, @"trackId11");
    XCTAssertEqualObjects(trackEntity.albumId, @"albumId1");
    XCTAssertEqualObjects(trackEntity.explicit, @1);
    XCTAssertEqualObjects(trackEntity.track_number, @1);
    XCTAssertEqualObjects(trackEntity.url, @"url11");
    XCTAssertEqualObjects(trackEntity.isFavorite, @0);
    XCTAssertEqualObjects(trackEntity.name, @"track11");
    XCTAssertEqualObjects(trackEntity.albumName, @"albumName1");
}
@end
