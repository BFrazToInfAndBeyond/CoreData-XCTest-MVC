#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataImagePersistence.h"
#import "MFImageEntity.h"
#import "MFImagePonso.h"
#import "MFCoreDataSqlitePSCProvider.h"
#import "MFCoreDataInMemoryPSCProvider.h"
#import "MFTestUtilities.h"

@interface MFCoreDataImagePersistenceTests : XCTestCase
{
    MFCoreDataImagePersistence *testObject;
    id<MFCoreDataMOCProvider> mocProvider;
    NSURL *dataStoreUrl;
}
@end

@implementation MFCoreDataImagePersistenceTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
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

- (MFImageEntity *)fetchImageWithArtistId:(NSString *)artistId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"artistId == %@", artistId];
    NSError *error = nil;
    return [[mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
}

- (MFImageEntity *)fetchImageWithArtistId:(NSString *)artistId url:(NSString *)url
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"artistId == %@ AND url == %@", artistId, url];
    NSError *error = nil;
    return [[mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
}

- (MFImageEntity *)fetchImageWithAlbumId:(NSString *)albumId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"albumId == %@", albumId];
    NSError *error = nil;
    return [[mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
}

- (MFImageEntity *)fetchImageWithAlbumId:(NSString *)albumId url:(NSString *)url
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"albumId == %@ AND url == %@", albumId, url];
    NSError *error = nil;
    return [[mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
}

- (NSArray *)fetchImagesWithArtistId:(NSString *)artistId url:(NSString *)url
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"artistId == %@ AND url == %@", artistId, url];
    NSError *error = nil;
    return [mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
}

- (NSArray *)fetchImagesWithAlbumId:(NSString *)albumId url:(NSString *)url
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"albumId == %@ AND url == %@", albumId, url];
    NSError *error = nil;
    return [mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
}

- (void)addNewEntityWithArtistId:(NSString *)artistId albumId:(NSString *)albumId height:(NSNumber *)height width:(NSNumber *)width url:(NSString *)url
{
    NSManagedObjectContext *mainContext = mocProvider.mainContext;
    MFImageEntity *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:mainContext];
    
    image.artistId = artistId;
    image.albumId = albumId;
    image.height = height;
    image.width = width;
    image.url = url;
}

- (void)populateTestData
{
    [self addNewEntityWithArtistId:nil albumId:@"albumId1" height:@200 width:@200 url:@"url1"];
    
    [self addNewEntityWithArtistId:@"artistId1" albumId:nil height:@64 width:@54 url:@"url2"];
    
    [self addNewEntityWithArtistId:@"artistId1" albumId:@"albumId1" height:@60 width:@60 url:@"url3"];
    
    [self addNewEntityWithArtistId:@"artistId1" albumId:@"albumId2" height:@50 width:@50 url:@"url4"];
    
    
    [self addNewEntityWithArtistId:@"artistId2" albumId:@"albumId1" height:@40 width:@40 url:@"url5"];
    
    [self addNewEntityWithArtistId:nil albumId:@"albumId1" height:@30 width:@30 url:@"url6"];
    
    [self addNewEntityWithArtistId:nil albumId:@"albumId2" height:@50 width:@50 url:@"url7"];
    [self addNewEntityWithArtistId:nil albumId:@"albumId3" height:@60 width:@60 url:@"url8"];

    [mocProvider.mainContext save:nil];
}

- (void)test_whenRequestToSaveImagePonsoWithNilArtistIdANDNonNilAlbumIdANDImageNotInDatabase_thenSaveAsExpected
{
    
    MFImagePonso *imagePonsoToSave = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:nil height:@200 width:@100 url:@"url1"];

    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    MFImageEntity *imageEntity = [self fetchImageWithAlbumId:@"albumId1"];
    XCTAssertNil(imageEntity);
    [testObject saveImagePonso:imagePonsoToSave];
    imageEntity = [self fetchImageWithAlbumId:@"albumId1"];
    XCTAssertNotNil(imageEntity);
    XCTAssertNil(imageEntity.artistId);
    XCTAssertEqualObjects(imageEntity.width, @100);
    XCTAssertEqualObjects(imageEntity.height, @200);
}

- (void)test_whenRequestToSaveImagePonsoWithNonNilArtistIdANDNilAlbumIdANDImageNotInDatabase_thenSaveAsExpected
{
    MFImagePonso *imagePonsoToSave = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:nil height:@200 width:@100 url:@"url6"];
    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    MFImageEntity *imageEntity = [self fetchImageWithAlbumId:@"albumId1"];
    XCTAssertNil(imageEntity);
    [testObject saveImagePonso:imagePonsoToSave];
    imageEntity = [self fetchImageWithAlbumId:@"albumId1"];
    XCTAssertNotNil(imageEntity);
    XCTAssertNil(imageEntity.artistId);
    XCTAssertEqualObjects(imageEntity.width, @100);
    XCTAssertEqualObjects(imageEntity.height, @200);
    XCTAssertEqualObjects(imageEntity.url, @"url6");
    
}

