//
//  GMSAutocompleteResultsViewController.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAutocompleteResultsViewController.h"
#import "GMSAutocompleteTableDataSource.h"
#import "GMSPlacesResources.h"

@interface GMSAutocompleteTableDataSource ()
@property(nonatomic) BOOL shouldCenterFullScreenCells;
@property(nonatomic) BOOL forceDisplayOfLoadingSpinner;
@property(nonatomic) BOOL quotaFailure;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign, readonly) BOOL isUnresolvedPlace;
- (instancetype)initWithTableView:(UITableView *)tableView requestSource:(NSString *)requestSource clearcutRequestOrigin:(int)clearcutRequestOrigin;
- (void)resetSessionStats;
@end

@class GMSAutocompleteFilter, GMSAutocompleteTableDataSource, GMSCoordinateBounds, GMSPlacesClient, NSString, UIColor, UITableViewController;

@interface GMSAutocompleteResultsViewController () <GMSAutocompleteTableDataSourceDelegate, UISearchResultsUpdating>
{
    BOOL _isRegisteredForKeyboardNotifications;
    GMSPlacesClient *_placesClient;
    NSString *_widgetCallRequestSource;
    int _clearcutRequestOrigin;
    NSString *_requestSource;
}

@property(retain, nonatomic) GMSAutocompleteTableDataSource *tableDataSource;
@property (nonatomic, strong) UITableViewController *tableViewController;
@property (nonatomic, assign) double sessionStartTime;
- (instancetype)initWithRequestSource:(NSString *)requestSource widgetCallRequestSource:(NSString *)widgetCallRequestSource clearcutRequestOrigin:(int)clearcutRequestOrigin;

@end
@implementation GMSAutocompleteResultsViewController

- (instancetype)initWithRequestSource:(NSString *)requestSource widgetCallRequestSource:(NSString *)widgetCallRequestSource clearcutRequestOrigin:(int)clearcutRequestOrigin {
    
    if (self = [super init]) {
        _widgetCallRequestSource = widgetCallRequestSource;
        _clearcutRequestOrigin = clearcutRequestOrigin;
        _requestSource = requestSource;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewController.view.frame = self.view.bounds;
    [self addChildViewController:_tableViewController];
    [self.view addSubview:_tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewController.tableView setTableFooterView:footerView];
    self.tableViewController.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableDataSource.delegate = self;
    
    [self.view setBackgroundColor:_tableDataSource.tableCellBackgroundColor];
    _tableViewController.tableView.backgroundColor = _tableDataSource.tableCellBackgroundColor;
    _tableViewController.tableView.tintColor = _tableDataSource.tintColor;
    self.view.tintColor = _tableDataSource.tintColor;
    [_tableDataSource setShouldCenterFullScreenCells:0x1];
    [_tableViewController.tableView setSeparatorColor:_tableDataSource.tableCellSeparatorColor];
    _tableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_tableViewController]|" options:kNilOptions metrics:nil views:@{@"_tableViewController": _tableViewController.view}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableViewController]|" options:kNilOptions metrics:nil views:@{@"_tableViewController": _tableViewController.view}]];
    
    
    
    if (@available(iOS 9.0, *)) {
        [_tableViewController.tableView setCellLayoutMarginsFollowReadableWidth:0x0];
    }
    _tableViewController.tableView.dataSource = _tableDataSource;
    _tableViewController.tableView.delegate = _tableDataSource;
    _tableDataSource.delegate = self;
    
    UIColor *tintcolor = self.tintColor;
    if (tintcolor != 0x0) {
        [_tableViewController.tableView setTintColor:tintcolor];
        [_tableDataSource setTintColor:tintcolor];
    }

    
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:0x0 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // 屏幕旋转适配
    }];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self->_isRegisteredForKeyboardNotifications = 0x0;
    [self accumulateSessionTime];
    
    [_tableDataSource setForceDisplayOfLoadingSpinner:0x0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableDataSource setQuotaFailure:0x0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    self->_isRegisteredForKeyboardNotifications = 0x1;
    self.sessionStartTime = CACurrentMediaTime();
    [_tableDataSource resetSessionStats];
//    GMSPlacesClient *placeClient = [GMSPlacesClient sharedClient];
//    _placesClient = placeClient;
//    [placeClient accountAutocompleteWidgetSessionWithRequestSource:r6 callback:&arg_C];
    NSParameterAssert(self.delegate != 0x0);
}

- (void)applicationEnteredForeground
{
    CFTimeInterval timeInterval = CACurrentMediaTime();
    _sessionStartTime = timeInterval;
}

- (void)applicationEnteredBackground
{
    [self accumulateSessionTime];
}

- (void)accumulateSessionTime
{
//    [self.tableDataSource.sessionStartTime setActiveTimeMs:self.sessionStats];
}

- (GMSCoordinateBounds *)autocompleteBounds
{
    return self.tableDataSource.autocompleteBounds;
}

- (void)setAutocompleteBounds:(GMSCoordinateBounds *)autocompleteBounds
{
    [self.tableDataSource setAutocompleteBounds:autocompleteBounds];
}

- (GMSAutocompleteFilter *)autocompleteFilter
{
    return self.tableDataSource.autocompleteFilter;
}

- (void)setAutocompleteBoundsMode:(GMSAutocompleteBoundsMode)autocompleteBoundsMode
{
    [self.tableDataSource setAutocompleteBoundsMode:autocompleteBoundsMode];
}

