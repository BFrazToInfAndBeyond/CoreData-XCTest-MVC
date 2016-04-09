@protocol MFAlbum;
@protocol MFTrack;
@protocol MFImage;

@protocol MFArtist <NSObject>

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