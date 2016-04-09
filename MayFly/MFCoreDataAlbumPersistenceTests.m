#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataSqlitePSCProvider.h"
#import "MFCoreDataInMemoryPSCProvider.h"
#import "MFCoreDataAlbumPersistence.h"
#import "MFAlbumEntity.h"
#import "MFAlbumPonso.h"
#import "MFTrackEntity.h"
#import "MFTrackPonso.h"
#import "MFArtistEntity.h"
#import "MFArtistPonso.h"
#import "MFImageEntity.h"
#import "MFImagePonso.h"
#import "MFTestUtilities.h"

@interface MFCoreDataAlbumPersistenceTests : XCTestCase
{
    MFCoreDataAlbumPersistence *testObject;
    id<MFCoreDataMOCProvider> mocProvider;
    NSURL *dataStoreUrl;
}

@end

@implementation MFCoreDataAlbumPersistenceTests

- (void)setUp {
    [super setUp];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *dataStoreDirUrl = [NSURL fileURLWithPath:[MFTestUtilityProtectedTemporaryDirectory() stringByAppendingString:[[NSUUID UUID] UUIDString]]];
    
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

- (MFAlbumEntity *)fetchAlbum:(NSString *)albumId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Album" inManagedObjectContext:mocProvider.mainContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", albumId];
    MFAlbumEntity *album = [[mocProvider.mainContext executeFetchRequest:fetchRequest error:nil] firstObject];

    return album;
}

- (NSArray *)fetchAlbumsWithAlbumId:(NSString *)albumId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Album" inManagedObjectContext:mocProvider.mainContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", albumId];
    return [mocProvider.mainContext executeFetchRequest:fetchRequest error:nil];
}

- (void)addNewEntityWithAlbumId:(NSString *)albumId isExplicit:(NSNumber *)isExplicit isFavorite:(NSNumber *)isFavorite albumName:(NSString *)albumName popularity:(NSNumber *)popularity releaseDate:(NSString *)releaseDate releaseDatePrecision:(NSString *)releaseDatePrecision{
    NSManagedObjectContext *mainContext = mocProvider.mainContext;
    MFAlbumEntity *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:mainContext];
    
    album.id = albumId;
    album.explicit = isExplicit;
    album.isFavorite = isFavorite;
    album.name = albumName;
    album.popularity = popularity;
    album.release_date = releaseDate;
    album.release_date_precision = releaseDatePrecision;
}

- (void)populateStoreWithTestData {
    [self addNewEntityWithAlbumId:@"albumId1" isExplicit:@1 isFavorite:@1 albumName:@"name1" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];
    [self addNewEntityWithAlbumId:@"albumId2" isExplicit:@1 isFavorite:@0 albumName:@"name2" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];
    [self addNewEntityWithAlbumId:@"albumId3" isExplicit:@1 isFavorite:@1 albumName:@"name3" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];
    [self addNewEntityWithAlbumId:@"albumId4" isExplicit:@1 isFavorite:@0 albumName:@"name4" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];
    [self addNewEntityWithAlbumId:@"albumId5" isExplicit:@1 isFavorite:@1 albumName:@"searchText5" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];
    [self addNewEntityWithAlbumId:@"albumId6" isExplicit:@1 isFavorite:@0 albumName:@"searchText6" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];
    [self addNewEntityWithAlbumId:@"albumId7" isExplicit:@1 isFavorite:@1 albumName:@"searchText7" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];
    [self addNewEntityWithAlbumId:@"albumId8" isExplicit:@1 isFavorite:@0 albumName:@"searchText8" popularity:@1 releaseDate:@"rd" releaseDatePrecision:@"rdp"];

}

- (void)test_whenRequestToFetchAlbumPonsoWithAlbumIdANDNoneInDatabase_thenReturnAsExpected
{
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    XCTAssertNil([testObject fetchAlbumPonsoWithAlbumId:@"nonExistantAlbumId"]);
}

