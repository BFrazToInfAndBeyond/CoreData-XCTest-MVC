#import "MFSearchPresenter.h"
#import "MFSearchViewInterface.h"
#import "MFSearchModelInterface.h"
#import <ESCObservable/ESCObservable.h>
#import <Stubble/Stubble.h>

@interface MFSearchPresenterTests : XCTestCase
{
    MFSearchPresenter *testObject;
    id<ESCObservableInternal,MFSearchViewInterface> mockView;
    id<MFSearchModelInterface> mockModel;
    NSArray *results;
}
@end

@implementation MFSearchPresenterTests

- (void)setUp {
    [super setUp];
    mockModel = SBLMock(@protocol(MFSearchModelInterface));
    mockView = SBLMock(@protocol(MFSearchViewInterface));
    
    [mockView escRegisterObserverProtocol:@protocol(MFSearchViewObserver)];

    testObject = [[MFSearchPresenter alloc] initWithModel:mockModel view:mockView];
    
    
}

- (void)setUpResults {
    id someImage;
    id someImage2;
    MFSearchResult *result1 = [[MFSearchResult alloc] initWithName:@"firstResult" secondaryName:@"Homer" image:someImage resultId:@"resultId" isFavorite:NO];
    MFSearchResult *result2 = [[MFSearchResult alloc] initWithName:@"secondResult" secondaryName:@"Simpson" image:someImage2 resultId:@"resultId2" isFavorite:NO];
    results = @[result1, result2];
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenPresenterCreated_ThenSetModelsTitleOnView {
    
    SBLVerify([mockView setTitle:[mockModel searchResultsTitle]]);
    
}

- (void)test_whenPresenterCreated_ThenSetAllResultsOnView {
    
    SBLVerify([mockView setResults:[mockModel allResults]]);
}

//- (void)test_whenViewNotifiesASearch_thenModelSearchResultsSetOnView {
//    [self setUpResults];
//    NSString *searchText = @"searchText";
//    [SBLWhen([mockModel queryWithSearchText:searchText])thenReturn:results];
//    [mockView.escNotifier searchRequestedForText:searchText];
//
//    SBLVerify([mockView setResults:results]);
//    
//}

- (void)test_whenSelectionMadeForResult_ThenDismissWithSearchResult{
    [self setUpResults];
    MFSearchResult *result = results[0];
    id<MFSearchPresenterDelegate> delegate = SBLMock(@protocol(MFSearchPresenterDelegate));
    testObject.delegate = delegate;
    
    [[mockView escNotifier] selectionMadeForResult:result];
    

    SBLVerify([delegate dismissWithSelectedSearchResult:result]);
}


@end
