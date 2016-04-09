#import "MFCoreDataInMemoryPSCProvider.h"
#import <CoreData/CoreData.h>

@implementation MFCoreDataInMemoryPSCProvider

@synthesize storeCoordinator = _storeCoordinator;

- (id)init {
    if(self=[super init]) {
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error = nil;
        [coordinator addPersistentStoreWithType:NSInMemoryStoreType
                                  configuration:nil
                                            URL:nil
                                        options:nil
                                          error:&error
         ];
        _storeCoordinator = coordinator;
    }
    return self;
}

@end