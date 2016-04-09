#import "MFQueryByNameServiceClient.h"
#import "MFTrackPonso.h"
#import "MFAlbumPonso.h"
#import "MFArtistPonso.h"
#import "MFImagePonso.h"


@implementation MFQueryByNameServiceClient

- (void)downloadEntityWithQueryByName:(NSString *)name type:(MFEntityScope)type
{
    MFEndpoint *endpoint = [MFEndpoint endpointForQueryingSpotifyByName:name type:type];
    [self makeServiceCallForEndoint:endpoint
                      responseBlock:^(id response, NSError *error) {
								if(error) {
                                    [self.delegate downloadFailedForQuery:name];
                                } else {
                                    
                                    [self.delegate downloadSucceededForQueryWithSerializedResponse:[self serializeDataWithResponse:response type:type]];
                                
                                }
                    }   
                          requestId:endpoint.urlString];
}

//TODO:test this
- (NSArray *)serializeDataWithResponse:(NSDictionary *)response type:(MFEntityScope)type
{
    if (type == MFArtistScope) {
        return [self transformArtistsWithResponse:response[@"artists"]];
    } else if (type == MFAlbumScope) {
        return [self transformAlbumsWithResponse:response[@"albums"]];
    } else if (type == MFTrackScope) {
        return [self transformTracksWithResponse:response[@"tracks"]];
    }
    return nil;
}

- (NSArray *)transformArtistsWithResponse:(NSDictionary *)response{
    NSMutableArray *serializedPonsos = [NSMutableArray array];
    for (NSDictionary *artist in response[@"items"]) {
        NSMutableSet *artistsImages = [NSMutableSet set];
        NSString *artistId = artist[@"id"];
        for (NSDictionary *artistImage in artist[@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:nil artistId:artistId height:artistImage[@"height"] width:artistImage[@"width"] url:artistImage[@"url"]];
            [artistsImages addObject:imageToAdd];
        }
        MFArtistPonso *artistPonso = [[MFArtistPonso alloc]initWithId:artist[@"id"] name:artist[@"name"] popularity:artist[@"popularity"] isFavorite:@0 albums:nil images:[artistsImages copy] relatedArtists:nil tracks:nil genres:[self convertStringProperty:[artist[@"genres"] componentsJoinedByString:@", "]]];
        [serializedPonsos addObject:artistPonso];
    }
    
    return [serializedPonsos copy];
}

- (NSArray *)transformAlbumsWithResponse:(NSDictionary *)response{
    NSMutableArray *serializedPonsos = [NSMutableArray array];
    for (NSDictionary *album in response[@"items"]) {
        NSMutableSet *albumsImages = [NSMutableSet set];
        NSString *albumId = album[@"id"];
        for (NSDictionary *albumImage in album[@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:albumId artistId:nil height:albumImage[@"height"] width:albumImage[@"width"] url:albumImage[@"url"]];
            [albumsImages addObject:imageToAdd];
        }
        MFAlbumPonso *albumPonso = [[MFAlbumPonso alloc] initWithId:albumId name:album[@"name"] isFavorite:@0 popularity:nil explicit:nil release_date:nil release_date_precision:nil artists:nil images:[albumsImages copy] tracks:nil];
        [serializedPonsos addObject:albumPonso];
    }
    
    return [serializedPonsos copy];
}

