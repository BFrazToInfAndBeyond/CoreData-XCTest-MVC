#import "MFPersistenceFactory.h"
@interface MFSpotifySearchViewController : UIViewController

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithPersistenceFactory:(id<MFPersistenceFactory>)persistenceFactory;

- (void)updateModel;
@end

