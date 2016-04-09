#import "MFCoreDataPersistenceFactory.h"
#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataInMemoryPSCProvider.h"
#import "MFCoreDataSqlitePSCProvider.h"
#import "MFCoreDataArtistPersistence.h"
#import "MFCoreDataAlbumPersistence.h"
#import "MFCoreDataTrackPersistence.h"
#import "MFCoreDataImagePersistence.h"

@interface MFCoreDataPersistenceFactoryTests : XCTestCase
{
    MFCoreDataPersistenceFactory *testObject;
    id<MFCoreDataMOCProvider> mocProvider;
    NSURL *dataStoreUrl;
}
@end

@implementation MFCoreDataPersistenceFactoryTests

- (void)setUp {
    [super setUp];

    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *dataStoreDirUrl = [NSURL fileURLWithPath:[MFTestUtilityProtectedTemporaryDirectory() stringByAppendingString:[[NSUUID UUID] UUIDString]]];
    
    [fileManager createDirectoryAtURL:dataStoreDirUrl withIntermediateDirectories:YES attributes:nil error:&error];
    
    dataStoreUrl = [dataStoreDirUrl URLByAppendingPathComponent:@"database.sqlite"];
    
    [fileManager createFileAtPath:dataStoreUrl.path contents:nil attributes:nil];
    MFCoreDataSqlitePSCProvider *pscProvider = [[MFCoreDataSqlitePSCProvider alloc] initWithUserStoreURL:dataStoreUrl];
    mocProvider = [[MFCoreDataMOCProvider alloc] initWithStoreProvider:pscProvider];
    
    
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenRequestArtistPersistence_thenFactoryReturnsExpectedInterface{
    
    testObject = [[MFCoreDataPersistenceFactory alloc] initWithMOCProvider:mocProvider];
    
    id objectReturned = [testObject artistPersistence];
    XCTAssertTrue([objectReturned conformsToProtocol:@protocol(MFArtistPersistence) ]);
    XCTAssertTrue([objectReturned isKindOfClass:[MFCoreDataArtistPersistence class]]);
}

- (void)test_whenRequestAlbumPersistence_thenFactoryReturnsExpectedInterface{
    testObject = [[MFCoreDataPersistenceFactory alloc] initWithMOCProvider:mocProvider];
    
    id<MFAlbumPersistence> objectReturned = [testObject albumPersistence];
    XCTAssertTrue([objectReturned isKindOfClass:[MFCoreDataAlbumPersistence class]]);
}

- (void)test_whenRequestTrackPersistence_thenFactoryReturnsExpectedInterface{
    testObject = [[MFCoreDataPersistenceFactory alloc] initWithMOCProvider:mocProvider];
    
    id<MFTrackPersistence> objectReturned = [testObject trackPersistence];
    XCTAssertTrue([objectReturned isKindOfClass:[MFCoreDataTrackPersistence class]]);
}

- (void)test_whenRequestImagePersistence_thenFactoryReturnsExpectedInterface {
    testObject = [[MFCoreDataPersistenceFactory alloc] initWithMOCProvider:mocProvider];
    id<MFImagePersistence> objectReturned = [testObject imagePersistence];
    XCTAssertTrue([objectReturned isKindOfClass:[MFCoreDataImagePersistence class]]);
}
@end
