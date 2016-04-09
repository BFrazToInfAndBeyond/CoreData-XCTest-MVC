#import <CoreData/CoreData.h>
#import "MFCoreDataArtistPersistence.h"
#import "MFArtistEntity.h"
#import "MFImageEntity.h"
#import "MFImagePonso.h"


@interface MFCoreDataArtistPersistence()

@property (nonatomic, readonly) id<MFCoreDataMOCProvider>mocProvider;

@end

@implementation MFCoreDataArtistPersistence

- (instancetype)initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider{
    if (self = [super init]) {
        _mocProvider = mocProvider;
    }
    return  self;
}

- (void)favoriteToggleWithArtistId:(NSString *)artistId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@ AND isFavorite != nil",artistId];
    NSError *error = nil;
    NSArray * fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    MFArtistEntity *updatedArtistEntity = [fetchedObjects firstObject];
    updatedArtistEntity.isFavorite = ([updatedArtistEntity.isFavorite isEqualToNumber:@1]) ? @0 : @1;
    error = nil;
    [self.mocProvider.mainContext save:&error];
}

- (BOOL)isFavoriteWithArtistId:(NSString *)artistId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@ AND isFavorite == YES", artistId];
    NSError *error = nil;
    return [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error].count;
}

- (void)saveArtistPonso:(MFArtistPonso *)artist
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@ AND isFavorite != nil", artist.id];
    NSError *error;
    
    NSArray *fetchedArtists =[self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedArtists.count == 0) {
        MFArtistEntity *artistEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.mocProvider.mainContext];
        artistEntity.id = artist.id;
        artistEntity.name = artist.name;
        artistEntity.isFavorite = artist.isFavorite;
        artistEntity.popularity = artist.popularity;
        artistEntity.genres = artist.genres;
        
        for (id<MFImage> image in artist.images) {
            MFImageEntity *imageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.mocProvider.mainContext];
            
            imageEntity.height = image.height;
            imageEntity.width = image.width;
            imageEntity.artistId = artist.id;
            imageEntity.url = image.url;
            [artistEntity addImagesObject:imageEntity];
        }
        NSError *error;
        [self.mocProvider.mainContext save:&error];
        if (error) {
            NSLog(@"there was an error saving artistEntity!!! with message %@", error.localizedDescription);
        }
    }
}

-(id<MFArtist>)artistWithArtistId:(NSString *)artistId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@ AND isFavorite != nil", artistId];
    NSError *error;
    id<MFArtist> artist = [[self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] lastObject];
    return artist;
}

- (NSArray *)fetchArtistsWithSearchText:(NSString *)searchText searchScope:(MFSearchScope)searchScope
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSMutableArray *predicates = [NSMutableArray array];
    
    if(searchScope == MFSearchScopeFavorite){
        NSPredicate *searchScopePredicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
        [predicates addObject:searchScopePredicate];
    }
    
    if(searchText.length > 0){
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        [predicates addObject:namePredicate];
    }
    
    fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    NSError *error;
    NSArray *fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    return [self convertToArtistPonsosWithArtistEntities:fetchedObjects];

}

- (NSArray *)convertToArtistPonsosWithArtistEntities:(NSArray *)artistEntities
{
    NSMutableArray *artistPonsosToReturn = [NSMutableArray array];
    for (MFArtistEntity *artistEntity in artistEntities) {
        NSMutableSet *imagesToAdd = [NSMutableSet set];
        for (MFImageEntity *imageEntity in artistEntity.images) {
            MFImagePonso *imagePonsoToAdd = [[MFImagePonso alloc] initWithAlbumId:imageEntity.albumId artistId:imageEntity.artistId height:imageEntity.height width:imageEntity.width url:imageEntity.url];
            [imagesToAdd addObject:imagePonsoToAdd];
        }
        MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:artistEntity.id name:artistEntity.name popularity:artistEntity.popularity isFavorite:artistEntity.isFavorite albums:nil images:[imagesToAdd copy] relatedArtists:nil tracks:nil genres:artistEntity.genres];
        [artistPonsosToReturn addObject:artistPonso];
    }
    return [artistPonsosToReturn copy];
}

- (NSArray *)albumsWithArtistId:(NSString *)artistId
{
    return nil;
}

- (NSArray *)imagesWithArtistId:(NSString *)artistId
{
    return nil;
}

- (NSArray *)relatedArtistsWithArtistId:(NSString *)artistId
{
    return nil;
}
@end