//
//  GMSAutocompleteFetcher.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMSAutocompleteBoundsMode.h"
#import "GMSAutocompleteFilter.h"

@class GMSAutocompletePrediction, GMSCoordinateBounds;

NS_ASSUME_NONNULL_BEGIN;

/**
 * EN: Protocol for objects that can receive callbacks from GMSAutocompleteFetcher
 *
 * 中文: 可以从GMSAutocompleteFetcher接收回调的对象的协议
 */
@protocol GMSAutocompleteFetcherDelegate <NSObject>

@required

/**
 * EN: Called when autocomplete predictions are available.
 *
 * 中文: 在自动填充预测可用时调用。
 * @param predictions an array of GMSAutocompletePrediction objects. 预测一系列AutocompletePrediction对象。
 */
- (void)didAutocompleteWithPredictions:(NSArray<GMSAutocompletePrediction *> *)predictions;

/**
 * EN: Called when an autocomplete request returns an error.
 *
 * 中文: 在自动填充请求返回失败时调用。
 * @param error the error that was received. 失败收到的错误。
 */
- (void)didFailAutocompleteWithError:(NSError *)error;

@optional
/**
 * EN: Called when autocomplete predictions will begin.
 *
 * 中文: 在自动填充预测即将开始时调用。
 */
- (void)willAutocompleteWithPredictions;

@end

/**
 * EN: GMSAutocompleteFetcher is a wrapper around the lower-level autocomplete APIs that encapsulates
 * some of the complexity of requesting autocomplete predictions as the user is typing. Calling
 * sourceTextHasChanged will generally result in the provided delegate being called with
 * autocomplete predictions for the queried text, with the following provisos:
 *
 * - The fetcher may not necessarily request predictions on every call of sourceTextHasChanged if
 *   several requests are made within a short amount of time.
 * - The delegate will only be called with prediction results if those predictions are for the
 *   text supplied in the most recent call to sourceTextHasChanged.
 *
 * 中文: GMSAutocompleteFetcher是封装的低级自动完成API的包装器
 * 在用户输入时请求自动完成预测的一些复杂性。调用
   * sourceTextHasChanged通常会导致调用提供的委托
   *查询文本的自动填充预测，具有以下附带条件：
  *
   * - 如果获取sourceTextHasChanged的每次调用，则fetcher可能不一定请求预测
   *在短时间内提出了几项要求。
   * - 只有那些预测是针对的，才会调用代表的预测结果
   *最近一次调用sourceTextHasChanged时提供的文本。
 */
@interface GMSAutocompleteFetcher : NSObject

/**
 * Initialize the fetcher.
 *
 * @param bounds The bounds used to bias or restrict the results. Whether this biases or restricts
 *               is determined by the value of the |autocompleteBoundsMode| property.
 *               This parameter may be nil.
 * @param filter The filter to apply to the results. This parameter may be nil.
 */
- (instancetype)initWithBounds:(nullable GMSCoordinateBounds *)bounds
                        filter:(nullable GMSAutocompleteFilter *)filter NS_DESIGNATED_INITIALIZER;

/** Delegate to be notified with autocomplete prediction results. */
@property(nonatomic, weak, nullable) id<GMSAutocompleteFetcherDelegate> delegate;

/**
 * EN: Bounds used to bias or restrict the autocomplete results depending on the value of
 * |autocompleteBoundsMode| (can be nil).
 *
 * 中文: 边界用于偏置或限制自动完成结果取决于的值
 * | autocompleteBoundsMode | （可以是零）。
 */
@property(nonatomic, strong, nullable) GMSCoordinateBounds *autocompleteBounds;

/**
 * EN: How to treat the |autocompleteBounds| property. Defaults to |kGMSAutocompleteBoundsModeBias|.
 *
 * Has no effect if |autocompleteBounds| is nil.
 *
 * 中文: 如何对待| autocompleteBounds | 属性。 默认为| kGMSAutocompleteBoundsModeBias |。
 *
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
 * EN: Notify the fetcher that the source text to autocomplete has changed.
 *
 * This method should only be called from the main thread. Calling this method from another thread
 * will result in undefined behavior. Calls to |GMSAutocompleteFetcherDelegate| methods will also be
 * called on the main thread.
 *
 * 中文: 通知提取者自动填充的源文本已更改。
 *
 * 此方法只能从主线程调用。 从另一个线程调用此方法
 * 将导致未定义的行为。 调用| GMSAutocompleteFetcherDelegate | 方法也将
 * 调用主线程。
 * This method is non-blocking.
 * @param text The partial text to autocomplete.
 */
- (void)sourceTextHasChanged:(nullable NSString *)text;

@end


NS_ASSUME_NONNULL_END
