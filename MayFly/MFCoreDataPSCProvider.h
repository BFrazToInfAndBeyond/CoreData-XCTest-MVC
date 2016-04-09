#import <Foundation/Foundation.h>
@protocol MFCoreDataPSCProvider<NSObject>

@property (nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;

@end
