//
//  GMSAutocompleteViewController.h
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

@class GMSAutocompleteViewController;

/**
 * Protocol used by |GMSAutocompleteViewController|, to communicate the user's interaction
 * with the controller to the application.
 */
@protocol GMSAutocompleteViewControllerDelegate <NSObject>

@required

/**
 * EN: Called when a place has been selected from the available autocomplete predictions.
 *
 * 中文: 从可用的自动填充预测中选择某个地点时调用。
 *
 * Implementations of this method should dismiss the view controller as the view controller will not
 * dismiss itself.
 *
 * 此方法的实现应该忽略视图控制器，因为视图控制器不会隐藏自己。
 * @param viewController The |GMSAutocompleteViewController| that generated the event.
 * @param place The |GMSPlace| that was returned.
 */
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place;

/**
 * EN: Called when a non-retryable error occurred when retrieving autocomplete predictions or place
 * details. A non-retryable error is defined as one that is unlikely to be fixed by immediately
 * retrying the operation.
 *
 * 中文: 在检索自动完成预测或放置时发生不可重试错误时调用
 * 细节。 不可重试的错误定义为不太可能立即修复的错误重试该操作。
 * Only the following values of |GMSPlacesErrorCode| are retryable:
 * <ul>
 * <li>kGMSPlacesNetworkError
 * <li>kGMSPlacesServerError
 * <li>kGMSPlacesInternalError
 * </ul>
 * All other error codes are non-retryable.
 *
 * @param viewController The |GMSAutocompleteViewController| that generated the event.
 * @param error The |NSError| that was returned.
 */
- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error;

/**
 * EN: Called when the user taps the Cancel button in a |GMSAutocompleteViewController|.
 *
 * 中文: 当用户点击| GMSAutocompleteViewController |中的“取消”按钮时调用。
 *
 * Implementations of this method should dismiss the view controller as the view controller will not
 * dismiss itself.
 *
 * @param viewController The |GMSAutocompleteViewController| that generated the event.
 */
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController;

@optional

/**
 * EN: Called when the user selects an autocomplete prediction from the list but before requesting
 * place details.
 *
 * 中文: 当用户从列表中但在请求之前选择自动完成预测时调用地方详情。
 *
 * Returning NO from this method will suppress the place details fetch and didAutocompleteWithPlace
 * will not be called.
 *
 * @param viewController The |GMSAutocompleteViewController| that generated the event.
 * @param prediction The |GMSAutocompletePrediction| that was selected.
 */
- (BOOL)viewController:(GMSAutocompleteViewController *)viewController
   didSelectPrediction:(GMSAutocompletePrediction *)prediction;

/**
 * EN: Called once every time new autocomplete predictions are received.
 *
 * 中文: 每次收到新的自动完成预测时调用一次。
 *
 * @param viewController The |GMSAutocompleteViewController| that generated the event.
 */
- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController;

/**
 *  EN: Called once immediately after a request for autocomplete predictions is made.
 *
 * 中文: 在发出自动完成预测请求后立即调用一次。
 *
 * @param viewController The |GMSAutocompleteViewController| that generated the event.
 */
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController;

@end

/**
 * EN: GMSAutocompleteViewController provides an interface that displays a table of autocomplete
 * predictions that updates as the user enters text. Place selections made by the user are
 * returned to the app via the |GMSAutocompleteViewControllerResultsDelegate| protocol.
 *
 * 中文: GMSAutocompleteViewController提供了一个显示自动完成表的界面
 * 用户输入文本时更新的预测。 用户进行的地点选择是
 * 通过| GMSAutocompleteViewControllerResultsDelegate |返回到应用程序 协议。
 *
 * To use GMSAutocompleteViewController, set its delegate to an object in your app that
 * conforms to the |GMSAutocompleteViewControllerDelegate| protocol and present the controller
 * (eg using presentViewController). The |GMSAutocompleteViewControllerDelegate| delegate methods
 * can be used to determine when the user has selected a place or has cancelled selection.
 */
@interface GMSAutocompleteViewController : UIViewController

/**
 * EN:Delegate to be notified when a place is selected or picking is cancelled.
 *
 * 中文: 代理在选择地点或取消选择时收到通知
 */
@property(nonatomic, weak, nullable) IBOutlet id<GMSAutocompleteViewControllerDelegate> delegate;

/**
 * EN: Bounds used to bias or restrict the autocomplete results depending on the value of
 * |autocompleteBoundsMode| (can be nil).
 *
 * 中文: 用于偏置或限制自动完成结果的界限取决于值
 * | autocompleteBoundsMode | （可以是零）。
 */
@property(nonatomic, strong, nullable) GMSCoordinateBounds *autocompleteBounds;

/**
 * EN: How to treat the |autocompleteBounds| property. Defaults to |kGMSAutocompleteBoundsModeBias|.
 *
 * 中文: 如何处理| autocompleteBounds | 属性。 默认为| kGMSAutocompleteBoundsModeBias |。
 *
 * Has no effect if |autocompleteBounds| is nil.
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
 * 中文: 表格单元格之间的分隔线的颜色
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
 * 中文：用于突出显示自动完成结果中匹配文本的颜色
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