- (NSArray *)transformTracksWithResponse:(NSDictionary *)response {
    NSMutableArray *serializedPonsos = [NSMutableArray array];
    for (NSDictionary *track in response[@"items"]) {
        
        NSMutableSet *trackImages = [NSMutableSet set];
        NSString *albumId = track[@"album"][@"id"];
        
        NSMutableSet *trackArtists = [NSMutableSet set];
        for (NSDictionary *trackArtist in track[@"artists"]) {
            MFArtistPonso *artistToAdd = [[MFArtistPonso alloc] initWithId:trackArtist[@"id"] name:[self convertStringProperty:trackArtist[@"name"]] popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil genres:[self convertStringProperty:trackArtist[@"genres"]]];
            [trackArtists addObject:artistToAdd];
        }
        
        for (NSDictionary *trackImage in track[@"album"][@"images"]) {
            MFImagePonso *imageToAdd = [[MFImagePonso alloc] initWithAlbumId:albumId artistId:nil height:trackImage[@"height"] width:trackImage[@"width"] url:[self convertStringProperty:trackImage[@"url"]]];
            [trackImages addObject:imageToAdd];
        }
        
        
        MFTrackPonso *trackPonso = [[MFTrackPonso alloc] initWithId:track[@"id"] name:[self convertStringProperty:track[@"name"]] albumId:albumId albumName:[self convertStringProperty:track[@"album"][@"name"]] explicit:track[@"explicit"] isFavorite:@0 disc_number:track[@"disc_number"] track_number:track[@"track_number"] url:[self convertStringProperty:track[@"preview_url"]] popularity:track[@"popularity"] artists:[trackArtists copy]  images:[trackImages copy]];
        [serializedPonsos addObject:trackPonso];
    }
    
    
    
    return [serializedPonsos copy];
}


//- (NSArray *)setupAlbumPonsos
//{
//    //album1
//    MFImagePonso *imagePonso1 = [self newImagePonsoWithHeight:@300 width:@300 artistId:nil url:@"https://i.scdn.co/image/cf11442e18cea9231a08aa730df0532eef5c9a8a" albumId:@"0eFHYz8NmK75zSplL5qlfM"];
//    MFImagePonso *imagePonso2 = [self newImagePonsoWithHeight:@64 width:@64 artistId:nil url:@"https://i.scdn.co/image/f6500569e0b98137a6d26eee33286c5bb9ff623c" albumId:@"0eFHYz8NmK75zSplL5qlfM"];
//    MFAlbumPonso *albumPonso = [self newAlbumPonsoWithId:@"0eFHYz8NmK75zSplL5qlfM" explicit:nil isFavorite:@0 name:@"The Resistance" popularity:nil release_date:nil release_date_precision:nil artists:nil images:[NSSet setWithObjects:imagePonso1, imagePonso2, nil] tracks:nil];
//    
//    //album2
//    MFImagePonso *imagePonso3 = [self newImagePonsoWithHeight:@300 width:@300 artistId:nil url:@"https://i.scdn.co/image/acf6bd01fe17c53a7ef0b92fe52d3590d57df13e" albumId:@"0lw68yx3MhKflWFqCsGkIs"];
//    MFImagePonso *imagePonso4 = [self newImagePonsoWithHeight:@64 width:@64 artistId:nil url:@"https://i.scdn.co/image/6c751d61a730ab14dca55b1c7d3ce1f7f838aa23" albumId:@"0lw68yx3MhKflWFqCsGkIs"];
//    MFAlbumPonso *albumPonso2 = [self newAlbumPonsoWithId:@"0lw68yx3MhKflWFqCsGkIs" explicit:nil isFavorite:@0 name:@"Black Holes And Revelations" popularity:nil release_date:nil release_date_precision:nil artists:nil images:[NSSet setWithObjects:imagePonso3,imagePonso4, nil] tracks:nil];
//    
//    //album3
//    MFImagePonso *imagePonso5 = [self newImagePonsoWithHeight:@300 width:@300 artistId:nil url:@"https://i.scdn.co/image/b62eae143027e6d5e00c713d06c4529506187bd1" albumId:@"3KuXEGcqLcnEYWnn3OEGy0"];
//    MFImagePonso *imagePonso6 = [self newImagePonsoWithHeight:@64 width:@64 artistId:nil url:@"https://i.scdn.co/image/2b412376036f7bc4394a120b9b7281442a6c2357" albumId:@"3KuXEGcqLcnEYWnn3OEGy0"];
//    MFAlbumPonso *albumPonso3 = [self newAlbumPonsoWithId:@"3KuXEGcqLcnEYWnn3OEGy0" explicit:nil isFavorite:@0 name:@"The 2nd Law" popularity:nil release_date:nil release_date_precision:nil artists:nil images:[NSSet setWithObjects:imagePonso5, imagePonso6, nil] tracks:nil];
//    
//    return @[albumPonso, albumPonso2, albumPonso3];
//}

