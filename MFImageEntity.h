//
//  MFImageEntity.h
//  MayFly
//
//  Created by FRAZIER, BRYCE on 12/13/14.
//  Copyright (c) 2014 mrbrycefrazier at gmail dot com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MFImageEntity : NSManagedObject

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * width;

@end