- (void)test_whenRequestToFetchAlbumPonsoWithAlbumIdANDInDatabase_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    MFAlbumPonso *actualAlbumPonso = [testObject fetchAlbumPonsoWithAlbumId:@"albumId1"];
    XCTAssertEqualObjects(actualAlbumPonso.id, @"albumId1");
    XCTAssertEqualObjects(actualAlbumPonso.explicit, @1);
    XCTAssertEqualObjects(actualAlbumPonso.isFavorite, @1);
    XCTAssertEqualObjects(actualAlbumPonso.name, @"name1");
    XCTAssertEqualObjects(actualAlbumPonso.popularity, @1);
    XCTAssertEqualObjects(actualAlbumPonso.release_date, @"rd");
    XCTAssertEqualObjects(actualAlbumPonso.release_date_precision, @"rdp");
}

- (void)test_whenAlbumIsFavoriteInDatabaseANDPersistenceRequestedItsFavoriteStatus_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    BOOL actual = [testObject isFavoriteWithAlbumId:@"albumId1"];
    
    XCTAssertTrue(actual);
}

- (void)test_whenAlbumIsNotFavoriteInDatabaseANDPersistenceRequestedItsFavoriteStatus_thenReturnAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    XCTAssertFalse([testObject isFavoriteWithAlbumId:@"albumId4"]);
}

- (void)test_whenAlbumIsNOTinDatabaseANDPersistenceRequestedForAlbumsFavoriteStatus_thenReturnAsExpected
{
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    XCTAssertFalse([testObject isFavoriteWithAlbumId:@"nonExistantID"]);
}

- (void)test_whenFetchFavoriteAlbumsWithSearchTextAsEmptyString_thenReturnFavoriteAlbumsSortedByName {
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchAlbumsWithSearchText:@"" searchScope:MFSearchScopeFavorite];
    
    XCTAssertEqualObjects(@(actualResults.count), @(4));
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[0] name]), @"name1");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[1] name]), @"name3");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[2] name]), @"searchText5");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[3] name]), @"searchText7");
}

- (void)test_whenFetchFavoriteAlbumsWithSearchTextAsNonEmptyString_thenReturnFavoriteAlbumsSortedByName {
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchAlbumsWithSearchText:@"searchText" searchScope:MFSearchScopeFavorite];

    XCTAssertEqualObjects(@(actualResults.count), @(2));
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[0] name]), @"searchText5");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[1] name]), @"searchText7");

}

- (void)test_whenFetchAllAlbumsWithSearchTextAsEmptyString_thenReturnAllAlbumsSortedByName {
    
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchAlbumsWithSearchText:@"" searchScope:MFSearchScopeAll];
    
    XCTAssertEqualObjects(@(actualResults.count), @8);
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[0] name]), @"name1");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[1] name]), @"name2");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[2] name]), @"name3");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[3] name]), @"name4");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[4] name]), @"searchText5");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[5] name]), @"searchText6");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[6] name]), @"searchText7");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[7] name]), @"searchText8");
}

- (void)test_whenFetchAllAlbumsWithSearchTextAsNonEmptyString_thenReturnAllAlbumsSortedByName {
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    NSArray *actualResults = [testObject fetchAlbumsWithSearchText:@"searchText" searchScope:MFSearchScopeAll];
    XCTAssertEqualObjects(@(actualResults.count), @4);
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[0] name]), @"searchText5");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[1] name]), @"searchText6");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[2] name]), @"searchText7");
    XCTAssertEqualObjects(([(id<MFAlbum>)actualResults[3] name]), @"searchText8");
}

- (void)test_whenRequestFetchAlbumById_thenExpectedReturned {
    [self populateStoreWithTestData];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    id responseObject = [testObject albumWithAlbumId:@"albumId1"];
    
    XCTAssertTrue([responseObject conformsToProtocol:@protocol(MFAlbum)]);
    XCTAssertEqualObjects([responseObject id], @"albumId1");
}



