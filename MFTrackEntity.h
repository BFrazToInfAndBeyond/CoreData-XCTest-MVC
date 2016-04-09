//
//  MFTrackEntity.h
//  MayFly
//
//  Created by FRAZIER, BRYCE on 12/13/14.
//  Copyright (c) 2014 mrbrycefrazier at gmail dot com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFAlbumEntity, MFArtistEntity;

@interface MFTrackEntity : NSManagedObject

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSNumber * explicit;
@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * disc_number;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * track_number;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *artists;
@end

@interface MFTrackEntity (CoreDataGeneratedAccessors)

- (void)addArtistsObject:(MFArtistEntity *)value;
- (void)removeArtistsObject:(MFArtistEntity *)value;
- (void)addArtists:(NSSet *)values;
- (void)removeArtists:(NSSet *)values;

@end
