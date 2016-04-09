@protocol MFArtist;
@protocol MFTrack;
@protocol MFImage;

@protocol MFAlbum <NSObject>

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