#import "MFEnvironment.h"
#import <Foundation/Foundation.h>
@implementation MFEnvironment

+ (NSString *)baseURLString
{
    return @"https://api.spotify.com";
    //return self.dictionaryForCurrentEnvironment[@"baseURL"];
    
}

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:[self baseURLString]];
}

+ (NSString *)bundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSDictionary *)dictionaryForCurrentEnvironment
{
    NSString *environmentsPlistPath = [[NSBundle mainBundle] pathForResource:@"Environments" ofType:@"plist"];
    
    NSDictionary *environments = [[NSDictionary alloc] initWithContentsOfFile:environmentsPlistPath];
    
    NSString *configuration = [[NSBundle mainBundle] infoDictionary][@"Configuration"];
    NSDictionary *environment = environments[configuration];
    return environment;
}


@end
