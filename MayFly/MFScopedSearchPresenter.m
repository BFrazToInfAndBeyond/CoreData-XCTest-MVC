#import "MFScopedSearchPresenter.h"
#import "MFSearchPresenterProtected.h"

@interface MFScopedSearchPresenter() <MFSearchPresenterProtected>

@end

@implementation MFScopedSearchPresenter

@dynamic model;
@dynamic view;

- (instancetype)initWithModel:(id<MFSearchModelInterface>)model view:(id<MFSearchViewInterface>)view{
    
    if(self = [super initWithModel:model view:view]){
        [self.view setScopeButtonTitles:[self.model scopeButtonTitles]];
    }
    return self;
}

- (void)updateModel
{
    [self.model updateEntities];
}

- (void)clickBack{
    [self.model backOne];
}

- (void)scopeButtonTappedAtIndex:(NSInteger)index withSearchText:(NSString *)searchText{
    [self.model updateScopeIndex:index];
    [self.model queryWithSearchText:searchText];
}

- (void)searchSuccessfulWithResults:(NSArray *)searchResults;
{
    [self.view setSelectedScopeButtonIndex:[self.model scopeIndex]];
    [self.view setResults:searchResults];
}

- (void)favoriteAllEntities
{
    [self.model selectedFavoriteAllEntities];
}

- (void)searchRequestedForText:(NSString *)searchText
{
    [self.model queryWithSearchText:searchText];
}

- (void)viewRelatedArtistsWithArtistId:(NSString *)artistId
{
    [self.model selectedViewRelatedArtistsWithArtistId:artistId];
}

- (void)selectionMadeForResult:(MFSearchResult *)result
{
    [self.model selectedEntityWithResult:result];
}

- (void)toggleFavoriteWithResultId:(NSString *)resuldId;
{
    [self.model toggledFavoriteWithResultId:resuldId];
}

- (void)downloadFavoriteSuccessfulWithId:(NSString *)resultId {
    [self.view downloadSuccessfulWithId:resultId];
}

- (void)downloadFavoriteNotSuccessfulWithId:(NSString *)resultId {
    [self.view downloadNotSuccessfulWithId:resultId];
}
@end