//- (NSArray *)setupTrackPonsos
//{
//    //track1
//    // don't save album on track. Make it a swipe feature to download it
//    MFImagePonso *imagePonso1 = [self newImagePonsoWithHeight:@300 width:@300 artistId:nil url:@"https://i.scdn.co/image/cf11442e18cea9231a08aa730df0532eef5c9a8a" albumId:@"0eFHYz8NmK75zSplL5qlfM"];
//    MFImagePonso *imagePonso2 = [self newImagePonsoWithHeight:@64 width:@64 artistId:nil url:@"https://i.scdn.co/image/f6500569e0b98137a6d26eee33286c5bb9ff623c" albumId:@"0eFHYz8NmK75zSplL5qlfM"];
//    MFAlbumPonso *albumPonso1 = [self newAlbumPonsoWithId:@"0eFHYz8NmK75zSplL5qlfM" explicit:nil isFavorite:nil name:@"The Resistance" popularity:nil release_date:nil release_date_precision:nil artists:nil images:[NSSet setWithObjects:imagePonso1, imagePonso2, nil] tracks:nil];
//    
//    MFArtistPonso *artistPonso1 = [self newArtistPonsoWithArtistId:@"12Chz98pHFMPJEknJQMWvI" artistName:@"Muse" popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil];
//
//    MFTrackPonso *trackPonso1 = [self newTrackPonsoWithId:@"4VqPOruhp5EdPBeR92t6lQ" name:@"Uprising" track_number:@1 disc_number:@1 url:@"https://p.scdn.co/mp3-preview/4fcb9dc0aa51f0f5e4f95ef550a813a89d9c395d" isFavorite:@0 popularity:@78 explicit:@0 albumId:@"0eFHYz8NmK75zSplL5qlfM" albumName:@"The Resistance" artists:[NSSet setWithObject:artistPonso1] images:[NSSet setWithObjects:imagePonso1, imagePonso2, nil]];
//
//
//
//
//    MFImagePonso *imagePonso3 = [self newImagePonsoWithHeight:@300 width:@300 artistId:nil url:@"https://i.scdn.co/image/b62eae143027e6d5e00c713d06c4529506187bd1" albumId:@"3KuXEGcqLcnEYWnn3OEGy0"];
//    MFImagePonso *imagePonso4 = [self newImagePonsoWithHeight:@64 width:@64 artistId:nil url:@"https://i.scdn.co/image/2b412376036f7bc4394a120b9b7281442a6c2357" albumId:@"3KuXEGcqLcnEYWnn3OEGy0"];
//    MFAlbumPonso *albumPonso2 = [self newAlbumPonsoWithId:@"3KuXEGcqLcnEYWnn3OEGy0" explicit:nil isFavorite:nil name:@"The 2nd Law" popularity:nil release_date:nil release_date_precision:nil artists:nil images:[NSSet setWithObjects:imagePonso3, imagePonso4, nil] tracks:nil];
//    
//    MFArtistPonso *artistPonso2 = [self newArtistPonsoWithArtistId:@"12Chz98pHFMPJEknJQMWvI" artistName:@"Muse" popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil];
//    
//    MFTrackPonso *trackPonso2 = [self newTrackPonsoWithId:@"0c4IEciLCDdXEhhKxj4ThA" name:@"Madness" track_number:@2 disc_number:@1 url:@"https://p.scdn.co/mp3-preview/014c44998d46b5a2e52f9b75d1c28a187247d3c8" isFavorite:@0 popularity:@78 explicit:@0 albumId:@"3KuXEGcqLcnEYWnn3OEGy0" albumName:@"The 2nd Law" artists:[NSSet setWithObject:artistPonso2] images:[NSSet setWithObjects:imagePonso3, imagePonso4, nil]];
//    
//    
//    MFImagePonso *imagePonso5 = [self newImagePonsoWithHeight:@300 width:@300 artistId:nil url:@"https://i.scdn.co/image/acf6bd01fe17c53a7ef0b92fe52d3590d57df13e" albumId:@"0lw68yx3MhKflWFqCsGkIs"];
//    MFImagePonso *imagePonso6 = [self newImagePonsoWithHeight:@64 width:@64 artistId:nil url:@"https://i.scdn.co/image/6c751d61a730ab14dca55b1c7d3ce1f7f838aa23" albumId:@"0lw68yx3MhKflWFqCsGkIs"];
//    MFAlbumPonso *albumPonso3 = [self newAlbumPonsoWithId:@"0lw68yx3MhKflWFqCsGkIs" explicit:nil isFavorite:nil name:@"Black Holes And Revelations" popularity:nil release_date:nil release_date_precision:nil artists:nil images:[NSSet setWithObjects:imagePonso5, imagePonso6, nil] tracks:nil];
//    //TODO: rename url on track to be preview_url
//    MFArtistPonso *artistPonso3 = [self newArtistPonsoWithArtistId:@"12Chz98pHFMPJEknJQMWvI" artistName:@"Muse" popularity:nil isFavorite:nil albums:nil images:nil relatedArtists:nil tracks:nil];
//    MFTrackPonso *trackPonso3 = [self newTrackPonsoWithId:@"3skn2lauGk7Dx6bVIt5DVj" name:@"Starlight" track_number:@2 disc_number:@1 url:@"https://p.scdn.co/mp3-preview/0e946239cd2f8264b27f2ffb1e5ff0718290f679" isFavorite:@0 popularity:@74 explicit:@0 albumId:@"0lw68yx3MhKflWFqCsGkIs" albumName:@"Black Holes And Revelations" artists:[NSSet setWithObject:artistPonso3] images:[NSSet setWithObjects:imagePonso5, imagePonso6, nil]];
//    
//    return @[trackPonso1, trackPonso2, trackPonso3];
//    
//}
//
//- (NSArray *)setupArtistPonsos
//{
//    MFImagePonso *imagePonso1 = [self newImagePonsoWithHeight:@159 width:@200 artistId:@"12Chz98pHFMPJEknJQMWvI" url:@"https://i.scdn.co/image/556bc16088fb5dc7eac18b4ec2bdaa635475e6d5" albumId:nil];
//    
//    MFImagePonso *imagePonso2 = [self newImagePonsoWithHeight:@51 width:@64 artistId:@"12Chz98pHFMPJEknJQMWvI" url:@"https://i.scdn.co/image/589e1010856d245f3d9691ef9052be40325b8982" albumId:nil];
//    MFArtistPonso *artistPonso1 = [self newArtistPonsoWithArtistId:@"12Chz98pHFMPJEknJQMWvI" artistName:@"Muse" popularity:@65 isFavorite:@0 albums:nil images:[NSSet setWithObjects:imagePonso1,imagePonso2, nil] relatedArtists:nil tracks:nil];
//    
//    
//    
//    MFImagePonso *imagePonso3 = [self newImagePonsoWithHeight:@300 width:@300 artistId:@"1zFNYw5kgA7UEKWqNHf1Et" url:@"https://i.scdn.co/image/043c94fbc253c41b81e513218114db5fab18d2c3" albumId:nil];
//    
//    MFImagePonso *imagePonso4 = [self newImagePonsoWithHeight:@64 width:@64 artistId:@"1zFNYw5kgA7UEKWqNHf1Et" url:@"https://i.scdn.co/image/5fd715d4c3e76d4da7cc6207f2a8585713fe793f" albumId:nil];
//    MFArtistPonso *artistPonso2 = [self newArtistPonsoWithArtistId:@"1zFNYw5kgA7UEKWqNHf1Et" artistName:@"Dangerous Muse" popularity:@3 isFavorite:@0 albums:nil images:[NSSet setWithObjects:imagePonso3, imagePonso4, nil] relatedArtists:nil tracks:nil];
//    return @[artistPonso1, artistPonso2];
//}

@end