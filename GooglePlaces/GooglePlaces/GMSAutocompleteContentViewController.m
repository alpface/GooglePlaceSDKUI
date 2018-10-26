//
//  GMSAutocompleteContentViewController.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/23.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAutocompleteContentViewController.h"
#import "GMSAutocompleteViewController.h"
#import "GMSAutocompleteResultsViewController.h"
#import "GMSAutocompleteResultsTableViewDelegate.h"
#import "GMSAutocompleteTableDataSource.h"

@interface GMSAutocompleteResultsViewController ()
- (void)clearResults;
@end

@interface GMSAutocompleteTableDataSource ()

@property(nonatomic, weak) id <GMSAutocompleteResultsTableViewDelegate> resultsTableViewDelegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL canceledExplicitly;

@end

@interface GMSAutocompleteResultsViewController ()

@property(retain, nonatomic) GMSAutocompleteTableDataSource *tableDataSource;
- (instancetype)initWithRequestSource:(NSString *)requestSource widgetCallRequestSource:(NSString *)widgetCallRequestSource clearcutRequestOrigin:(int)clearcutRequestOrigin;
- (void)hintKeyboardFrameWillChange:(id)arg1;
@end

@interface GMSAutocompleteContentViewController () <UISearchBarDelegate, GMSAutocompleteResultsViewControllerDelegate, GMSAutocompleteResultsTableViewDelegate> {
    UISearchBar *_searchBar;
//    id <UITableViewDelegate> _resultsControllerTableViewDelegate;
    NSString *_lastSearch;
    __weak GMSAutocompleteViewController *_autocompleteViewController;
    BOOL _ignoreResultsChanges;
    GMSAutocompleteResultsViewController *_resultsController;
}

@property(retain, nonatomic) GMSCoordinateBounds *autocompleteBounds;
@property(nonatomic) GMSAutocompleteBoundsMode autocompleteBoundsMode;
@property(retain, nonatomic) GMSAutocompleteFilter *autocompleteFilter;
@property(nonatomic, weak) id <GMSAutocompleteViewControllerDelegate> delegate;
@property(retain, nonatomic) GMSAutocompleteResultsViewController *resultsController; 

@end

@implementation GMSAutocompleteContentViewController

- (instancetype)initWithAutocompleteViewController:(GMSAutocompleteViewController *)autocompleteViewController requestSource:(id)requestSource widgetCallRequestSource:(NSString *)widgetCallRequestSource clearcutRequestOrigin:(int)clearcutRequestOrigin {
    if (self = [super init]) {
        _autocompleteViewController = autocompleteViewController;
        _resultsController = [[GMSAutocompleteResultsViewController alloc] initWithRequestSource:requestSource widgetCallRequestSource:widgetCallRequestSource clearcutRequestOrigin:clearcutRequestOrigin];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0x3f75c28f alpha:0x3f800000];
    // 清空leftBarButtonItem
    UIView *customNavigationItem = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customNavigationItem];
    // 添加取消
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    // 设置resultViewController delegate
    _resultsController.delegate = self;
    [self addChildViewController:_resultsController];
    
    // 添加searcBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 56.0)];
    _searchBar = searchBar;
    [_searchBar setSearchBarStyle:0x2];// UISearchBarStyleMinimal
    [_searchBar setAutoresizingMask:0x2];
    [_searchBar setDelegate:self];
    [_searchBar setAccessibilityLabel:@"searchBar"];
    [_searchBar sizeToFit];
    [_searchBar setPlaceholder:@"搜索"];
    [self.navigationItem setTitleView:_searchBar];
    [self.view addSubview:_resultsController.view];
    _resultsController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_resultsController]|" options:kNilOptions metrics:nil views:@{@"_resultsController": _resultsController.view}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_resultsController]|" options:kNilOptions metrics:nil views:@{@"_resultsController": _resultsController.view}]];
    [_resultsController didMoveToParentViewController:self];
    [[_resultsController tableDataSource] setResultsTableViewDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [_searchBar becomeFirstResponder];
    [_searchBar setText:_lastSearch];
    GMSAutocompleteTableDataSource *tableDataSource = [_resultsController tableDataSource];
    [tableDataSource sourceTextHasChanged:_searchBar.text];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_resultsController clearResults];
    _ignoreResultsChanges = 0x0;
}


