#import "MFAlbumEntity.h"
#import "MFAlbum.h"
#import "MFArtistEntity.h"
#import "MFArtist.h"
#import "MFTrackEntity.h"
#import "MFTrack.h"
#import "MFImageEntity.h"
#import "MFImage.h"



@interface MFAlbumEntity (Mapping) <MFAlbum>

@end

@interface MFArtistEntity (Mapping) <MFArtist>

@end

@interface MFTrackEntity (Mapping) <MFTrack>

@end

@interface MFImageEntity (Mapping) <MFImage>

@end