- (MFTrackEntity *)newTrackEntityWithTrackPonso:(MFTrackPonso *)trackPonso
{
    MFTrackEntity *trackEntity = (MFTrackEntity *)trackPonso;
    trackEntity.id = trackPonso.id;
    trackEntity.name = trackPonso.name;
    trackEntity.track_number = trackPonso.track_number;
    trackEntity.url = trackPonso.url;
    trackEntity.isFavorite = trackPonso.isFavorite;
    trackEntity.explicit = trackPonso.explicit;
    trackEntity.albumId = trackPonso.albumId;
    trackEntity.albumName = trackPonso.albumName;
//    trackEntity.album = trackPonso.album;
    return trackEntity;
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


- (MFAlbumEntity *)newAlbumEntityWithId:(NSString *)albumId name:(NSString *)name
{
    MFAlbumEntity *albumEntity;
    albumEntity.id = albumId;
    albumEntity.name = name;
    return albumEntity;
}

- (void)test_whenRequestToSaveAlbumPonsoANDInDatabase_thenDoNotSaveAsExpected
{
    [self populateStoreWithTestData];
    
    
    MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"modifiedName" isFavorite:@0 popularity:@100 explicit:@0 release_date:@"" release_date_precision:@"" artists:nil images:nil tracks:nil];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSArray *fetchedObjects = [self fetchAlbumsWithAlbumId:@"albumId1"];
    XCTAssertEqualObjects(@(fetchedObjects.count), @1);
    [testObject saveAlbumPonso:albumPonso];
    
    fetchedObjects = [self fetchAlbumsWithAlbumId:@"albumId1"];
    XCTAssertEqualObjects(@(fetchedObjects.count), @1);
    XCTAssertEqualObjects([fetchedObjects[0] name], @"name1");
    XCTAssertEqualObjects([fetchedObjects[0] explicit], @1);
    XCTAssertNotNil([fetchedObjects[0] release_date]);
    XCTAssertNotNil([fetchedObjects[0] release_date_precision]);
    
}

