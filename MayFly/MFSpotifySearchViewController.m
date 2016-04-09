#import "MFScopedSearchView.h"
#import "MFScopedSearchPresenter.h"
#import "MFSpotifySearchViewController.h"
#import "MFSpotifySearchModel.h"


@interface MFSpotifySearchViewController ()
@property (nonatomic) id<MFPersistenceFactory> persistenceFactory;
@property (nonatomic) MFScopedSearchPresenter *scopedSearchPresenter;
@property (nonatomic) MFScopedSearchView *scopedSearchView;
@end

@implementation MFSpotifySearchViewController

- (instancetype)initWithPersistenceFactory:(id<MFPersistenceFactory>)persistenceFactory
{
    if (self = [super init]) {
        _persistenceFactory = persistenceFactory;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    _scopedSearchView = [[MFScopedSearchView alloc] initWithFrame:self.view.bounds];
    
    MFMemoryStack *memoryStack = [[MFMemoryStack alloc] init];
    MFServiceClientFactory *serviceClientFactory = [[MFServiceClientFactory alloc] initWithRequestOperationManager:[AFHTTPRequestOperationManager manager]];
    MFPersistencePonsoProvider *persistencePonsoProvider = [[MFPersistencePonsoProvider alloc] initWithPersistenceFactory:self.persistenceFactory];
    
    MFSpotifySearchModel *searchModel = [[MFSpotifySearchModel alloc] initWithServiceClientFactory:serviceClientFactory persistenceFactory:self.persistenceFactory persistencePonsoProvider:persistencePonsoProvider memoryStack:memoryStack];
    
    self.scopedSearchPresenter = [[MFScopedSearchPresenter alloc] initWithModel:searchModel view:self.scopedSearchView];
    [self.view addSubview:self.scopedSearchView];
}

- (void)updateModel
{
    [self.scopedSearchPresenter updateModel];
}

@end
