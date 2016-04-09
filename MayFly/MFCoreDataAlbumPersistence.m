#import <CoreData/CoreData.h>
#import "MFCoreDataAlbumPersistence.h"
#import "MFArtistEntity.h"
#import "MFTrackEntity.h"
#import "MFImageEntity.h"
#import "MFAlbumPonso.h"
#import "MFTrackPonso.h"
#import "MFImagePonso.h"
#import "MFArtistPonso.h"


@interface MFCoreDataAlbumPersistence()

@property (nonatomic, readonly) id<MFCoreDataMOCProvider> mocProvider;

@end

@implementation MFCoreDataAlbumPersistence

- (instancetype) initWithManagedObjectContextProvider:(id<MFCoreDataMOCProvider>)mocProvider{
    if(self = [super init]){
        _mocProvider = mocProvider;
    }
    return self;
}

- (NSSet *)fetchAlbumPonsosWithArtistId:(NSString *)artistId
{
    return nil;
}

- (MFAlbumPonso *)fetchAlbumPonsoWithAlbumId:(NSString*)albumId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", albumId];
    NSError *error = nil;
    MFAlbumEntity *albumEntity = [[self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
    if (albumEntity == nil) {
        return nil;
    }
    MFAlbumPonso *album = [[MFAlbumPonso alloc] initWithId:albumEntity.id name:albumEntity.name isFavorite:albumEntity.isFavorite popularity:albumEntity.popularity explicit:albumEntity.explicit release_date:albumEntity.release_date release_date_precision:albumEntity.release_date_precision artists:albumEntity.artists images:nil tracks:nil];
    return album;
}

- (void)favoriteToggledWithAlbumId:(NSString *)albumId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", albumId];
    NSError *error = nil;
    MFAlbumEntity *albumEntity = [[self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] firstObject];
    albumEntity.isFavorite = ([albumEntity.isFavorite isEqualToNumber: @1]) ? @0 : @1;
    error = nil;
    [self.mocProvider.mainContext save:&error];
}
- (BOOL)isFavoriteWithAlbumId:(NSString *)albumId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@ AND isFavorite == YES", albumId];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];

    return fetchedObjects.count;
}

- (void)saveAlbumPonso:(MFAlbumPonso *)albumPonso
{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", albumPonso.id];
    
    NSError *error;
    if ([self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error].count == 0) {
        
        MFAlbumEntity *albumEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:self.mocProvider.mainContext];
        albumEntity.id = albumPonso.id;
        albumEntity.explicit = albumPonso.explicit;
        albumEntity.isFavorite = albumPonso.isFavorite;
        albumEntity.name = albumPonso.name;
        albumEntity.popularity = albumPonso.popularity;
        albumEntity.release_date = albumPonso.release_date;
        albumEntity.release_date_precision = albumPonso.release_date_precision;
        
        for (id<MFImage> image in albumPonso.images) {
            MFImageEntity *imageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.mocProvider.mainContext];
            
            imageEntity.height = image.height;
            imageEntity.width = image.width;
            imageEntity.albumId = albumPonso.id;
            imageEntity.url = image.url;
            [albumEntity addImagesObject:imageEntity];
        }
        
        for (id<MFArtist> artist in albumPonso.artists) {
            MFArtistEntity *artistEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.mocProvider.mainContext];
            artistEntity.id = artist.id;
        
            artistEntity.name = artist.name;
            [albumEntity addArtistsObject:artistEntity];
        }
        
        for (id<MFTrack> track in albumPonso.tracks) {
            MFTrackEntity *trackEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:self.mocProvider.mainContext];
            trackEntity.id = track.id;
            trackEntity.name = track.name;
            trackEntity.disc_number = track.disc_number;
            trackEntity.track_number = track.track_number;
            trackEntity.url = track.url;
            trackEntity.isFavorite = track.isFavorite;
            trackEntity.explicit = track.explicit;
            trackEntity.albumId = track.albumId;
            trackEntity.albumName = track.albumName;
            for (id<MFArtist> artist in track.artists) {
                MFArtistEntity *trackArtist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.mocProvider.mainContext];
                trackArtist.id = artist.id;
                trackArtist.name = artist.name;
                //TODO: maybe add images to artist...
                [trackEntity addArtistsObject:trackArtist];
            }
            
            
            [albumEntity addTracksObject:trackEntity];
        }
        NSError *error = nil;
        [self.mocProvider.mainContext save:&error];
        if (error) {
            NSLog(@"There was an error saving album with message %@", error.localizedDescription);
        }
        
    }
    
    
}

