#import <Foundation/Foundation.h>
@protocol MFCoreDataPSCProvider;


@protocol MFCoreDataMOCProvider<NSObject>

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;

@end


@interface MFCoreDataMOCProvider : NSObject <MFCoreDataMOCProvider>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype) initWithStoreProvider:(id<MFCoreDataPSCProvider>)storeProvider;

@end