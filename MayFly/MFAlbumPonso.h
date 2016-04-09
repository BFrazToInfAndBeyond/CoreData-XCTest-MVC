@interface MFAlbumPonso : NSObject <MFAlbum>

- (id)init UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) NSUInteger numberOfTracks;

- (instancetype)initWithId:(NSString *)id name:(NSString *)name isFavorite:(NSNumber *)isFavorite popularity:(NSNumber *)popularity explicit:(NSNumber *)explicit release_date:(NSString *)release_date release_date_precision:(NSString *)release_date_precision artists:(NSSet *)artists images:(NSSet *)images tracks:(NSSet *)tracks;

- (instancetype)initWithId:(NSString *)id name:(NSString *)name isFavorite:(NSNumber *)isFavorite popularity:(NSNumber *)popularity explicit:(NSNumber *)explicit release_date:(NSString *)release_date release_date_precision:(NSString *)release_date_precision artists:(NSSet *)artists images:(NSSet *)images tracks:(NSSet *)tracks numberOfTracks:(NSUInteger)numberOfTracks;

@end