@protocol MFAlbum;
@protocol MFArtist;

@protocol MFTrack <NSObject>

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSNumber * explicit;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * disc_number;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * track_number;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *artists;
@property (nonatomic, retain) NSNumber *popularity;



@end