- (GMSAutocompleteBoundsMode)autocompleteBoundsMode
{
    return [self.tableDataSource autocompleteBoundsMode];
}

- (void)setAutocompleteFilter:(GMSAutocompleteFilter *)autocompleteFilter
{
    [self.tableDataSource setAutocompleteFilter:autocompleteFilter];
}

- (void)clearResults
{
    [self.tableDataSource setForceDisplayOfLoadingSpinner:0x0];
}

- (void)hintKeyboardFrameWillChange:(NSNotification *)note
{
    if (self->_isRegisteredForKeyboardNotifications != 0x0) {
        return;
    }
    [self updateKeyboardHeightHint:note];
}
- (void)updateKeyboardHeightHint:(NSNotification *)note
{
//    NSDictionary *userInfo = [note userInfo];
//    id rectValue = userInfo[UIKeyboardFrameEndUserInfoKey];
//    CGRect frame = [rectValue CGRectValue];
//    if (!CGRectEqualToRect(frame, CGRectZero)) {
//        _tableViewController.tableView
//    }
//
}
- (void)keyboardFrameWillChange:(NSNotification *)note
{
    [self updateKeyboardHeightHint:note];
    [_tableViewController.tableView beginUpdates];
    [_tableViewController.tableView endUpdates];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UISearchResultsUpdating
////////////////////////////////////////////////////////////////////////

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{

    if (searchController.isActive != 0x0) {
        [_tableDataSource setForceDisplayOfLoadingSpinner:0x0];
        [_tableDataSource sourceTextHasChanged:searchController.searchBar.text];
    }
}


////////////////////////////////////////////////////////////////////////
#pragma mark - GMSAutocompleteTableDataSourceDelegate
////////////////////////////////////////////////////////////////////////
- (void)didUpdateAutocompletePredictionsForTableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource {
    [_tableViewController.tableView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateAutocompletePredictionsForResultsController:)]) {
        [self.delegate didUpdateAutocompletePredictionsForResultsController:self];
    }
}
- (void)didRequestAutocompletePredictionsForTableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
{
    [_tableDataSource setForceDisplayOfLoadingSpinner:0x0];
    [_tableViewController.tableView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRequestAutocompletePredictionsForResultsController:)]) {
        [self.delegate didRequestAutocompletePredictionsForResultsController:self];
    }
}
- (BOOL)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource didSelectPrediction:(GMSAutocompletePrediction *)prediction
{
    BOOL res = 0x0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(resultsController:didSelectPrediction:)]) {
        BOOL res = [self.delegate resultsController:self didSelectPrediction:prediction];
        if (res == 0x1) {
            [_tableDataSource setForceDisplayOfLoadingSpinner:0x1];
            res = 0x1;
        }
        else {
            res = 0x0;
        }
    }
    else {
        [_tableDataSource setForceDisplayOfLoadingSpinner:0x1];
        res = 0x1;
    }
    return res;
}
- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource didAutocompleteWithPlace:(GMSPlace *)place
{
    [_tableViewController.tableView reloadData];
    [self.delegate resultsController:self didAutocompleteWithPlace:place];
}
- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource didFailAutocompleteWithError:(NSError *)error
{
    [_tableViewController.tableView reloadData];
    [self.delegate resultsController:self didFailAutocompleteWithError:error];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Getter \ Setter
////////////////////////////////////////////////////////////////////////
- (UIColor *)tableCellBackgroundColor
{
    return self.tableDataSource.tableCellBackgroundColor;
}

- (void)setTableCellBackgroundColor:(UIColor *)tableCellBackgroundColor
{
    [self.tableDataSource setTableCellBackgroundColor:tableCellBackgroundColor];
    self.tableViewController.tableView.backgroundColor = tableCellBackgroundColor;
}

- (UIColor *)tableCellSeparatorColor
{
    return self.tableDataSource.tableCellSeparatorColor;
}

- (void)setTableCellSeparatorColor:(UIColor *)tableCellSeparatorColor
{
    [self.tableDataSource setTableCellSeparatorColor:tableCellSeparatorColor];
}

- (UIColor *)primaryTextColor
{
    return self.tableDataSource.primaryTextColor;
}

- (void)setPrimaryTextColor:(UIColor *)primaryTextColor
{
    [self.tableDataSource setPrimaryTextColor:primaryTextColor];
}

- (UIColor *)primaryTextHighlightColor
{
    return self.tableDataSource.primaryTextHighlightColor;
}

- (void)setPrimaryTextHighlightColor:(UIColor *)primaryTextHighlightColor
{
    [self.tableDataSource setPrimaryTextHighlightColor:primaryTextHighlightColor];
}

- (UIColor *)secondaryTextColor
{
    return self.tableDataSource.secondaryTextColor;
}

- (void)setSecondaryTextColor:(UIColor *)secondaryTextColor
{
    [self.tableDataSource setSecondaryTextColor:secondaryTextColor];
}

- (UIColor *)tintColor
{
    return self.tableDataSource.tintColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [self.tableDataSource setTintColor:tintColor];
    self.tableViewController.tableView.tintColor = tintColor;
}

- (UITableViewController *)tableViewController {
    if (_tableViewController == nil) {
        _tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _tableViewController;
}
- (GMSAutocompleteTableDataSource *)tableDataSource {
    if (_tableDataSource == nil) {
        _tableDataSource = [[GMSAutocompleteTableDataSource alloc] initWithTableView:self.tableViewController.tableView];
    }
    return _tableDataSource;
}
@end
