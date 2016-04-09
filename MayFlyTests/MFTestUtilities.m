#import "MFTestUtilities.h"
#import <Stubble/Stubble.h>

NSString *createTemporaryDirectory(NSString *name) {
    NSString *tempDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    return tempDirectory;
}

NSString *MFTestUtilityTemporaryDirectory() {
    //This is cleared out
    return createTemporaryDirectory(@"MFTesting");
}

NSString *MFTestUtilityProtectedTemporaryDirectory() {
    // This is NOT cleared out
    return createTemporaryDirectory(@"MFTestingProtected");
}

void MFTestUtilityClearTemporaryDirectory() {
    NSArray *tempDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:MFTestUtilityTemporaryDirectory() error:NULL];
    
    for (NSString *filename in tempDirectoryContents) {
        NSString *path = [MFTestUtilityTemporaryDirectory() stringByAppendingString:filename];
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if(error){
            NSLog(@"error: %@", error);
        }
    }
}