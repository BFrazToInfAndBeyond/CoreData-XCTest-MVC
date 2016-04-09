#import "MFPersistenceFactory.h"
#import <UIKit/UIKit.h>

@interface MFFavoritedSearchViewController : UIViewController

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithPersistenceFactory:(id<MFPersistenceFactory>)persistenceFactory;

- (void)updateModel;
@end

