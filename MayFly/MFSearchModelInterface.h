#import "MFSearchResult.h"
@protocol MFSearchModelInterface<NSObject, ESCObservable>

- (NSArray *)allResults;
- (void)queryWithSearchText:(NSString *)searchText;
- (NSString *)searchResultsTitle;



@optional
- (void)backOne;
- (void)selectedFavoriteAllEntities;
- (void)selectedViewRelatedArtistsWithArtistId:(NSString *)artistId;
- (NSInteger)scopeIndex;
- (void)selectedEntityWithResult:(MFSearchResult *)result;
- (void)setSerializedData:(NSArray *)serializedData;
- (void)updateScopeIndex:(NSInteger)scopeIndex;
- (NSArray *)scopeButtonTitles;
- (void)toggledFavoriteWithResultId:(NSString *)resultId;
- (void)updateEntities;

@end

@protocol MFSearchModelObserver

- (void)searchSuccessfulWithResults:(NSArray *)searchResults;

- (void)downloadFavoriteSuccessfulWithId:(NSString *)resultId;
- (void)downloadFavoriteNotSuccessfulWithId:(NSString *)resultId;

@end