- (void)test_whenRequestToSaveAlbumPonsoANDNotInDatabase_thenSaveAsExpected
{
    
    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@60 width:@50 url:@"url1"];
    MFImagePonso *imagePonso2 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@60 width:@40 url:@"url2"];
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"The Sleet Slickers" popularity:@100 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"El Rio Riders" popularity:@20 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Krill Cream Korn" popularity:@25 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    NSSet *artist1 = [NSSet setWithObjects:artistPonso1, artistPonso2, nil];
    NSSet *artist2 = [NSSet setWithObjects:artistPonso2, artistPonso3, nil];
    NSSet *images = [NSSet setWithArray:@[imagePonso1, imagePonso2]];
    NSSet *albumArtists = [NSSet setWithObjects:artistPonso1,artistPonso2, artistPonso3, nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"The Purple Pajama Potatoe Peelers" albumId:@"albumId1" albumName:@"The Lean Lint Lickers" explicit:@1 isFavorite:@1 disc_number:@1 track_number:@1 url:@"url1" popularity:@20 artists:artist1 images:images];
    
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Roger Right" albumId:@"albumId1" albumName:@"The Lean Lint Lickers" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url2" popularity:@3 artists:artist2 images:images];
    

    NSSet *albumTracks = [NSSet setWithObjects:trackPonso1, trackPonso2, nil];
    
    MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"The Lean Lint Lickers" isFavorite:@1 popularity:@100 explicit:@1 release_date:@"date" release_date_precision:@"MM/DD/YY" artists:albumArtists images:images tracks:albumTracks];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    [testObject saveAlbumPonso:albumPonso];
    
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Album"];
    NSArray *albums = [mocProvider.mainContext executeFetchRequest:request error:nil];
    MFAlbumEntity *albumEntity = [albums lastObject];
    XCTAssertEqualObjects(@(albums.count), @1);
    XCTAssertEqualObjects(albumEntity.id, albumPonso.id);
    XCTAssertEqualObjects(albumEntity.explicit, albumPonso.explicit);
    XCTAssertEqualObjects(albumEntity.isFavorite, albumPonso.isFavorite);
    XCTAssertEqualObjects(albumEntity.name, albumPonso.name);
    XCTAssertEqualObjects(albumEntity.popularity, albumPonso.popularity);
    XCTAssertEqualObjects(albumEntity.release_date, albumPonso.release_date);
    XCTAssertEqualObjects(albumEntity.release_date_precision, albumPonso.release_date_precision);
    
    
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *albumEntityImages = [[albumEntity.images allObjects]sortedArrayUsingDescriptors:@[urlDescriptor]];
    
    MFImageEntity *imE1 = [self newImageEntityWithImagePonso:imagePonso1];
    MFImageEntity *imE2 = [self newImageEntityWithImagePonso:imagePonso2];
    
    MFImageEntity *albumImageEntity1 = albumEntityImages[0];
    MFImageEntity *albumImageEntity2 = albumEntityImages[1];
    
    XCTAssertEqualObjects(albumImageEntity1.height, imE1.height);
    XCTAssertEqualObjects(albumImageEntity1.albumId, imE1.albumId);
    XCTAssertEqualObjects(albumImageEntity1.width, imE1.width);
    XCTAssertEqualObjects(albumImageEntity1.url, imE1.url);
    XCTAssertEqualObjects(albumImageEntity2.albumId, imE2.albumId);
    XCTAssertEqualObjects(albumImageEntity2.height, imE2.height);
    XCTAssertEqualObjects(albumImageEntity2.width, imE2.width);
    XCTAssertEqualObjects(albumImageEntity2.url, imE2.url);
    
    NSSortDescriptor *albumArtistDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *albumEntityArtists = [[albumEntity.artists allObjects]sortedArrayUsingDescriptors:@[albumArtistDescriptor]];
    
    MFArtistEntity *artistE1 = [self newArtistsEntityWithArtistPonso:artistPonso1];
    MFArtistEntity *artistE2 = [self newArtistsEntityWithArtistPonso:artistPonso2];
    MFArtistEntity *artistE3 = [self newArtistsEntityWithArtistPonso:artistPonso3];
    
    MFArtistEntity *albumArtistEntity1 = albumEntityArtists[0];
    MFArtistEntity *albumArtistEntity2 = albumEntityArtists[1];
    MFArtistEntity *albumArtistEntity3 = albumEntityArtists[2];
    XCTAssertEqualObjects(@(albumEntity.artists.count), @3);
    
    XCTAssertEqualObjects(albumArtistEntity1.id, artistE1.id);
    XCTAssertEqualObjects(albumArtistEntity1.name, artistE1.name);
    XCTAssertEqualObjects(albumArtistEntity2.id, artistE2.id);
    XCTAssertEqualObjects(albumArtistEntity2.name, artistE2.name);
    XCTAssertEqualObjects(albumArtistEntity3.id, artistE3.id);
    XCTAssertEqualObjects(albumArtistEntity3.name, artistE3.name);
    
    
    
    NSSortDescriptor *albumTrackDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *albumEntityTracks = [[albumEntity.tracks allObjects] sortedArrayUsingDescriptors:@[albumTrackDescriptor]];
    
    MFTrackEntity *trackE1 = [self newTrackEntityWithTrackPonso:trackPonso1];
    MFTrackEntity *trackE2 = [self newTrackEntityWithTrackPonso:trackPonso2];

    
    MFTrackEntity *albumTrackEntity1 = albumEntityTracks[0];
    MFTrackEntity *albumTrackEntity2 = albumEntityTracks[1];
    
    
    XCTAssertEqualObjects(@(albumEntity.tracks.count), @2);
    XCTAssertEqualObjects(albumTrackEntity1.id, trackE1.id);
    XCTAssertEqualObjects(albumTrackEntity1.name, trackE1.name);
    XCTAssertEqualObjects(albumTrackEntity1.track_number, trackE1.track_number);
    XCTAssertEqualObjects(albumTrackEntity1.disc_number, trackE1.disc_number);
    XCTAssertEqualObjects(albumTrackEntity1.url, trackE1.url);
    XCTAssertEqualObjects(albumTrackEntity1.isFavorite, trackE1.isFavorite);
    XCTAssertEqualObjects(albumTrackEntity1.explicit, trackE1.explicit);
    XCTAssertEqualObjects(albumTrackEntity1.albumId, trackE1.albumId);
    XCTAssertEqualObjects(albumTrackEntity1.albumName, trackE1.albumName);
    XCTAssertEqualObjects(albumTrackEntity2.id, trackE2.id);
    XCTAssertEqualObjects(albumTrackEntity2.name, trackE2.name);
    XCTAssertEqualObjects(albumTrackEntity2.track_number, trackE2.track_number);
    XCTAssertEqualObjects(albumTrackEntity2.disc_number, trackE2.disc_number);
    XCTAssertEqualObjects(albumTrackEntity2.url, trackE2.url);
    XCTAssertEqualObjects(albumTrackEntity2.isFavorite, trackE2.isFavorite);
    XCTAssertEqualObjects(albumTrackEntity2.explicit, trackE2.explicit);
    XCTAssertEqualObjects(albumTrackEntity2.albumId, trackE2.albumId);
    XCTAssertEqualObjects(albumTrackEntity2.albumName, trackE2.albumName);


    NSSortDescriptor *trackArtistDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *trackEntityArtists = [[albumTrackEntity1.artists allObjects] sortedArrayUsingDescriptors:@[trackArtistDescriptor]];
    
    
    
    MFArtistEntity *trackArtistEntity1 = trackEntityArtists[0];
    MFArtistEntity *trackArtistEntity2 = trackEntityArtists[1];
    
    XCTAssertEqualObjects(trackArtistEntity1.name, artistE1.name);
    XCTAssertEqualObjects(trackArtistEntity1.id, artistE1.id);
    XCTAssertEqualObjects(trackArtistEntity2.name, artistE2.name);
    XCTAssertEqualObjects(trackArtistEntity2.id, artistE2.id);
    
    trackEntityArtists = [[albumTrackEntity2.artists allObjects] sortedArrayUsingDescriptors:@[trackArtistDescriptor]];

    trackArtistEntity1 = trackEntityArtists[0];
    trackArtistEntity2 = trackEntityArtists[1];
    XCTAssertEqualObjects(trackArtistEntity1.name, artistE2.name);
    XCTAssertEqualObjects(trackArtistEntity1.id, artistE2.id);
    XCTAssertEqualObjects(trackArtistEntity2.name, artistE3.name);
    XCTAssertEqualObjects(trackArtistEntity2.id, artistE3.id);
}