- (NSInteger)selectedIndex {
    GMSAutocompleteTableDataSource *tableDataSource = [_resultsController tableDataSource];
    return [tableDataSource selectedIndex];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications
////////////////////////////////////////////////////////////////////////

- (void)keyboardFrameWillChange:(NSNotification *)note {
    [self->_resultsController hintKeyboardFrameWillChange:note];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Getter \ Setter
////////////////////////////////////////////////////////////////////////

- (GMSCoordinateBounds *)autocompleteBounds {
    return self->_resultsController.autocompleteBounds;
}

- (void)setAutocompleteBounds:(GMSCoordinateBounds *)autocompleteBounds {
    self->_resultsController.autocompleteBounds = autocompleteBounds;
}

- (GMSAutocompleteBoundsMode)autocompleteBoundsMode {
    return self->_resultsController.autocompleteBoundsMode;
}

- (void)setAutocompleteBoundsMode:(GMSAutocompleteBoundsMode)autocompleteBoundsMode {
    [self->_resultsController setAutocompleteBoundsMode:autocompleteBoundsMode];
}

- (GMSAutocompleteFilter *)autocompleteFilter {
    return self->_resultsController.autocompleteFilter;
}

- (void)setAutocompleteFilter:(GMSAutocompleteFilter *)autocompleteFilter {
    [self->_resultsController setAutocompleteFilter:autocompleteFilter];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////

- (void)cancelButtonTapped:(id)arg1 {
    [[self->_resultsController tableDataSource] setCanceledExplicitly:YES];
    [self->_searchBar setText:nil];
    _lastSearch = @"";
    [self hasCancelledSelection];

}

////////////////////////////////////////////////////////////////////////
#pragma mark - UISearchBarDelegate
////////////////////////////////////////////////////////////////////////

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[self->_resultsController tableDataSource] sourceTextHasChanged:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didAutocompleteWithPlace:(GMSPlace *)place
{
    // 选择某个搜索结果时，记录最后搜索的关键字
    _lastSearch = _searchBar.text;
    [self.delegate viewController:_autocompleteViewController didAutocompleteWithPlace:place];
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didFailAutocompleteWithError:(NSError *)error
{
    [self.delegate viewController:_autocompleteViewController didFailAutocompleteWithError:error];
}

- (BOOL)resultsController:(GMSAutocompleteResultsViewController *)resultsController
      didSelectPrediction:(GMSAutocompletePrediction *)prediction
{
    BOOL res = 0x0;
    if ([self.delegate respondsToSelector:@selector(viewController:didSelectPrediction:)]) {
        res = [self.delegate viewController:_autocompleteViewController didSelectPrediction:prediction];
        if (res != 0x0) {
            NSString *primaryText = [[prediction attributedPrimaryText] string];
            [_searchBar setText:primaryText];
        }
    }
    else {
        res = 0x1;
        NSString *primaryText = [[prediction attributedPrimaryText] string];
        [_searchBar setText:primaryText];
    }
    return res;
}

- (void)didUpdateAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController
{
    if (_ignoreResultsChanges != 0x0) {
        /// 忽略改变
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didUpdateAutocompletePredictions:)]) {
        [self.delegate didUpdateAutocompletePredictions:_autocompleteViewController];
    }
   
}

- (void)didRequestAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController
{
    if (_ignoreResultsChanges != 0x0) {
        /// 忽略改变
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didRequestAutocompletePredictions:)]) {
        [self.delegate didRequestAutocompletePredictions:_autocompleteViewController];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

- (void)hasCancelledSelection
{
    if ([self.delegate respondsToSelector:@selector(wasCancelled:)]) {
        [self.delegate wasCancelled:_autocompleteViewController];
    }
}

@end
