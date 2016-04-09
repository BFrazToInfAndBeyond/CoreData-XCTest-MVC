#import "MFSearchModelInterface.h"
#import "MFSearchViewInterface.h"

@protocol MFSearchPresenterProtected <NSObject, MFSearchViewObserver, MFSearchModelObserver>

@property (nonatomic, readonly) id<MFSearchModelInterface> model;
@property (nonatomic, readonly) id<MFSearchViewInterface> view;

@end