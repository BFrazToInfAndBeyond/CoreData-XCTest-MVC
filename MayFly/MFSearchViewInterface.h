#import "MFSearchResult.h"

@protocol MFSearchViewObserver

- (void)searchRequestedForText:(NSString *)searchText;
- (void)selectionMadeForResult:(MFSearchResult *)result;

@optional
- (void)favoriteAllEntities;
- (void)clickBack;
- (void)scopeButtonTappedAtIndex:(NSInteger)index withSearchText:(NSString *)searchText;
- (void)searchCanceled;
- (void)toggleFavoriteWithResultId:(NSString *)resultId;
- (void)viewRelatedArtistsWithArtistId:(NSString *)artistId;

@end

@protocol MFSearchViewInterface <ESCObservable, NSObject>

- (void)setSelectedScopeButtonIndex:(MFEntityScope)index;
- (void)setResults:(NSArray *)resutls;
- (void)setTitle:(NSString *)title;
- (void)setSearchKeyboardType:(NSInteger)keyboardType;
- (void)setScopeButtonTitles:(NSArray *)scopeButtonTitles;

- (void)downloadNotSuccessfulWithId:(NSString *)resultId;
- (void)downloadSuccessfulWithId:(NSString *)resultId;
@end