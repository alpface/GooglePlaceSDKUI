//
//  GMSAutocompleteResultsViewController.h
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

NS_ASSUME_NONNULL_BEGIN;

@class GMSAutocompleteResultsViewController;

/**
 * EN: Protocol used by |GMSAutocompleteResultsViewController|, to communicate the user's interaction
 * with the controller to the application.
 *
 * 中文: | GMSAutocompleteResultsViewController |使用的协议，用于传达用户的交互与控制器到应用程序。
 */
@protocol GMSAutocompleteResultsViewControllerDelegate <NSObject>

@required

/**
 * EN: Called when a place has been selected from the available autocomplete predictions.
 *
 * 中文: 从可用的自动填充预测中选择某个地点时调用。
 * @param resultsController The |GMSAutocompleteResultsViewController| that generated the event.
 * @param place The |GMSPlace| that was returned.
 */
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place;

/**
 * EN: Called when a non-retryable error occurred when retrieving autocomplete predictions or place
 * details. A non-retryable error is defined as one that is unlikely to be fixed by immediately
 * retrying the operation.
 *
 * 中文: 在检索自动完成预测或放置时发生不可重试错误时调用
 * 细节。 不可重试的错误定义为不太可能立即修复的错误重试该操作。
 * <p>
 * Only the following values of |GMSPlacesErrorCode| are retryable:
 * <ul>
 * <li>kGMSPlacesNetworkError
 * <li>kGMSPlacesServerError
 * <li>kGMSPlacesInternalError
 * </ul>
 * All other error codes are non-retryable.
 * @param resultsController The |GMSAutocompleteResultsViewController| that generated the event.
 * @param error The |NSError| that was returned.
 */
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error;

@optional

/**
 * EN: Called when the user selects an autocomplete prediction from the list but before requesting
 * place details. Returning NO from this method will suppress the place details fetch and
 * didAutocompleteWithPlace will not be called.
 *
 * 中文: 当用户从列表中但在请求之前选择自动完成预测时调用
 * 地方详情。 从此方法返回NO将取消地点详细信息提取和
 * didAutocompleteWithPlace将不会被调用。
 * @param resultsController The |GMSAutocompleteResultsViewController| that generated the event.
 * @param prediction The |GMSAutocompletePrediction| that was selected.
 */
- (BOOL)resultsController:(GMSAutocompleteResultsViewController *)resultsController
      didSelectPrediction:(GMSAutocompletePrediction *)prediction;

/**
 * EN: Called once every time new autocomplete predictions are received.
 *
 * 中文: 每次收到新的自动完成预测时调用一次。
 * @param resultsController The |GMSAutocompleteResultsViewController| that generated the event.
 */
- (void)didUpdateAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController;

/**
 * Called once immediately after a request for autocomplete predictions is made.
 * @param resultsController The |GMSAutocompleteResultsViewController| that generated the event.
 */
- (void)didRequestAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController;

@end

/**
 * EN: GMSAutocompleteResultsViewController provides an interface that displays place autocomplete
 * predictions in a table view. The table view will be automatically updated as input text
 * changes.
 *
 * 中文: GMSAutocompleteResultsViewController提供显示地点自动完成的界面
 * 表格视图中的预测。 表视图将自动更新为输入文本变化。
 *
 * This class is intended to be used as the search results controller of a UISearchController. Pass
 * an instance of |GMSAutocompleteResultsViewController| to UISearchController's
 * initWithSearchResultsController method, then set the controller as the UISearchController's
 * searchResultsUpdater property.
 *
 * Use the |GMSAutocompleteResultsViewControllerDelegate| delegate protocol to be notified when a
 * place is selected from the list.
 */
@interface GMSAutocompleteResultsViewController : UIViewController <UISearchResultsUpdating>

/**
 * EN: Delegate to be notified when a place is selected.
 *
 * 中文: 代理在选择地点时收到通知。
 */
@property(nonatomic, weak, nullable) id<GMSAutocompleteResultsViewControllerDelegate> delegate;

/**
 * EN: Bounds used to bias or restrict the autocomplete results depending on the value of
 * |autocompleteBoundsMode| (can be nil).
 *
 * 中文: 用于偏置或限制自动完成结果的界限取决于值| autocompleteBoundsMode | （可以是零）。
 */
@property(nonatomic, strong, nullable) GMSCoordinateBounds *autocompleteBounds;

/**
 * EN: How to treat the |autocompleteBounds| property. Defaults to |kGMSAutocompleteBoundsModeBias|.
 *
 * Has no effect if |autocompleteBounds| is nil.
 *
 * 中文: 如何对待| autocompleteBounds | 属性。 默认为| kGMSAutocompleteBoundsModeBias |。
 * 如果| autocompleteBounds |无效 没有。
 */
@property(nonatomic, assign) GMSAutocompleteBoundsMode autocompleteBoundsMode;

/**
 * EN: Filter to apply to autocomplete suggestions (can be nil).
 *
 * 中文: 过滤以应用于自动填充建议（可以为零）。
 */
@property(nonatomic, strong, nullable) GMSAutocompleteFilter *autocompleteFilter;

/**
 * EN: The background color of table cells.
 *
 * 中文: 表格单元格的背景颜色。
 */
@property(nonatomic, strong) IBInspectable UIColor *tableCellBackgroundColor;

/**
 * EN: The color of the separator line between table cells.
 *
 * 中文: 表格单元格之间的分隔线的颜色。
 */
@property(nonatomic, strong) IBInspectable UIColor *tableCellSeparatorColor;

/**
 * EN: The color of result name text in autocomplete results
 *
 * 中文: 自动完成结果中结果名称文本的颜色
 */
@property(nonatomic, strong) IBInspectable UIColor *primaryTextColor;

/**
 * EN: The color used to highlight matching text in autocomplete results
 *
 * 中文: 用于突出显示自动完成结果中匹配文本的颜色
 */
@property(nonatomic, strong) IBInspectable UIColor *primaryTextHighlightColor;

/**
 * EN: The color of the second row of text in autocomplete results.
 *
 * 中文: 自动完成结果中第二行文本的颜色。
 */
@property(nonatomic, strong) IBInspectable UIColor *secondaryTextColor;

/**
 * EN: The tint color applied to controls in the Autocomplete view.
 *
 * 中文: 应用于“自动完成”视图中控件的主题颜色。
 */
@property(nonatomic, strong, nullable) IBInspectable UIColor *tintColor;

@end

NS_ASSUME_NONNULL_END
