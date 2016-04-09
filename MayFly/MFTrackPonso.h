@interface MFTrackPonso : NSObject <MFTrack>

@property (nonatomic) NSSet *images;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithId:(NSString *)id name:(NSString *)name albumId:(NSString *)albumId albumName:(NSString *)albumName explicit:(NSNumber *)explicit isFavorite:(NSNumber *)isFavorite disc_number:(NSNumber *)disc_number track_number:(NSNumber *)track_number url:(NSString *)url popularity:(NSNumber *)popularity artists:(NSSet *)artists images:(NSSet *)images;


@end