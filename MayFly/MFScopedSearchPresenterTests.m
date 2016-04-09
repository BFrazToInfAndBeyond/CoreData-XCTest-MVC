#import "MFScopedSearchPresenter.h"
#import <ESCObservable/ESCObservable.h>


@interface MFScopedSearchPresenterTests : XCTestCase
{
    id<ESCObservableInternal,MFSearchViewInterface> mockView;
    id<ESCObservableInternal,MFSearchModelInterface> mockModel;
    MFScopedSearchPresenter *testObject;
    
}
@end

@implementation MFScopedSearchPresenterTests

- (void)setUp {
    [super setUp];
    mockView = SBLMock(@protocol(MFSearchViewInterface));
    mockModel = SBLMock(@protocol(MFSearchModelInterface));
    
    [mockView escRegisterObserverProtocol:@protocol(MFSearchViewObserver)];
    [mockModel escRegisterObserverProtocol:@protocol(MFSearchModelObserver)];

    
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenPresenterInitialized_ThenSetSegmentControlButtons{
    NSArray *expectedButtonTitles = @[@"Button1", @"Button2"];
    
    [SBLWhen([mockModel scopeButtonTitles])thenReturn:expectedButtonTitles];
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    SBLVerify([mockView setScopeButtonTitles:expectedButtonTitles]);

}

- (void)test_whenScopeButtonTapped_thenUpdateOnModelANDUpdateView{
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    [[mockView escNotifier] scopeButtonTappedAtIndex:0 withSearchText:@"searchText"];
    
    SBLVerify([mockModel updateScopeIndex:0]);
    SBLVerify([mockModel queryWithSearchText:@"searchText"]);
}

- (void)test_whenFavoriteToggled_thenNotifyModelWithId{
    
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    
    [[mockView escNotifier] toggleFavoriteWithResultId:@"resultId"];
    
    SBLVerify([mockModel toggledFavoriteWithResultId:@"resultId"]);
    
}


- (void)test_whenModelEventsOutThatSearchWasSuccessful_thenUpdateScopeButtonAndResultsOnView
{
    NSArray *results = @[@"result1", @"resutlt2"];
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    [SBLWhen([mockModel scopeIndex])thenReturn:@2];
    [[mockModel escNotifier] searchSuccessfulWithResults:results];
    SBLVerify([mockView setSelectedScopeButtonIndex:2]);
    SBLVerify([mockView setResults:results]);
    
}

- (void)test_whenSelectionMadeForResult_thenNotifyModelWithSearchResult
{
    MFSearchResult *searchResult = [[MFSearchResult alloc] initWithName:@"searchResult" secondaryName:@"secondaryName" image:nil resultId:@"resultId" isFavorite:YES];
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    [[mockView escNotifier] selectionMadeForResult:searchResult];
    SBLVerify([mockModel selectedEntityWithResult:searchResult]);
}

- (void)test_whenDownloadOfFavoriteEntitySuccessful_thenNotifyViewSuccess{
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    
    [[mockModel escNotifier] downloadFavoriteSuccessfulWithId:@"resultId"];
    
    SBLVerify([mockView downloadSuccessfulWithId:@"resultId"]);
}

- (void)test_whenModelNotifiesDownloadOfFavoriteEntitySuccessful_thenNotifyViewOfFailure{
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    
    [[mockModel escNotifier] downloadFavoriteNotSuccessfulWithId:@"resultId"];
    
    SBLVerify([mockView downloadNotSuccessfulWithId:@"resultId"]);
}

- (void)test_whenViewNotitifiesSearchWithText_thenPresenterCallsModel{
    NSArray *results = @[@"result1", @"result2"];
    [SBLWhen([mockModel queryWithSearchText:@"searchText"])thenReturn:results];
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    
    [[mockView escNotifier] searchRequestedForText:@"searchText"];
    SBLVerify([mockModel queryWithSearchText:@"searchText"]);
}

- (void)test_whenViewNotifiesViewRelatedArtists_thenPresenterCallsModelAsExpected
{
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    [[mockView escNotifier] viewRelatedArtistsWithArtistId:@"someId"];
    SBLVerify([mockModel selectedViewRelatedArtistsWithArtistId:@"someId"]);
}

- (void)test_whenViewNotifiesFavoriteAllEntities_thenPresenterCallsModelAsExpected
{
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    [[mockView escNotifier] favoriteAllEntities];
    SBLVerify([mockModel selectedFavoriteAllEntities]);
}

- (void)test_whenPresenterNotifiedToUpdateModel_thenItCallsModelAsExpected
{
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    [testObject updateModel];
    SBLVerify([mockModel updateEntities]);
}

- (void)test_whenPresenterNotifiedUserClickedBack_thenItNotifiesModelAsExpected
{
    testObject = [[MFScopedSearchPresenter alloc] initWithModel:mockModel view:mockView];
    [[mockView escNotifier] clickBack];
    SBLVerify([mockModel backOne]);
}
@end
