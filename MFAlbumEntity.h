//
//  MFAlbumEntity.h
//  MayFly
//
//  Created by FRAZIER, BRYCE on 12/13/14.
//  Copyright (c) 2014 mrbrycefrazier at gmail dot com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFArtistEntity, MFImageEntity, MFTrackEntity;

@interface MFAlbumEntity : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * explicit;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) NSString * release_date;
@property (nonatomic, retain) NSString * release_date_precision;
@property (nonatomic, retain) NSSet *artists;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *tracks;
@end

@interface MFAlbumEntity (CoreDataGeneratedAccessors)

- (void)addArtistsObject:(MFArtistEntity *)value;
- (void)removeArtistsObject:(MFArtistEntity *)value;
- (void)addArtists:(NSSet *)values;
- (void)removeArtists:(NSSet *)values;

- (void)addImagesObject:(MFImageEntity *)value;
- (void)removeImagesObject:(MFImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addTracksObject:(MFTrackEntity *)value;
- (void)removeTracksObject:(MFTrackEntity *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;

@end
