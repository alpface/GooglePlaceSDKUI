//
//  GMSAutocompleteTableDataSource.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMSAutocompleteBoundsMode.h"
#import "GMSAutocompleteFilter.h"
#import "GMSAutocompletePrediction.h"
#import "GMSPlace.h"

NS_ASSUME_NONNULL_BEGIN

@class GMSAutocompleteTableDataSource;

/**
 * EN: Protocol used by |GMSAutocompleteTableDataSource|, to communicate the user's interaction with the
 * data source to the application.
 *
 * 中文: | GMSAutocompleteTableDataSource |使用的协议，用于与用户进行交互应用程序的数据源。
 */
@protocol GMSAutocompleteTableDataSourceDelegate <NSObject>

@required

/**
 * EN: Called when a place has been selected from the available autocomplete predictions.
 *
 * 中文: 从可用的自动填充预测中选择某个地点时调用。
 * @param tableDataSource The |GMSAutocompleteTableDataSource| that generated the event.
 * @param place The |GMSPlace| that was returned.
 */
- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didAutocompleteWithPlace:(GMSPlace *)place;

/**
 * Called when a non-retryable error occurred when retrieving autocomplete predictions or place
 * details. A non-retryable error is defined as one that is unlikely to be fixed by immediately
 * retrying the operation.
 * <p>
 * Only the following values of |GMSPlacesErrorCode| are retryable:
 * <ul>
 * <li>kGMSPlacesNetworkError
 * <li>kGMSPlacesServerError
 * <li>kGMSPlacesInternalError
 * </ul>
 * All other error codes are non-retryable.
 * @param tableDataSource The |GMSAutocompleteTableDataSource| that generated the event.
 * @param error The |NSError| that was returned.
 */
- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didFailAutocompleteWithError:(NSError *)error;

@optional

/**
 * Called when the user selects an autocomplete prediction from the list but before requesting
 * place details. Returning NO from this method will suppress the place details fetch and
 * didAutocompleteWithPlace will not be called.
 * @param tableDataSource The |GMSAutocompleteTableDataSource| that generated the event.
 * @param prediction The |GMSAutocompletePrediction| that was selected.
 */
- (BOOL)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
    didSelectPrediction:(GMSAutocompletePrediction *)prediction;

/**
 * Called once every time new autocomplete predictions are received.
 * @param tableDataSource The |GMSAutocompleteTableDataSource| that generated the event.
 */
- (void)didUpdateAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource;

/**
 * Called once immediately after a request for autocomplete predictions is made.
 * @param tableDataSource The |GMSAutocompleteTableDataSource| that generated the event.
 */
- (void)didRequestAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource;

@end

/**
 * EN: GMSAutocompleteTableDataSource provides an interface for providing place autocomplete
 * predictions to populate a UITableView by implementing the UITableViewDataSource and
 * UITableViewDelegate protocols.
 *
 * GMSAutocompleteTableDataSource is designed to be used as the data source for a
 * UISearchDisplayController.
 *
 * NOTE: UISearchDisplayController has been deprecated since iOS 8. It is now recommended to use
 * UISearchController with |GMSAutocompleteResultsViewController| to display autocomplete results
 * using the iOS search UI.
 *
 * Set an instance of GMSAutocompleteTableDataSource as the searchResultsDataSource and
 * searchResultsDelegate properties of UISearchDisplayController. In your implementation of
 * shouldReloadTableForSearchString, call sourceTextHasChanged with the current search string.
 *
 * Use the |GMSAutocompleteTableDataSourceDelegate| delegate protocol to be notified when a place is
 * selected from the list. Because autocomplete predictions load asynchronously, it is necessary
 * to implement didUpdateAutocompletePredictions and call reloadData on the
 * UISearchDisplayController's table view.
 *
 * 中文: GMSAutocompleteTableDataSource提供用于提供场所自动完成的界面
 * 通过实现UITableViewDataSource来填充UITableView的预测UITableViewDelegate协议。
 *
 * GMSAutocompleteTableDataSource旨在用作a的数据源UISearchDisplayController。
 *
 * 注意：自iOS 8以来，UISearchDisplayController已被弃用。现在建议使用
 * UISearchController与| GMSAutocompleteResultsViewController |显示自动完成结果
 * 使用iOS搜索UI。
 *
 * 将GMSAutocompleteTableDataSource的实例设置为searchResultsDataSource和
 * UISearchDisplayController的searchResultsDelegate属性。在你的实施中
 * shouldReloadTableForSearchString，使用当前搜索字符串调用sourceTextHasChanged。
 *
 * 使用| GMSAutocompleteTableDataSourceDelegate |委托协议在地点通知时通知
 * 从列表中选择。由于自动填充预测是异步加载的，因此是必要的
 * 实现didUpdateAutocompletePredictions并调用reloadData
 * UISearchDisplayController的表视图。
 *
 */
