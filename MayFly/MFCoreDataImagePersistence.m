#import "MFCoreDataImagePersistence.h"
#import <CoreData/CoreData.h>
#import "MFImageEntity.h"
@interface MFCoreDataImagePersistence()

@property (nonatomic, readonly) id<MFCoreDataMOCProvider> mocProvider;


@end

@implementation MFCoreDataImagePersistence

- (instancetype) initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider{
    if(self = [super init]){
        _mocProvider = mocProvider;
    }
    return self;
}

- (void)saveImagePonso:(MFImagePonso *)imagePonso
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url == %@", imagePonso.url];
    NSError *error = nil;
    if ([self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error].count == 0) {
        MFImageEntity *imageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.mocProvider.mainContext];
        
        imageEntity.albumId = imagePonso.albumId;
        imageEntity.artistId = imagePonso.artistId;
        imageEntity.width = imagePonso.width;
        imageEntity.height = imagePonso.height;
        imageEntity.url = imagePonso.url;
        NSError *error = nil;
        [self.mocProvider.mainContext save:&error];
    }
}

- (NSSet *)fetchImagesWithAlbumId:(NSString *)albumId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"albumId == %@", albumId];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        return nil;
    }
    NSMutableSet *imagePonsos = [NSMutableSet set];
    for (MFImageEntity *entity in fetchedObjects){
        MFImagePonso *imagePonsoToAdd = [[MFImagePonso alloc] initWithAlbumId:entity.albumId artistId:entity.artistId height:entity.height width:entity.width url:entity.url];
        [imagePonsos addObject:imagePonsoToAdd];
    }
    
    return [imagePonsos copy];
}

- (NSSet *)fetchImagesWithArtistId:(NSString *)artistId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"artistId == %@", artistId];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        return nil;
    }
    NSMutableSet *imagePonsos = [NSMutableSet set];
    for (MFImageEntity *entity in fetchedObjects){
        MFImagePonso *imagePonsoToAdd = [[MFImagePonso alloc] initWithAlbumId:entity.albumId artistId:entity.artistId height:entity.height width:entity.width url:entity.url];
        [imagePonsos addObject:imagePonsoToAdd];
    }
    
    return [imagePonsos copy];

}

@end