- (void)test_whenFetchWithSearchText_thenEnsureWeAreReturnedPonsos
{
    MFImagePonso *imagePonso1 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@60 width:@50 url:@"url1"];
    MFImagePonso *imagePonso2 = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:@"id1" height:@60 width:@40 url:@"url2"];
    
    MFArtistPonso *artistPonso1 = [[MFArtistPonso alloc] initWithId:@"artistId1" name:@"The Sleet Slickers" popularity:@100 isFavorite:@1 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso2 = [[MFArtistPonso alloc] initWithId:@"artistId2" name:@"El Rio Riders" popularity:@20 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    MFArtistPonso *artistPonso3 = [[MFArtistPonso alloc] initWithId:@"artistId3" name:@"Krill Cream Korn" popularity:@25 isFavorite:@0 albums:nil images:nil relatedArtists:nil tracks:nil genres:nil];
    
    NSSet *artist1 = [NSSet setWithObjects:artistPonso1, artistPonso2, nil];
    NSSet *artist2 = [NSSet setWithObjects:artistPonso2, artistPonso3, nil];
    NSSet *images = [NSSet setWithArray:@[imagePonso1, imagePonso2]];
    NSSet *albumArtists = [NSSet setWithObjects:artistPonso1,artistPonso2, artistPonso3, nil];
    
    MFTrackPonso *trackPonso1 = [[MFTrackPonso alloc] initWithId:@"trackId1" name:@"The Purple Pajama Potatoe Peelers" albumId:@"albumId1" albumName:@"The Lean Lint Lickers" explicit:@1 isFavorite:@1 disc_number:@1 track_number:@1 url:@"url1" popularity:@20 artists:artist1 images:images];
    
    MFTrackPonso *trackPonso2 = [[MFTrackPonso alloc] initWithId:@"trackId2" name:@"Roger Right" albumId:@"albumId1" albumName:@"The Lean Lint Lickers" explicit:@0 isFavorite:@1 disc_number:@1 track_number:@2 url:@"url2" popularity:@3 artists:artist2 images:images];
    
    
    NSSet *albumTracks = [NSSet setWithObjects:trackPonso1, trackPonso2, nil];
    
    MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:@"albumId1" name:@"The Lean Lint Lickers" isFavorite:@1 popularity:@100 explicit:@1 release_date:@"date" release_date_precision:@"MM/DD/YY" artists:albumArtists images:images tracks:albumTracks];
    
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    
    [testObject saveAlbumPonso:albumPonso];
    
    NSArray *actual = [testObject fetchAlbumsWithSearchText:@"The Lean Lint Lickers" searchScope:MFSearchScopeAll];
    
    XCTAssertEqualObjects(@(actual.count), @1);
    XCTAssertTrue([actual[0] isKindOfClass:[MFAlbumPonso class]]);
    XCTAssertTrue([[[(MFAlbumPonso *)actual[0] images] allObjects][0] isKindOfClass:[MFImagePonso class]]);
    XCTAssertTrue([[[(MFAlbumPonso *)actual[0] tracks] allObjects][0] isKindOfClass:[MFTrackPonso class]]);
    XCTAssertTrue([[[(MFAlbumPonso *)actual[0] artists] allObjects][0] isKindOfClass:[MFArtistPonso class]]);
    

}

