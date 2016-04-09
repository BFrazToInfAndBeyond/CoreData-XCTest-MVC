#import "MFSearchPresenter.h"
#import "MFSearchPresenterProtected.h"

@interface MFSearchPresenter() <MFSearchPresenterProtected>

@end

@implementation MFSearchPresenter

@synthesize model = _model;
@synthesize view = _view;

- (instancetype) initWithModel:(id<MFSearchModelInterface>)model view:(id<MFSearchViewInterface>)view
{
    if (self = [super init]) {
        [model escAddObserver:self];
        _model = model;
        [view escAddObserver:self];
        _view = view;
        
        [self initalizeView];

    }
    return  self;
}

- (void)initalizeView {
    [self.view setTitle:[self.model searchResultsTitle]];
    [self.view setResults:[self.model allResults]];
}

- (void)searchRequestedForText:(NSString *)searchText{
   [self.model queryWithSearchText:searchText];
    //[self.view setResults:results];
}

- (void)selectionMadeForResult:(MFSearchResult *)result{
    [self.delegate dismissWithSelectedSearchResult:result];
}


@end