- (id<MFAlbum>)albumWithAlbumId:(NSString *)albumId{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", albumId];
    
    NSError *error;
    id<MFAlbum> album = [[self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error] lastObject];
    return album;
}

- (NSArray *)fetchAlbumsWithSearchText:(NSString *)searchText searchScope:(MFSearchScope)searchScope{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    NSError *error;
    
    NSMutableArray *predicates = [NSMutableArray array];
    
    if (searchScope == MFSearchScopeFavorite) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"isFavorite == YES"]];
    }
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    if (searchText.length > 0) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"name contains [c] %@", searchText]];
    }
    
    fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[predicates copy]];
    NSArray * fetchedObjects = [self.mocProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    return [self convertToAlbumPonsosFromAlbumEntities:fetchedObjects];
}

- (NSArray *)convertToAlbumPonsosFromAlbumEntities:(NSArray *)albumEntities
{
    NSMutableArray *albumPonsos = [NSMutableArray array];
    for (MFAlbumEntity *albumEntity in albumEntities) {
        NSMutableSet *artists = [NSMutableSet set];
        for (MFArtistEntity *artist in albumEntity.artists) {
            MFArtistPonso *artistPonsoToAdd = [[MFArtistPonso alloc] initWithId:artist.id name:artist.name popularity:artist.popularity isFavorite:artist.isFavorite albums:artist.albums images:artist.images relatedArtists:artist.relatedArtists tracks:artist.tracks genres:artist.genres];
            [artists addObject:artistPonsoToAdd];
        }
        NSMutableSet *images = [NSMutableSet set];
        for (MFImageEntity *imageEntity in albumEntity.images) {
            MFImagePonso *imagePonsoToAdd = [[MFImagePonso alloc] initWithAlbumId:imageEntity.albumId artistId:imageEntity.artistId height:imageEntity.height width:imageEntity.width url:imageEntity.url];
            [images addObject:imagePonsoToAdd];
        }
        
        NSMutableSet *tracks = [NSMutableSet set];
        for (MFTrackEntity *trackEntity in albumEntity.tracks) {
            NSMutableSet *trackArtists = [NSMutableSet set];
            for (MFArtistEntity *artistEntity in trackEntity.artists){
                MFArtistPonso *trackArtist = [[MFArtistPonso alloc] initWithId:artistEntity.id name:artistEntity.name popularity:artistEntity.popularity isFavorite:trackEntity.isFavorite albums:nil images:nil relatedArtists:nil tracks:nil genres:artistEntity.genres];
                [trackArtists addObject:trackArtist];
            }
            
            MFTrackPonso *trackPonsoToAdd = [[MFTrackPonso alloc] initWithId:trackEntity.id name:trackEntity.name albumId:trackEntity.albumId albumName:trackEntity.albumName explicit:trackEntity.explicit isFavorite:trackEntity.isFavorite disc_number:trackEntity.disc_number track_number:trackEntity.track_number url:trackEntity.url popularity:trackEntity.popularity artists:[trackArtists copy] images:[images copy]];
            [tracks addObject:trackPonsoToAdd];
        }
        MFAlbumPonso *albumPonsoToAdd = [[MFAlbumPonso alloc] initWithId:albumEntity.id name:albumEntity.name isFavorite:albumEntity.isFavorite popularity:albumEntity.popularity explicit:albumEntity.explicit release_date:albumEntity.release_date release_date_precision:albumEntity.release_date_precision artists:[artists copy] images:[images copy] tracks:[tracks copy]];
        [albumPonsos addObject:albumPonsoToAdd];
    }
    
    return [albumPonsos copy];
}

- (NSArray *)imagesWithAlbumId:(NSString *)albumId{
    return nil;
}
- (NSArray *)tracksWithAlbumId:(NSString *)albumId{
    return nil;
}


@end