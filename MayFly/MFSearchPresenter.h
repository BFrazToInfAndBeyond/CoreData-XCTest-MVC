#import "MFSearchViewInterface.h"
#import "MFSearchModelInterface.h"

@protocol MFSearchPresenterDelegate

- (void)dismissWithSelectedSearchResult:(MFSearchResult *)searchResult;
- (void)dismissWithLeftBarButtonClicked;
- (void)dismissWithRightBarButtonClicked;

@end

@interface MFSearchPresenter: NSObject <MFSearchModelObserver, MFSearchViewObserver>


@property (nonatomic, weak) id<MFSearchPresenterDelegate>delegate;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype) initWithModel:(id<MFSearchModelInterface>)model view:(id<MFSearchViewInterface>)view;


@end