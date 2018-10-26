//
//  GMSAutocompleteMatchFragment.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * EN: This class represents a matched fragment of a string. This is a contiguous range of characters
 * in a string, suitable for highlighting in an autocompletion UI.
 *
 * 中文: 此类表示字符串的匹配片段。 这是一个连续的角色范围
 * 在一个字符串中，适合在自动完成UI中突出显示。
 */
@interface GMSAutocompleteMatchFragment : NSObject

/**
 * EN: The offset of the matched fragment. This is an index into a string. The character at this index
 * is the first matched character.
 *
 * 中文: 匹配片段的偏移量。 这是字符串的索引。 此索引处的字符
 * 是第一个匹配的角色。
 */
@property(nonatomic, readonly) NSUInteger offset;

/**
 * EN: The length of the matched fragment.
 *
 * 中文: 匹配片段的长度。
 */
@property(nonatomic, readonly) NSUInteger length;

@end

NS_ASSUME_NONNULL_END
