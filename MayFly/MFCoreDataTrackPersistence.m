#import <CoreData/CoreData.h>
#import "MFCoreDataTrackPersistence.h"
#import "MFArtistEntity.h"
#import "MFArtistPonso.h"

@interface MFCoreDataTrackPersistence()

@property (nonatomic,readonly) id<MFCoreDataMOCProvider> mocProvider;

@end

@implementation MFCoreDataTrackPersistence

- (instancetype)initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider{
    if(self = [super init]){
        _mocProvider = mocProvider;
    }
    return self;
}

- (NSSet *)fetchTrackPonsosWithAlbumId:(NSString *)albumId albumName:(NSString *)albumName
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"albumId == %@", albumId];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        return nil;
    }
    NSMutableSet *trackPonsos = [NSMutableSet set];
    for (MFTrackEntity *entity in fetchedObjects) {
        MFTrackPonso *trackPonsoToAdd = [[MFTrackPonso alloc] initWithId:entity.id name:entity.name albumId:albumId albumName:albumName explicit:entity.explicit isFavorite:entity.isFavorite disc_number:entity.disc_number track_number:entity.track_number url:entity.url popularity:entity.popularity artists:nil images:nil];
        [trackPonsos addObject:trackPonsoToAdd];
    }
    
    return [trackPonsos copy];

}

- (void)favoriteToggledWithTrack:(NSString *)trackId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", trackId];
    NSError *error = nil;
    MFTrackEntity *trackEntity = [[self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
    trackEntity.isFavorite = ([trackEntity.isFavorite isEqualToNumber: @1]) ? @0 : @1;
    error = nil;
    [self.mocProvider.mainContext save:&error];
}

- (BOOL)isFavoriteWithTrackId:(NSString *)trackId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@ AND isFavorite == YES", trackId];
    NSError *error = nil;
    return [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error].count;
}


- (void)saveTrackPonso:(MFTrackPonso *)trackPonso
{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", trackPonso.id];
    
    
    NSError *error;
    if ([self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error].count == 0) {
        
        
        MFTrackEntity *trackEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:self.mocProvider.mainContext];
        trackEntity.albumId = trackPonso.albumId;
        trackEntity.albumName = trackPonso.albumName;
        trackEntity.explicit = trackPonso.explicit;
        trackEntity.isFavorite = trackPonso.isFavorite;
        trackEntity.name = trackPonso.name;
        trackEntity.disc_number = trackPonso.disc_number;
        trackEntity.id = trackPonso.id;
        trackEntity.track_number = trackPonso.track_number;
        trackEntity.url = trackPonso.url;
        trackEntity.popularity = trackPonso.popularity;
        
        
        for (id<MFArtist> artist in trackPonso.artists) {
            MFArtistEntity *artistEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.mocProvider.mainContext];
            artistEntity.id = artist.id;
            artistEntity.name = artist.name;
            [trackEntity addArtistsObject:artistEntity];
        }
        NSError *error;
        [self.mocProvider.mainContext save:&error];
        if (error) {
            NSLog(@"There was an error saving the track with error message %@", error.localizedDescription);
        }

    }
}

- (id<MFTrack>)trackWithTrackId:(NSString *)trackId{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", trackId];
    
    
    NSError *error;
    id<MFTrack> track = [[self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
    return track;
}

- (NSArray *)fetchTracksWithSearchText:(NSString *)searchText searchScope:(MFSearchScope)searchScope{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    
    NSMutableArray *predicates = [NSMutableArray array];
    NSArray *sortDescriptors = [NSArray array];
    
    if(searchText.length == 0){
        sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"albumName" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"track_number" ascending:YES]];
    } else{
        sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        NSPredicate *trackNamePredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        [predicates addObject:trackNamePredicate];
    }
    
    if(searchScope == MFSearchScopeFavorite){
        NSPredicate *favoritePredicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
        [predicates addObject:favoritePredicate];
    }
    
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    NSError *error;
    NSArray *fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    
    return [self convertToTrackPonsosFromTrackEntities:fetchedObjects];
}

- (NSArray *)convertToTrackPonsosFromTrackEntities:(NSArray *)trackEntities {
    NSMutableArray *trackPonsos = [NSMutableArray array];
    for (MFTrackEntity *trackEntity in trackEntities) {
        NSMutableSet *artistPonsos = [NSMutableSet set];
        for (MFArtistEntity *artistEntity in [trackEntity artists]){
            MFArtistPonso *artistPonso = [[MFArtistPonso alloc] initWithId:artistEntity.id name:artistEntity.name popularity:artistEntity.popularity isFavorite:artistEntity.isFavorite albums:artistEntity.albums images:artistEntity.images relatedArtists:artistEntity.relatedArtists tracks:artistEntity.tracks genres:artistEntity.genres];
            [artistPonsos addObject:artistPonso];
        }
        
        MFTrackPonso *trackPonsoToAdd = [[MFTrackPonso alloc] initWithId:trackEntity.id name:trackEntity.name albumId:trackEntity.albumId albumName:trackEntity.albumName explicit:trackEntity.explicit isFavorite:trackEntity.isFavorite disc_number:trackEntity.disc_number track_number:trackEntity.track_number url:trackEntity.url popularity:trackEntity.popularity artists:[artistPonsos copy] images:nil];
        [trackPonsos addObject:trackPonsoToAdd];
    }
    return [trackPonsos copy];
}

@end