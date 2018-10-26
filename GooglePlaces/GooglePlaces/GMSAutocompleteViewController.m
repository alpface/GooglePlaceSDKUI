//
//  GMSAutocompleteViewController.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAutocompleteViewController.h"
#import "GMSAutocompleteContentViewController.h"
#import "GMSAutocompleteResultsViewController.h"

@interface GMSAutocompleteContentViewController ()
@property(retain, nonatomic) GMSCoordinateBounds *autocompleteBounds;
@property(nonatomic) GMSAutocompleteBoundsMode autocompleteBoundsMode;
@property(retain, nonatomic) GMSAutocompleteFilter *autocompleteFilter;
@property(nonatomic, weak) id <GMSAutocompleteViewControllerDelegate> delegate;
@property(retain, nonatomic) GMSAutocompleteResultsViewController *resultsController;
- (NSInteger)selectedIndex;
@end

@class GMSAutocompleteFilter, GMSAutocompleteResultsViewController, GMSCoordinateBounds, UIColor;

@interface GMSAutocompleteViewController() {
    GMSAutocompleteContentViewController *_contentController;
    /// 嵌套导航控制的
    /// 如果self.navigationController!=nil，则_embeddedViewController = _contentController, 此时_contentController作为self的子控制器
    /// 如果 self.navigationController==nil, 则创建一个navigationController，并添加到self的子控制器，此时_contentController作为_embeddedViewController的子控制器
    UIViewController *_embeddedViewController;
}


@property(retain, nonatomic) GMSAutocompleteResultsViewController *resultsController;
- (unsigned int)selectedIndex;


@end

@implementation GMSAutocompleteViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _contentController = [[GMSAutocompleteContentViewController alloc] initWithAutocompleteViewController:self requestSource:nil widgetCallRequestSource:nil clearcutRequestOrigin:0];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
         _contentController = [[GMSAutocompleteContentViewController alloc] initWithAutocompleteViewController:self requestSource:nil widgetCallRequestSource:nil clearcutRequestOrigin:0];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    /// 移除embeddedViewController
    UINavigationController *embeddedViewController = (id)_embeddedViewController;
    if (embeddedViewController != 0x0) {
        [embeddedViewController willMoveToParentViewController:nil];
        UIView *embeddedView = embeddedViewController.view;
        [embeddedView.superview removeConstraints:embeddedView.constraints];
        [embeddedView removeFromSuperview];
        [embeddedViewController removeFromParentViewController];
    }
    /// 添加embeddedViewController
    if (self.navigationController == nil) {
        // 处理无导航控制器的情况
        embeddedViewController = [[UINavigationController alloc] initWithRootViewController:_contentController];
        
    }
    else {
        embeddedViewController = (id)_contentController;
    }
    
    embeddedViewController.view.frame = self.view.bounds;
    [embeddedViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [self addChildViewController:embeddedViewController];
    [self.view addSubview:embeddedViewController.view];
    [embeddedViewController didMoveToParentViewController:self];
    _embeddedViewController = embeddedViewController;
    embeddedViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[embeddedViewController]|" options:kNilOptions metrics:nil views:@{@"embeddedViewController": embeddedViewController.view}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[embeddedViewController]|" options:kNilOptions metrics:nil views:@{@"embeddedViewController": embeddedViewController.view}]];
    
    [super viewWillAppear:animated];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//
//    UINavigationController *nac = nil;
//    if ([_embeddedViewController isKindOfClass:[UINavigationController class]]) {
//        nac = (id)_embeddedViewController;
//    }
//    else {
//        nac = self.navigationController;
//    }
//    if (nac == nil) {
//        return UIStatusBarStyleLightContent;
//    }
//
//
//}

////////////////////////////////////////////////////////////////////////
#pragma mark - Getter \ Setter
////////////////////////////////////////////////////////////////////////

- (UINavigationItem *)navigationItem
{
    return _contentController.navigationItem;
}

- (UIColor *)tableCellBackgroundColor
{
    return _contentController.resultsController.tableCellBackgroundColor;
}

- (void)setTableCellBackgroundColor:(UIColor *)tableCellBackgroundColor
{
    [_contentController.resultsController setTableCellBackgroundColor:tableCellBackgroundColor];
}

- (UIColor *)tableCellSeparatorColor
{
    return _contentController.resultsController.tableCellSeparatorColor;
}

- (void)setTableCellSeparatorColor:(UIColor *)tableCellSeparatorColor
{
     [_contentController.resultsController setTableCellSeparatorColor:tableCellSeparatorColor];
}

- (UIColor *)primaryTextColor
{
    return [_contentController resultsController].primaryTextColor;
}

- (void)setPrimaryTextColor:(UIColor *)primaryTextColor
{
    [_contentController.resultsController setPrimaryTextColor:primaryTextColor];
}

- (UIColor *)primaryTextHighlightColor
{
    return [_contentController resultsController].primaryTextHighlightColor;
}

- (void)setPrimaryTextHighlightColor:(UIColor *)primaryTextHighlightColor2
{
    [_contentController.resultsController setPrimaryTextHighlightColor:primaryTextHighlightColor2];
}

- (UIColor *)secondaryTextColor
{
    return [_contentController resultsController].secondaryTextColor;
}

- (void)setSecondaryTextColor:(UIColor *)secondaryTextColor
{
    [_contentController.resultsController setSecondaryTextColor:secondaryTextColor];
}

- (UIColor *)tintColor
{
    return [_contentController resultsController].tintColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [_contentController.resultsController setTintColor:tintColor];
}

- (void)setDelegate:(id<GMSAutocompleteViewControllerDelegate>)delegate
{
    _contentController.delegate = delegate;
}

- (id<GMSAutocompleteViewControllerDelegate>)delegate
{
    return _contentController.delegate;
}

- (void)setAutocompleteBounds:(GMSCoordinateBounds *)autocompleteBounds
{
    [_contentController setAutocompleteBounds:autocompleteBounds];
}

- (GMSCoordinateBounds *)autocompleteBounds
{
    return _contentController.autocompleteBounds;
}

- (void)setAutocompleteBoundsMode:(GMSAutocompleteBoundsMode)autocompleteBoundsMode
{
    [_contentController setAutocompleteBoundsMode:autocompleteBoundsMode];
}

- (GMSAutocompleteBoundsMode)autocompleteBoundsMode
{
    return _contentController.autocompleteBoundsMode;
}

- (void)setAutocompleteFilter:(GMSAutocompleteFilter *)autocompleteFilter
{
    [_contentController setAutocompleteFilter:autocompleteFilter];
}

- (GMSAutocompleteFilter *)autocompleteFilter
{
    return _contentController.autocompleteFilter;
}

- (void)setResultsController:(GMSAutocompleteResultsViewController *)resultsController
{
    _contentController.resultsController = resultsController;
}

- (GMSAutocompleteResultsViewController *)resultsController
{
    return _contentController.resultsController;
}

- (unsigned int)selectedIndex
{
    return _contentController.selectedIndex;
}

@end
