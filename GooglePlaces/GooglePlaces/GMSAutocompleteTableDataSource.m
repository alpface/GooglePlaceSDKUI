//
//  GMSAutocompleteTableDataSource.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAutocompleteTableDataSource.h"
#import "GMSAutocompleteResultsTableViewDelegate.h"
#import "GMSAutocompleteFetcher.h"
#import "GooglePlaces.h"
#import "GMSPlaceTableViewCell.h"
#import "GMSAttributionTableViewCell.h"
#import "UIScrollView+NoDataExtend.h"
#import "GMSPlacesResources.h"

@class GMSCoordinateBounds;

@interface GMSAutocompleteFetcher ()
@property(copy, nonatomic, readonly) NSString *requestSource;
@property(nonatomic, readonly) unsigned int requestCount;
@property(readonly, nonatomic) unsigned int errorCount;
/// 是否在等到搜索完成
@property(readonly, nonatomic) BOOL isWaitingForPredictions;
- (instancetype)initWithBounds:(GMSCoordinateBounds *)bounds filter:(GMSAutocompleteFilter *)filter requestSource:(NSString *)requestSource;

@end

@interface GMSAutocompleteTableDataSource () <GMSAutocompleteFetcherDelegate, UITableViewDataSource, UITableViewDelegate, NoDataPlaceholderDelegate>
{
    NSMutableArray<GMSAutocompletePrediction *> *_predictions;
    // 是否正在获取地点详情
    BOOL _isFetchingPlaceDetails;
    NSString *_sourceText;
    BOOL _hasLoggedMissingDelegateMessage;
    UIColor *_defaultTableCellBackgroundColor;
    UIColor *_defaultTableCellSeparatorColor;
    UIColor *_defaultPrimaryTextColor;
    UIColor *_defaultPrimaryTextHighlightColor;
    UIColor *_defaultSecondaryTextColor;
    BOOL _shouldCenterFullScreenCells;
    BOOL _forceDisplayOfLoadingSpinner;
    BOOL _quotaFailure;
    UIColor *_tableCellBackgroundColor;
    UIColor *_tableCellSeparatorColor;
    UIColor *_primaryTextColor;
    UIColor *_primaryTextHighlightColor;
    UIColor *_secondaryTextColor;
    UIColor *_tintColor;
    float _keyboardHeightHint;
    // 继承自 GPBMessage
//    ERx_PCCPlacesAutocompleteWidgetSessionProto *_sessionStats;
    NSError *_lastError;
    GMSAutocompleteFetcher *_fetcher;
    double _timeOfLastRequest;
}


@property(readonly, nonatomic) GMSAutocompleteFetcher *fetcher;
/// 强制显示加载loading
@property(nonatomic) BOOL forceDisplayOfLoadingSpinner;
@property(nonatomic) float keyboardHeightHint;
@property(readonly, nonatomic) NSError *lastError;
@property(nonatomic) BOOL quotaFailure;
@property(readonly, copy, nonatomic) NSString *requestSource;
@property(nonatomic) __weak id <GMSAutocompleteResultsTableViewDelegate> resultsTableViewDelegate;
//@property(readonly, nonatomic) ERx_PCCPlacesAutocompleteWidgetSessionProto *sessionStats;
@property(nonatomic) BOOL shouldCenterFullScreenCells;
@property(readonly, nonatomic) double timeOfLastRequest;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL canceledExplicitly;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeightCache;
@property (nonatomic, weak) UITableView *tableView;
/// 搜索不到结果时为YES
@property (nonatomic, assign, readonly) BOOL isUnresolvedPlace;
- (instancetype)initWithTableView:(UITableView *)tableView requestSource:(NSString *)requestSource clearcutRequestOrigin:(int)clearcutRequestOrigin NS_DESIGNATED_INITIALIZER;
@end

