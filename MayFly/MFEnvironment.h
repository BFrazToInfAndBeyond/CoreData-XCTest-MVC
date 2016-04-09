#import <Foundation/Foundation.h>


@interface MFEnvironment : NSObject

+ (NSString *)baseURLString;

+ (NSURL *)baseURL;

+ (NSString *)bundleVersion;


@end