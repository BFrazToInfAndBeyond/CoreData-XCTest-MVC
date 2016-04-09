@interface MFArtistPonso : NSObject <MFArtist>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithId:(NSString *)id name:(NSString *)name popularity:(NSNumber *)popularity isFavorite:(NSNumber *)isFavorite albums:(NSSet *)albums images:(NSSet *)images relatedArtists:(NSSet *)relatedArtists tracks:(NSSet *)tracks genres:(NSString *)genres;

@end

