#import <CoreData/CoreData.h>
#import "MFCoreDataSqlitePSCProvider.h"

@implementation MFCoreDataSqlitePSCProvider

@synthesize storeCoordinator = _storeCoordinator;

- (instancetype)initWithUserStoreURL:(NSURL *)storeURL {
    self = [super init];
    if (self) {
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error = nil;
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
        _storeCoordinator = coordinator;
    }
    return self;
}
@end