#import "MFFileLocationProvider.h"

@implementation MFFileLocationProvider

- (NSURL *)storeForApp
{
    NSURL *userStoreDirectory = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    userStoreDirectory = [userStoreDirectory URLByAppendingPathComponent:@"mayfly"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:userStoreDirectory.path]) {
        [fileManager createDirectoryAtURL:userStoreDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [userStoreDirectory URLByAppendingPathComponent:@"database.sqlite"];
}

@end