//
//  GMSAutocompletePrediction.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * EN: Attribute name for match fragments in |GMSAutocompletePrediction| attributedFullText.
 *
 * 中文: | GMSAutocompletePrediction |中匹配片段的属性名称attributedFullText。
 * @related GMSAutocompletePrediction
 */
extern NSAttributedStringKey const kGMSAutocompleteMatchAttribute;

/**
 * EN: This class represents a prediction of a full query based on a partially typed string.
 *
 * 中文: 此类表示基于部分类型字符串的完整查询的预测。
 */
@interface GMSAutocompletePrediction : NSObject

/**
 * EN: The full description of the prediction as a NSAttributedString. E.g., "Sydney Opera House,
 * Sydney, New South Wales, Australia".
 *
 * 中文: 作为NSAttributedString的预测的完整描述。 例如，“悉尼歌剧院，
 * 悉尼，新南威尔士州，澳大利亚“。
 *
 *
 * Every text range that matches the user input has a |kGMSAutocompleteMatchAttribute|.  For
 * example, you can make every match bold using enumerateAttribute:
 * <pre>
 *   UIFont *regularFont = [UIFont systemFontOfSize:[UIFont labelFontSize]];
 *   UIFont *boldFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
 *
 *   NSMutableAttributedString *bolded = [prediction.attributedFullText mutableCopy];
 *   [bolded enumerateAttribute:kGMSAutocompleteMatchAttribute
 *                      inRange:NSMakeRange(0, bolded.length)
 *                      options:0
 *                   usingBlock:^(id value, NSRange range, BOOL *stop) {
 *                     UIFont *font = (value == nil) ? regularFont : boldFont;
 *                     [bolded addAttribute:NSFontAttributeName value:font range:range];
 *                   }];
 *
 *   label.attributedText = bolded;
 * </pre>
 */
@property(nonatomic, copy, readonly) NSAttributedString *attributedFullText;

/**
 * EN: The main text of a prediction as a NSAttributedString, usually the name of the place.
 * E.g. "Sydney Opera House".
 *
 * 中文: 作为NSAttributedString的预测的主要文本，通常是地方的名称。
 * 例如 “悉尼歌剧院”。
 *
 * Text ranges that match user input are have a |kGMSAutocompleteMatchAttribute|,
 * like |attributedFullText|.
 */
@property(nonatomic, copy, readonly) NSAttributedString *attributedPrimaryText;

/**
 * EN: The secondary text of a prediction as a NSAttributedString, usually the location of the place.
 * E.g. "Sydney, New South Wales, Australia".
 *
 * Text ranges that match user input are have a |kGMSAutocompleteMatchAttribute|, like
 * |attributedFullText|.
 *
 * May be nil.
 *
 * 中文: 预测的辅助文本作为NSAttributedString，通常是地点的位置。
 * 例如 “悉尼，新南威尔士州，澳大利亚”。
 *
 * 与用户输入匹配的文本范围具有| kGMSAutocompleteMatchAttribute |，如
 * | attributedFullText |。
 *
 * 可能是零。
 */
@property(nonatomic, copy, readonly, nullable) NSAttributedString *attributedSecondaryText;

/**
 * EN: An optional property representing the place ID of the prediction, suitable for use in a place
 * details request.
 *
 * 中文: 表示预测的地点ID的可选属性，适用于某个地方详细要求。
 */
@property(nonatomic, copy, readonly, nullable) NSString *placeID;

/**
 * EN: The types of this autocomplete result.  Types are NSStrings, valid values are any types
 *
 * 中文: 此自动完成结果的类型。 类型是NSStrings，有效值是任何类型
 */
@property(nonatomic, copy, readonly) NSArray<NSString *> *types;

@end


NS_ASSUME_NONNULL_END