@implementation GMSAutocompleteTableDataSource
- (instancetype)init {
    @throw nil;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self = [super init]) {
        [self configureWithTableView:tableView requestSource:kGTLRPlaces_RequestHeaderContext_Source_ProgrammaticApi clearcutRequestOrigin:0x0];
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView requestSource:(NSString *)requestSource clearcutRequestOrigin:(int)clearcutRequestOrigin {
    if (self = [super init]) {
        [self configureWithTableView:tableView requestSource:requestSource clearcutRequestOrigin:clearcutRequestOrigin];
    }
    return self;
}

- (void)configureWithTableView:(UITableView *)tableView requestSource:(NSString *)requestSource clearcutRequestOrigin:(BOOL)clearcutRequestOrigin
{
    _predictions = [NSMutableArray array];
    _defaultTableCellBackgroundColor =[UIColor colorWithWhite:0.95 alpha:1.0];
    _defaultTableCellSeparatorColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
    _defaultPrimaryTextColor = [UIColor colorWithWhite:0 alpha:0.54];
    _defaultPrimaryTextHighlightColor = [_defaultPrimaryTextColor colorWithAlphaComponent:1.0];
    _defaultSecondaryTextColor = _defaultPrimaryTextColor;
    
    _fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:0x0 filter:0x0 requestSource:requestSource];
    _fetcher.delegate = self;
    self->_isFetchingPlaceDetails = 0x0;
    self->_shouldCenterFullScreenCells = 0x0;
    _sourceText = @"";
    //    _sessionStats = [[GMSx_PCCPlacesAutocompleteWidgetSessionProto alloc] init];
    //    [_sessionStats setCustomStylesApplied:0x2];
    //    [_sessionStats setOrigin:0x2];
    NSParameterAssert(tableView);
    _tableView = tableView;
    if (tableView.tableFooterView == nil) {
        // 无数据时不显示多余的分割线
         tableView.tableFooterView = [[UIView alloc] init];
    }
    /// 设置空数据
    tableView.noDataPlaceholderDelegate = self;
    __weak typeof(self) weakSelf = self;
    tableView.noDataReloadButtonBlock = ^(UIButton * _Nonnull reloadButton) {
        reloadButton.backgroundColor = [UIColor clearColor];
        [reloadButton.layer setMasksToBounds:YES];
        reloadButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        reloadButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [reloadButton setAttributedTitle:[weakSelf attributedStringWithText:@"无法识别该地点" color:[UIColor lightGrayColor] fontSize:13.0] forState:UIControlStateNormal];
        [reloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    };
    tableView.noDataImageViewBlock = ^(UIImageView * _Nonnull imageView) {
        if (weakSelf.isUnresolvedPlace) {
            imageView.image = [GMSPlacesResources bundleImageNamed:@"sad_cloud_dark"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        else {
            imageView.image = nil;
        }
    };
    
}
- (void)sourceTextHasChanged:(NSString *)text
{
    if ([text isEqualToString:_sourceText] == 0x0) {
        // 增加搜索次数
//        NSUInteger count = [_sessionStats totalKeystrokes];
//        count += 1;
//        [_sessionStats setTotalKeystrokes:count];
    }
    [self clearResults];
    _sourceText = text;
    
//    [_sessionStats setQueryLength:_sourceText.length];
    _timeOfLastRequest = CACurrentMediaTime();
     NSParameterAssert(self.delegate);
    [_fetcher sourceTextHasChanged:text];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Getter \ Setter
////////////////////////////////////////////////////////////////////////

- (UIColor *)tableCellBackgroundColor
{
    if (_tableCellBackgroundColor != 0x0) {
        return _tableCellBackgroundColor;
    }
    _tableCellBackgroundColor = _defaultTableCellBackgroundColor;
    return _tableCellBackgroundColor;
}

- (void)setTableCellBackgroundColor:(UIColor *)tableCellBackgroundColor
{
    _tableCellBackgroundColor = tableCellBackgroundColor;
//    [_sessionStats setCustomStylesApplied:0x1];
}

- (UIColor *)tableCellSeparatorColor
{
    if (_tableCellSeparatorColor != 0x0) {
        return _tableCellSeparatorColor;
    }
    _tableCellSeparatorColor = _defaultTableCellSeparatorColor;
    return _tableCellSeparatorColor;
}

- (void)setTableCellSeparatorColor:(UIColor *)tableCellSeparatorColor
{
    _tableCellSeparatorColor = tableCellSeparatorColor;
//    [_sessionStats setCustomStylesApplied:0x1];
}

- (UIColor *)primaryTextColor
{
    if (_primaryTextColor != 0x0) {
        return _primaryTextColor;
    }
    _primaryTextColor = _defaultPrimaryTextColor;
    return _primaryTextColor;
}

- (void)setPrimaryTextColor:(UIColor *)primaryTextColor
{
    _primaryTextColor = primaryTextColor;
//    [_sessionStats setCustomStylesApplied:0x1];
}

- (UIColor *)primaryTextHighlightColor
{
    if (_primaryTextHighlightColor != 0x0) {
        return _primaryTextHighlightColor;
    }
    _primaryTextHighlightColor = _defaultPrimaryTextHighlightColor;
    return _primaryTextHighlightColor;
}

- (void)setPrimaryTextHighlightColor:(UIColor *)primaryTextHighlightColor
{
    _primaryTextHighlightColor = primaryTextHighlightColor;
//    [_sessionStats setCustomStylesApplied:0x1];
}

- (UIColor *)secondaryTextColor
{
    if (_secondaryTextColor != 0x0) {
        return _secondaryTextColor;
    }
    _secondaryTextColor = _defaultSecondaryTextColor;
    return _secondaryTextColor;
}

- (void)setSecondaryTextColor:(UIColor *)secondaryTextColor
{
    _secondaryTextColor = secondaryTextColor;
    //    [_sessionStats setCustomStylesApplied:0x1];
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
//    [_sessionStats setCustomStylesApplied:0x1];
}

- (void)setAutocompleteBounds:(GMSCoordinateBounds *)autocompleteBounds
{
    [_fetcher setAutocompleteBounds:autocompleteBounds];
}

- (GMSCoordinateBounds *)autocompleteBounds
{
    return _fetcher.autocompleteBounds;
}

- (void)setAutocompleteBoundsMode:(GMSAutocompleteBoundsMode)autocompleteBoundsMode
{
    [_fetcher setAutocompleteBoundsMode:autocompleteBoundsMode];
}

- (GMSAutocompleteBoundsMode)autocompleteBoundsMode
{
    return _fetcher.autocompleteBoundsMode;
}

- (void)setAutocompleteFilter:(GMSAutocompleteFilter *)autocompleteFilter
{
    [_fetcher setAutocompleteFilter:autocompleteFilter];
}

- (GMSAutocompleteFilter *)autocompleteFilter
{
    return [_fetcher autocompleteFilter];
}

- (NSString *)requestSource
{
    return _fetcher.requestSource;
}
- (NSMutableDictionary<NSIndexPath *,NSNumber *> *)cellHeightCache {
    if (!_cellHeightCache) {
        _cellHeightCache = @{}.mutableCopy;
    }
    return _cellHeightCache;
}

- (BOOL)isUnresolvedPlace {
    return _predictions.count == 0 && _sourceText.length && _fetcher.isWaitingForPredictions == NO;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - GMSAutocompleteFetcherDelegate
////////////////////////////////////////////////////////////////////////

- (void)didAutocompleteWithPredictions:(NSArray<GMSAutocompletePrediction *> *)predictions
{
    _lastError = nil;
    _predictions = [predictions mutableCopy];
    if ([self.delegate respondsToSelector:@selector(didUpdateAutocompletePredictionsForTableDataSource:)]) {
        [self.delegate didUpdateAutocompletePredictionsForTableDataSource:self];
    }
//    [_sessionStats setAutocompleteQueries:_fetcher.requestCount];
//    [_sessionStats setAutocompleteErrors:_fetcher.errorCount];
    [_tableView xy_endLoading];
}

- (void)didFailAutocompleteWithError:(NSError *)error
{
    _lastError = error;
    _predictions = [NSMutableArray array];
    
    if ([self.delegate respondsToSelector:@selector(didUpdateAutocompletePredictionsForTableDataSource:)]) {
        [self.delegate didUpdateAutocompletePredictionsForTableDataSource:self];
    }
    NSInteger errorCode = [error code];
    if ([self shouldNotifyForErrorCode:errorCode] != 0x0) {
        [self.delegate tableDataSource:self didFailAutocompleteWithError:error];
    }
    //    [_sessionStats setAutocompleteQueries:_fetcher.requestCount];
    //    [_sessionStats setAutocompleteErrors:_fetcher.errorCount];
    
     [_tableView xy_endLoading];
}

- (void)willAutocompleteWithPredictions {
    [_tableView xy_beginLoading];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource, UITableViewDelegate
////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_sourceText.length == 0) {
            return 0;
        }
        if (_forceDisplayOfLoadingSpinner == 0x1) {
            return 0;
        }
        // 匹配结果
        return _predictions.count;
    }
    else if (section == 1) {
        // logo 搜索没有匹配到结果时，不显示logo
        if ([self isUnresolvedPlace]) {
            return 0;
        }
        else {
            return 1;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorColor = self.tableCellSeparatorColor;
    if (indexPath.section == 1) {
        // logo
        GMSAttributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GMSAttributionTableViewCell"];
        if (cell == nil) {
            cell = [[GMSAttributionTableViewCell alloc]  initWithReuseIdentifier:@"GMSAttributionTableViewCell"];
        }
        cell.backgroundColor = self.tableCellBackgroundColor;
        return cell;
    }
    else {
        // 搜索结果
        GMSPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[GMSPlaceTableViewCell alloc] initWithReuseIdentifier:@"Cell"];
        }
        cell.backgroundColor = self.tableCellBackgroundColor;
        
        GMSAutocompletePrediction *predication = _predictions[indexPath.row];
        [cell.primaryTextLabel setTextColor:self.primaryTextColor];

        /// 遍历获得符合指定属性或属性字典的区域(range)，并在 block 中进行设置 高亮搜索关键字
        UIFont *regularFont = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        UIFont *boldFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        NSMutableAttributedString *mutableAttributedString = [predication.attributedPrimaryText mutableCopy];
        [predication.attributedPrimaryText enumerateAttribute:kGMSAutocompleteMatchAttribute inRange:NSMakeRange(0, predication.attributedPrimaryText.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            GMSAutocompleteMatchFragment *match = value;
            if (match) {
                [mutableAttributedString removeAttribute:NSForegroundColorAttributeName range:range];
                [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:self.primaryTextHighlightColor range:range];
                UIFont *font = (value == nil) ? regularFont : boldFont;
                [mutableAttributedString addAttribute:NSFontAttributeName value:font range:range];
            }
        }];
        [cell.primaryTextLabel setAttributedText:mutableAttributedString];
        [cell.secondaryTextLabel setAttributedText:predication.attributedSecondaryText];
        [cell.secondaryTextLabel setTextColor:self.secondaryTextColor];
        [cell.primaryTextLabel setAccessibilityLabel:predication.attributedPrimaryText.string];
        [cell.secondaryTextLabel setAccessibilityLabel:predication.attributedSecondaryText.string];
        
        return cell;
    }
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    float keyboardHeightHint = [self keyboardHeightHint];
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeightCache[indexPath].floatValue ?: 72.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellHeightCache setObject:@(cell.frame.size.height) forKey:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GMSAutocompletePrediction *prediction = _predictions[indexPath.row];
        self.selectedIndex = indexPath.row;
//        [_sessionStats setSelectedIndex:indexPath.row];
//        [_sessionStats setPickedPlace:0x1];
        if ([self.delegate respondsToSelector:@selector(tableDataSource:didSelectPrediction:)]) {
           BOOL res = [self.delegate tableDataSource:self didSelectPrediction:prediction];
            if (res == YES) {
                _isFetchingPlaceDetails = 0x1;
                _forceDisplayOfLoadingSpinner = 0x1;
                [self.tableView xy_beginLoading];
                [tableView reloadData];
                NSString *placeID = [prediction placeID];
//                NSString *requestSource = _fetcher.requestSource;
                [[GMSPlacesClient sharedClient] lookUpPlaceID:placeID lang:kGMSPlacesLangCH callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
                    if (error == nil) {
                        if ([self.delegate respondsToSelector:@selector(tableDataSource:didAutocompleteWithPlace:)]) {
                            [self.delegate tableDataSource:self didAutocompleteWithPlace:result];
                        }
                    }
                    else {
                        if ([self.delegate respondsToSelector:@selector(tableDataSource:didFailAutocompleteWithError:)]) {
                            [self.delegate tableDataSource:self didFailAutocompleteWithError:error];
                        }
                    }
                    self->_isFetchingPlaceDetails = 0x0;
                    self->_forceDisplayOfLoadingSpinner = 0x0;
                    [self.tableView xy_beginLoading];
                }];
            }
            else {
                _isFetchingPlaceDetails = 0x0;
                [tableView reloadData];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NoDataPlaceholderDelegate
////////////////////////////////////////////////////////////////////////
- (CGPoint)contentOffsetForNoDataPlaceholder:(UIScrollView *)scrollView {
    return CGPointMake(0.0, 180.0);
}

- (void)noDataPlaceholder:(UIScrollView *)scrollView didClickReloadButton:(UIButton *)button {
    [self didClickTryAgainButton:button];
}
- (BOOL)noDataPlaceholderShouldDisplay:(UIScrollView *)scrollView {
    if ([self isUnresolvedPlace] || _fetcher.isWaitingForPredictions == YES || _forceDisplayOfLoadingSpinner == 0x1) {
        return YES;
    }
    return NO;
}

- (BOOL)noDataPlaceholderShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    if ([self noDataPlaceholderShouldDisplay:scrollView]) {
        return YES;
    }
    return NO;
}

- (UIScrollViewNoDataContentLayouAttribute)contentLayouAttributeOfNoDataPlaceholder:(UIScrollView *)scrollView {
    return UIScrollViewNoDataContentLayouAttributeTop;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [_sessionStats setScrolled:0x1];
    [_resultsTableViewDelegate scrollViewWillBeginDragging:scrollView];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////

- (void)didClickTryAgainButton:(UIButton *)btn
{
    [self sourceTextHasChanged:_sourceText];
}


- (BOOL)shouldNotifyForErrorCode:(NSInteger)code
{
    BOOL res = 0x0;
    if (code >= 100) {
        res = YES;
    }
    return YES;
}


- (void)resetSessionStats
{
//    NSInteger customStylesApplied = [_sessionStats customStylesApplied];
//    _sessionStats = [[GMSx_PCCPlacesAutocompleteWidgetSessionProto alloc] init];
//    [_sessionStats setCustomStylesApplied:customStylesApplied];
//    [_sessionStats setOrigin:];
}

- (void)clearResults
{
    _sourceText = @"";
    [_predictions removeAllObjects];
    _lastError = nil;
    if ([self.delegate respondsToSelector:@selector(didRequestAutocompletePredictionsForTableDataSource:)]) {
        [self.delegate didRequestAutocompletePredictionsForTableDataSource:self];
    }
    if ([self.delegate respondsToSelector:@selector(didUpdateAutocompletePredictionsForTableDataSource:)]) {
        [self.delegate didUpdateAutocompletePredictionsForTableDataSource:self];
    }
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Others
////////////////////////////////////////////////////////////////////////

- (NSAttributedString *)attributedStringWithText:(NSString *)string color:(UIColor *)color fontSize:(CGFloat)fontSize {
    NSString *text = string;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    UIColor *textColor = color;
    
    NSMutableDictionary *attributeDict = [NSMutableDictionary new];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 4.0;
    [attributeDict setObject:font forKey:NSFontAttributeName];
    [attributeDict setObject:textColor forKey:NSForegroundColorAttributeName];
    [attributeDict setObject:style forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributeDict];
    
    return attributedString;
    
}

@end
