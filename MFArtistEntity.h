//
//  MFArtistEntity.h
//  MayFly
//
//  Created by FRAZIER, BRYCE on 12/13/14.
//  Copyright (c) 2014 mrbrycefrazier at gmail dot com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFAlbumEntity, MFArtistEntity, MFImageEntity, MFTrackEntity;

@interface MFArtistEntity : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * genres;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) NSSet *albums;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *relatedArtists;
@property (nonatomic, retain) NSSet *tracks;

@end

@interface MFArtistEntity (CoreDataGeneratedAccessors)

- (void)addAlbumObject:(MFAlbumEntity *)value;
- (void)removeAlbumObject:(MFAlbumEntity *)value;
- (void)addAlbum:(NSSet *)values;
- (void)removeAlbum:(NSSet *)values;

- (void)addImagesObject:(MFImageEntity *)value;
- (void)removeImagesObject:(MFImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addRelatedArtistsObject:(MFArtistEntity *)value;
- (void)removeRelatedArtistsObject:(MFArtistEntity *)value;
- (void)addRelatedArtists:(NSSet *)values;
- (void)removeRelatedArtists:(NSSet *)values;

- (void)addTracksObject:(MFTrackEntity *)value;
- (void)removeTracksObject:(MFTrackEntity *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;

@end
