#import "MFCoreDataMOCProvider.h"
#import "MFCoreDataPSCProvider.h"
#import <CoreData/CoreData.h>

@interface MFCoreDataMOCProvider ()

@property (nonatomic, readonly) id<MFCoreDataPSCProvider> storeProvider;

@end

@implementation MFCoreDataMOCProvider

@synthesize mainContext = _mainContext;

- (instancetype) initWithStoreProvider:(id<MFCoreDataPSCProvider>)storeProvider {
    if(self = [super init]){
        _storeProvider = storeProvider;
        
        NSPersistentStoreCoordinator *coordinator = [_storeProvider storeCoordinator];
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:coordinator];
        _mainContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        _mainContext.undoManager = nil;
    }
    return self;
}

@end