@interface GMSAutocompleteTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

/**
 * EN: Delegate to be notified when a place is selected or picking is cancelled.
 *
 * 中文: 代理在选择地点或取消选择时收到通知。
 */
@property(nonatomic, weak, nullable) IBOutlet id<GMSAutocompleteTableDataSourceDelegate> delegate;

/**
 * EN: Bounds used to bias or restrict the autocomplete results depending on the value of
 * |autocompleteBoundsMode| (can be nil).
 *
 * 中文: 边界用于偏置或限制自动完成结果取决于的值 | autocompleteBoundsMode | （可以是零）。
 */
@property(nonatomic, strong, nullable) GMSCoordinateBounds *autocompleteBounds;

/**
 * EN: How to treat the |autocompleteBounds| property. Defaults to |kGMSAutocompleteBoundsModeBias|.
 *
 * Has no effect if |autocompleteBounds| is nil.
 *
 * 中文: *如何对待| autocompleteBounds | 属性。 默认为| kGMSAutocompleteBoundsModeBias |。
 * 如果| autocompleteBounds |无效 没有。
 */
@property(nonatomic, assign) GMSAutocompleteBoundsMode autocompleteBoundsMode;

/**
 * EN: Filter to apply to autocomplete suggestions (can be nil).
 *
 * 中文: 过滤以应用于自动填充建议（可以为零）
 */
@property(nonatomic, strong, nullable) GMSAutocompleteFilter *autocompleteFilter;

/**
 * EN: The background color of table cells.
 *
 * 中文: 表格单元格的背景颜色。
 */
@property(nonatomic, strong) UIColor *tableCellBackgroundColor;

/**
 * EN: The color of the separator line between table cells.
 *
 * 中文: 表格单元格之间的分隔线的颜色。
 */
@property(nonatomic, strong) UIColor *tableCellSeparatorColor;

/**
 * EN: The color of result name text in autocomplete results
 *
 * 中文: 自动完成结果中结果名称文本的颜色
 */
@property(nonatomic, strong) UIColor *primaryTextColor;

/**
 * EN: The color used to highlight matching text in autocomplete results
 *
 * 中文: 用于突出显示自动完成结果中匹配文本的高亮颜色
 */
@property(nonatomic, strong) UIColor *primaryTextHighlightColor;

/**
 * EN: The color of the second row of text in autocomplete results.
 *
 * 中文: 自动完成结果中第二行文本的颜色。
 */
@property(nonatomic, strong) UIColor *secondaryTextColor;

/**
 * EN: The tint color applied to controls in the Autocomplete view.
 *
 * 中文: 应用于“自动完成”视图中控件的色调颜色。
 */
@property(nonatomic, strong, nullable) UIColor *tintColor;

/**
 * EN:  Designated initializer
 *
 * 中文: 指定的初始化程序
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 * EN: Notify the data source that the source text to autocomplete has changed.
 *
 * This method should only be called from the main thread. Calling this method from another thread
 * will result in undefined behavior. Calls to |GMSAutocompleteTableDataSourceDelegate| methods will
 * also be called on the main thread.
 *
 * 中文: 通知数据源自动填充的源文本已更改。
 * 此方法只能从主线程调用。 从另一个线程调用此方法
 * 将导致未定义的行为。 调用| GMSAutocompleteTableDataSourceDelegate | 方法会
 * 也可以在主线程上调用。
 *
 * This method is non-blocking.
 * @param text The partial text to autocomplete.
 */
- (void)sourceTextHasChanged:(nullable NSString *)text;

@end
NS_ASSUME_NONNULL_END
