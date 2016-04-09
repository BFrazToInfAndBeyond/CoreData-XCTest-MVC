#import "MFScopedSearchView.h"
#import "MFSearchCell.h"
#define STAR_UNFILLED @"ui-icon-star-rating-unfilled"
#define STAR_FILLED @"ui-icon-star-rating-filled"

static NSUInteger ActionSheetRelatedArtistsButton = 0;
static NSUInteger ActionSheetFavoriteAllArtistsButton = 1;
static NSUInteger ActionSheetFavoriteAllTracksButton = 0;
static NSUInteger ActionSheetFavoriteAllAlbumsButton = 0;
@interface MFScopedSearchView() <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIToolbarDelegate, ESCObservableInternal, UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger selectedEntityIndex;

@property (nonatomic) NSArray *results;

@end

@implementation MFScopedSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self escRegisterObserverProtocol:@protocol(MFSearchViewObserver)];
        _results = [NSArray array];
        
        [[NSBundle mainBundle]loadNibNamed:@"MFScopedSearchView" owner:self options:nil];
        self.baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.baseView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.toolBar.delegate = self;
        self.searchBar.delegate = self;
        [self tableViewSetup];
        
    }
    return self;
}


//TODO: buttons on toolbar for menu and query api for album, artist, or track
//TODO: Add methods to handle favorite button on cell

#pragma mark - MFViewInterface
- (void)setSelectedScopeButtonIndex:(MFEntityScope)index
{
    [self.searchBar setSelectedScopeButtonIndex:index];
}

- (void)downloadNotSuccessfulWithId:(NSString *)resultId{
    //alert user
}

- (void)downloadSuccessfulWithId:(NSString *)resultId{
    //changeFavoriteButtonIcon
}

- (void)setResults:(NSArray *)results{
    _results = results;
    [self.tableView reloadData];
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setScopeButtonTitles:(NSArray *)scopeButtonTitles{
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = scopeButtonTitles;
}

- (void)setSearchKeyboardType:(NSInteger)keyboardType{
    //no action needed for now
}
#pragma  mark - Keyboard notifications

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (CGRectContainsPoint(self.searchBar.frame, [touch locationInView:self])) {
        return YES;
    }
    [self dismissKeyboard];
    return NO;
}

- (void)dismissKeyboard{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Table view management
- (void)tableViewSetup {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    tap.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MFSearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchCell"];
    [self.tableView addGestureRecognizer:tap];
    [self.tableView setScrollsToTop:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.escNotifier searchRequestedForText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.escNotifier searchRequestedForText:searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self.escNotifier scopeButtonTappedAtIndex:selectedScope withSearchText:self.searchBar.text];
}
- (void)favoriteToggled:(MFSearchCell *)favoriteButton
{
    MFSearchResult *searchResultSelected = self.results[favoriteButton.tag];
    [self.escNotifier toggleFavoriteWithResultId:searchResultSelected.resultId];
}

#pragma mark - Table View data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.results count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.escNotifier clickBack];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MFSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    
    long row = indexPath.row;
    MFSearchResult *result = self.results[row];
    [cell.favoriteButton setTag:indexPath.row];
    cell.secondLabel.text = result.secondaryName;
    cell.titleLabel.text = result.name;
    cell.image.image = result.image;
    [cell.favoriteButton addTarget:self action:@selector(favoriteToggled:) forControlEvents:UIControlEventTouchDown];
    if(result.isFavorite){
        [cell.favoriteButton setImage:[UIImage imageNamed:STAR_FILLED] forState:UIControlStateNormal];
    }else {
        [cell.favoriteButton setImage:[UIImage imageNamed:STAR_UNFILLED] forState:UIControlStateNormal];
    }
    
    return  cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFSearchResult *result = self.results[indexPath.row];
    [self.escNotifier selectionMadeForResult:result];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    MFSearchResult *result = self.results[indexPath.row];
    [self.escNotifier selectionMadeForResult:result];
}

#pragma mark - Swipe for More
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *actionSheetToShow;
    if (self.searchBar.selectedScopeButtonIndex == MFArtistScope) {
        actionSheetToShow = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Related Artists",@"Favorite All Artists", nil];
    } else if (self.searchBar.selectedScopeButtonIndex == MFAlbumScope) {
        actionSheetToShow = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Favorite All Albums", nil];
    } else if (self.searchBar.selectedScopeButtonIndex == MFTrackScope) {
        actionSheetToShow = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Favorite All Tracks", nil];
    }
    self.selectedEntityIndex = indexPath.row;
    [actionSheetToShow showInView:self.tableView];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    UIColor *tintColor = [UIColor colorWithRed:0.0/255.0 green:51.0/255.0 blue:255.0/255.0 alpha:1.0];
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = tintColor;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"More";
}

#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MFSearchResult *searchResult = self.results[self.selectedEntityIndex];
    if (self.searchBar.selectedScopeButtonIndex == MFArtistScope) {
        if (buttonIndex == ActionSheetRelatedArtistsButton) {
            [self.escNotifier viewRelatedArtistsWithArtistId:searchResult.resultId];

        } else if (buttonIndex == ActionSheetFavoriteAllArtistsButton) {
            [self.escNotifier favoriteAllEntities];
        }
    } else if (self.searchBar.selectedScopeButtonIndex == MFAlbumScope) {
        if (buttonIndex == ActionSheetFavoriteAllAlbumsButton) {
            [self.escNotifier favoriteAllEntities];
        }
    } else if (self.searchBar.selectedScopeButtonIndex == MFTrackScope) {
        if (buttonIndex == ActionSheetFavoriteAllTracksButton) {
            [self.escNotifier favoriteAllEntities];
        }
    }
    [self.tableView setEditing:NO animated:YES];
}

@end