- (void)test_whenFavoriteAnAlbumOriginallyNotFavorite_thenUpdateAttributeAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject favoriteToggledWithAlbumId:@"albumId2"];
    MFAlbumEntity *albumEntity = [self fetchAlbum:@"albumId2"];
    XCTAssertEqualObjects(albumEntity.id, @"albumId2");
    XCTAssertEqualObjects(albumEntity.explicit, @1);
    XCTAssertEqualObjects(albumEntity.isFavorite, @1);
    XCTAssertEqualObjects(albumEntity.name, @"name2");
    XCTAssertEqualObjects(albumEntity.popularity, @1);
    XCTAssertEqualObjects(albumEntity.release_date, @"rd");
    XCTAssertEqualObjects(albumEntity.release_date_precision, @"rdp");}

- (void)test_whenFavoriteAnAlbumOriginallyFavorite_thenUpdateAttributeAsExpected
{
    [self populateStoreWithTestData];
    testObject = [[MFCoreDataAlbumPersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    [testObject favoriteToggledWithAlbumId:@"albumId1"];
    MFAlbumEntity *albumEntity = [self fetchAlbum:@"albumId1"];
    XCTAssertEqualObjects(albumEntity.id, @"albumId1");
    XCTAssertEqualObjects(albumEntity.explicit, @1);
    XCTAssertEqualObjects(albumEntity.isFavorite, @0);
    XCTAssertEqualObjects(albumEntity.name, @"name1");
    XCTAssertEqualObjects(albumEntity.popularity, @1);
    XCTAssertEqualObjects(albumEntity.release_date, @"rd");
    XCTAssertEqualObjects(albumEntity.release_date_precision, @"rdp");
}


@end