- (void)test_whenRequestToSaveImagePonsoWithNilArtistIdANDNonNilAlbumIdANDImageInDatabase_thenDoNotSave
{
    [self populateTestData];
    
    MFImagePonso *imagePonsoToSave = [[MFImagePonso alloc] initWithAlbumId:@"albumId1" artistId:nil height:@200 width:@100 url:@"url1"];
    
    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    MFImageEntity *imageEntity = [self fetchImageWithAlbumId:@"albumId1" url:@"url1"];
    XCTAssertNotNil(imageEntity);
    [testObject saveImagePonso:imagePonsoToSave];
    NSArray *images = [self fetchImagesWithAlbumId:@"albumId1" url:@"url1"];
    
    XCTAssertEqualObjects(@(images.count), @1);
    XCTAssertEqualObjects([images[0] albumId], @"albumId1");
    XCTAssertNil([images[0] artistId]);
    XCTAssertEqualObjects([(MFImageEntity *)images[0] height], @200);
    XCTAssertEqualObjects([(MFImageEntity *)images[0] width], @200);
    XCTAssertEqualObjects([(MFImageEntity *)images[0] url], @"url1");
}

//TODO:
- (void)test_whenRequestToSaveImagePonsoWithNonNilArtistIdANDNonNilAlbumIdANDImageInDatabase_thenDoNotSave
{
    [self populateTestData];
    
//        [self addNewEntityWithArtistId:@"artistId1" albumId:nil height:@64 width:@54 url:@"url2"];
    MFImagePonso *imagePonsoToSave = [[MFImagePonso alloc] initWithAlbumId:@"s" artistId:@"artistId1" height:@200 width:@100 url:@"url2"];

    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    MFImageEntity *imageEntity = [self fetchImageWithArtistId:@"artistId1" url:@"url2"];
    XCTAssertNotNil(imageEntity);
    [testObject saveImagePonso:imagePonsoToSave];
    NSArray *images = [self fetchImagesWithArtistId:@"artistId1" url:@"url2"];
    
    XCTAssertEqualObjects(@(images.count), @1);
    XCTAssertEqualObjects([images[0] albumId], nil);
    //XCTAssertNil([images[0] artistId]);
    XCTAssertEqualObjects([(MFImageEntity *)images[0] height], @64);
    XCTAssertEqualObjects([(MFImageEntity *)images[0] width], @54);
    XCTAssertEqualObjects([(MFImageEntity *)images[0] url], @"url2");
}

- (void)test_whenRequestToFetchImagesWithArtistIdANDNoneInDatabase_thenReturnAsExpected
{
    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSSet *actual = [testObject fetchImagesWithArtistId:@"nonExistantId"];
    XCTAssertNil(actual);
}

- (void)test_whenRequestToFetchImagesWithAlbumIdANDNoneInDatabase_thenReturnAsExpected
{
    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    XCTAssertNil([testObject fetchImagesWithAlbumId:@"nonExistantId"]);
}

- (void)test_whenRequestToFetchImagesWithAlbumIdANDMultipleInDatabase_thenReturnAsExpected
{
    [self populateTestData];
    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSSet *actual = [testObject fetchImagesWithAlbumId:@"albumId2"];
    NSSortDescriptor *urlSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *sortedActualResult = [NSArray arrayWithArray:[[actual allObjects] sortedArrayUsingDescriptors:@[urlSortDescriptor]]];
    XCTAssertEqualObjects(@(sortedActualResult.count), @2);
    XCTAssertTrue([sortedActualResult[0] isKindOfClass:[MFImagePonso class]]);
    XCTAssertTrue([sortedActualResult[1] isKindOfClass:[MFImagePonso class]]);
    XCTAssertEqualObjects([sortedActualResult[0] albumId], @"albumId2");
    XCTAssertEqualObjects([sortedActualResult[1] albumId], @"albumId2");
    XCTAssertEqualObjects([sortedActualResult[0] artistId], @"artistId1");
    XCTAssertNil([sortedActualResult[1] artistId]);
    XCTAssertEqualObjects([sortedActualResult[0] height], @50);
    XCTAssertEqualObjects([sortedActualResult[1] height], @50);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[0] width], @50);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[1] width], @50);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[0] url], @"url4");
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[1] url], @"url7");
}
- (void)test_whenRequestToFetchImagesWithArtistIdANDMultipleInDatabase_ThenReturnAsExpected
{
    [self populateTestData];
    testObject = [[MFCoreDataImagePersistence alloc] initWithManagedObjectContextProvider:mocProvider];
    NSSet *actual = [testObject fetchImagesWithArtistId:@"artistId1"];
    NSSortDescriptor *urlSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *sortedActualResult = [NSArray arrayWithArray:[[actual allObjects] sortedArrayUsingDescriptors:@[urlSortDescriptor]]];
    XCTAssertEqualObjects(@(sortedActualResult.count), @3);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[0] url], @"url2");
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[1] url], @"url3");
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[2] url], @"url4");
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[0] width], @54);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[1] width], @60);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[2] width], @50);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[0] height], @64);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[1] height], @60);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[2] height], @50);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[0] artistId], @"artistId1");
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[1] artistId], @"artistId1");
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[2] artistId], @"artistId1");
    XCTAssertNil([sortedActualResult[0] albumId]);
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[1] albumId], @"albumId1");
    XCTAssertEqualObjects([(MFImagePonso *)sortedActualResult[2] albumId], @"albumId2");
    XCTAssertTrue([sortedActualResult[0] isKindOfClass:[MFImagePonso class]]);
    XCTAssertTrue([sortedActualResult[1] isKindOfClass:[MFImagePonso class]]);
    XCTAssertTrue([sortedActualResult[2] isKindOfClass:[MFImagePonso class]]);
    
}




@end