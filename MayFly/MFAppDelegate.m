//
//  AppDelegate.m
//  MayFly
//
//  Created by FRAZIER, BRYCE on 12/10/14.
//  Copyright (c) 2014 mrbrycefrazier at gmail dot com. All rights reserved.
//

#import "MFAppDelegate.h"
#import <Spotify/Spotify.h>

//TODO: move this to a session model and presenter
#import "MFFileLocationProvider.h"
#import "MFCoreDataPSCProvider.h"
#import "MFCoreDataSqlitePSCProvider.h"
#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataPersistenceFactory.h"

#import "MFFavoritedSearchViewController.h"
#import "MFSpotifySearchViewController.h"

// Constants
static NSString * const kClientId = @"d578de34c2ef48ae9b9ba5874ef07e3b";
static NSString *const kCallbackURL = @"mayfly-login://callback";
static NSString *const  kTokenSwapURL = @"http://localhost:1234/swap";


@interface MFAppDelegate () <UITabBarControllerDelegate>
@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@property (nonatomic, strong) MFFileLocationProvider *fileLocationProvider;
@property (nonatomic, strong) MFCoreDataPersistenceFactory *persistenceFactory;


@end

@implementation MFAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    _fileLocationProvider = [[MFFileLocationProvider alloc] init];
    MFCoreDataSqlitePSCProvider *pscProvider = [[MFCoreDataSqlitePSCProvider alloc] initWithUserStoreURL:[self.fileLocationProvider storeForApp]];
    MFCoreDataMOCProvider *mocProvider = [[MFCoreDataMOCProvider alloc] initWithStoreProvider:pscProvider];
    _persistenceFactory = [[MFCoreDataPersistenceFactory alloc] initWithMOCProvider:mocProvider];

    MFFavoritedSearchViewController *favoritedSearchViewController = [[MFFavoritedSearchViewController alloc] initWithPersistenceFactory:self.persistenceFactory];

    MFSpotifySearchViewController *spotifySearchViewController = [[MFSpotifySearchViewController alloc] initWithPersistenceFactory:self.persistenceFactory];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Spotify" image:nil selectedImage:nil];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Favorite" image:nil selectedImage:nil];

    spotifySearchViewController.tabBarItem = tabBarItem1;
    favoritedSearchViewController.tabBarItem = tabBarItem2;

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[spotifySearchViewController, favoritedSearchViewController];
    tabBarController.tabBar.hidden = NO;

    self.window.rootViewController = tabBarController;
    tabBarController.delegate = self;

    // Create SPTAuth instance; create login URL and open it
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSURL *loginURL = [auth loginURLForClientId:kClientId declaredRedirectURL:[NSURL URLWithString:kCallbackURL] scopes:@[SPTAuthStreamingScope]];


    // Opening a URL in Safari close to application launch may trigger
    // an iOS bug, so we wait a bit before doing so.
    [application performSelector:@selector(openURL:) withObject:loginURL afterDelay:0.3];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return true;
//    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    [tabViewControllers[toIndex] updateModel];

    return true;
}


// Handle auth callback
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {

    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {

        // Call the token swap service to get a logged in session
        [[SPTAuth defaultInstance]
         handleAuthCallbackWithTriggeredAuthURL:url
         tokenSwapServiceEndpointAtURL:[NSURL URLWithString:kTokenSwapURL]
         callback:^(NSError *error, SPTSession *session) {

             if (error != nil) {
                 NSLog(@"*** Auth error: %@", error);
                 NSLog(@"Start the sinatra server by calling 'ruby spotify_token_swap.rb' in the mayfly directory. Be sure to have all required gems installed. Next, trust certificate. Username and password are: 'bfraz_dev' and 'BETTSc9' respectively. Enjoy!");
                 return;
             }

             // Call the -playUsingSession: method to play a track
             //[self playUsingSession:session];
         }];
        return YES;
    }

    return NO;
}

-(void)playUsingSession:(SPTSession *)session {

    // Create a new player if needed
    if (self.player == nil) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:kClientId];
    }

    [self.player loginWithSession:session callback:^(NSError *error) {

        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }

        [SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:4L1HDyfdGIkACuygktO7T7"]
                         withSession:nil
                            callback:^(NSError *error, SPTAlbum *album) {

                                if (error != nil) {
                                    NSLog(@"*** Album lookup got error %@", error);
                                    return;
                                }
                                [self.player playTrackProvider:album callback:nil];

                            }];
    }];

}

@end
