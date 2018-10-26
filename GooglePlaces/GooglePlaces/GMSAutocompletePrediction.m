//
//  GMSAutocompletePrediction.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAutocompletePrediction.h"
#import "GMSAutocompleteMatchFragment.h"

NSAttributedStringKey const kGMSAutocompleteMatchAttribute = @"GMSAutocompleteMatch";

@interface GMSAutocompleteMatchFragment ()

- (instancetype)initWithOffset:(NSUInteger)offset length:(NSUInteger)length;

@end

@interface GMSAutocompletePrediction ()

- (instancetype)initWithText:(NSString *)text
                     placeID:(NSString *)placeID
              matchFragments:(NSArray<GMSAutocompleteMatchFragment *> *)matchFragments
                       types:(NSArray<NSString *> *)types
                 primaryText:(NSString *)primaryText
        primaryTextFragments:(NSArray<GMSAutocompleteMatchFragment *> *)primaryTextFragments
               secondaryText:(NSString *)secondaryText
      secondaryTextFragments:(NSArray<GMSAutocompleteMatchFragment *> *)secondaryTextFragments;

- (instancetype)initWithPlaceID:(NSString *)placeID
                    primaryText:(NSString *)primaryText
                  secondaryText:(NSString *)secondaryText
                          types:(NSArray<NSString *> *)types
                      queryText:(NSString *)queryText;

@end

@implementation GMSAutocompletePrediction

- (instancetype)initWithPlaceID:(NSString *)placeID primaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText types:(NSArray<NSString *> *)types queryText:(NSString *)queryText {
    if (self = [super init]) {
        /**
         query = 华夏科技大厦 # 搜索的关键字
         primaryText = 华夏科技大厦 # 此字段对应搜索到的title，此字段和query不一定相同
         secondaryText = 中国北京市海淀区 # 此字段为对应搜索到的地址
         fullText = secondaryText+primaryText
         placeID = ChIJ80lLjT5W8DUREaoJkJsffv4
         types = @[establishment]
         
         */
        
        NSString *fullText = [NSString stringWithFormat:@"%@%@", secondaryText, primaryText];
        
//        NSString *fullText = @"中国北京市海淀区华夏科技大厦";
//        NSString *secondaryText = @"中国北京市海淀区";
//        NSString *primaryText = @"华夏科技大厦";
        NSRange queryOffsetInResultRange = [fullText rangeOfString:queryText];
        NSMutableArray *matchFragments = @[].mutableCopy;
        if (queryOffsetInResultRange.location != NSNotFound) {
            GMSAutocompleteMatchFragment *matchFragment = [[GMSAutocompleteMatchFragment alloc] initWithOffset:queryOffsetInResultRange.location length:queryOffsetInResultRange.length];
            [matchFragments addObject:matchFragment];
        }
        NSRange queryOffsetInPrimaryRange = [primaryText rangeOfString:queryText];
        NSMutableArray *primaryTextFragments = @[].mutableCopy;
        if (queryOffsetInPrimaryRange.location != NSNotFound) {
            GMSAutocompleteMatchFragment *keyFragment = [[GMSAutocompleteMatchFragment alloc] initWithOffset:queryOffsetInPrimaryRange.location length:queryOffsetInPrimaryRange.length];
            [primaryTextFragments addObject:keyFragment];
        }
        
        /// 查询关键字在第二行文本的range
        NSRange queryRangeInSecondaryText = [secondaryText rangeOfString:queryText];
        NSMutableArray *secondaryTextFragments = @[].mutableCopy;
        if (queryRangeInSecondaryText.location != NSNotFound) {
            GMSAutocompleteMatchFragment *fragment = [[GMSAutocompleteMatchFragment alloc] initWithOffset:queryRangeInSecondaryText.location length:queryRangeInSecondaryText.length];
            [secondaryTextFragments addObject:fragment];
        }
        [self configWithFullText:fullText placeID:placeID matchFragments:matchFragments types:types primaryText:primaryText primaryTextFragments:primaryTextFragments secondaryText:secondaryText secondaryTextFragments:secondaryTextFragments];
    }
    return self;
}

- (void)configWithFullText:(NSString *)text
               placeID:(NSString *)placeID
        matchFragments:(NSArray<GMSAutocompleteMatchFragment *> *)matchFragments
                 types:(NSArray<NSString *> *)types
           primaryText:(NSString *)primaryText
  primaryTextFragments:(NSArray<GMSAutocompleteMatchFragment *> *)primaryTextFragments
         secondaryText:(NSString *)secondaryText
secondaryTextFragments:(NSArray<GMSAutocompleteMatchFragment *> *)secondaryTextFragments {
    _placeID = placeID;
    _attributedFullText = [GMSAutocompletePrediction attributedText:text withMatches:matchFragments];
    _types = types;
    _attributedPrimaryText = [GMSAutocompletePrediction attributedText:primaryText withMatches:primaryTextFragments];
    _attributedSecondaryText = [GMSAutocompletePrediction attributedText:secondaryText withMatches:secondaryTextFragments];
}

- (instancetype)initWithText:(NSString *)text
                     placeID:(NSString *)placeID
              matchFragments:(NSArray<GMSAutocompleteMatchFragment *> *)matchFragments
                       types:(NSArray<NSString *> *)types
                 primaryText:(NSString *)primaryText
        primaryTextFragments:(NSArray<GMSAutocompleteMatchFragment *> *)primaryTextFragments
               secondaryText:(NSString *)secondaryText
      secondaryTextFragments:(NSArray<GMSAutocompleteMatchFragment *> *)secondaryTextFragments
{
    if (self = [super init]) {
        [self configWithFullText:text placeID:placeID matchFragments:matchFragments types:types primaryText:primaryText primaryTextFragments:primaryTextFragments secondaryText:secondaryText secondaryTextFragments:secondaryTextFragments];
    }
    return self;
}

+ (NSAttributedString *)attributedText:(NSString *)text withMatches:(NSArray<GMSAutocompleteMatchFragment *> *)matches
{
    NSMutableAttributedString *attritubedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (GMSAutocompleteMatchFragment *match in matches) {

        [attritubedString addAttribute:kGMSAutocompleteMatchAttribute value:match range:NSMakeRange(match.offset, match.length)];
    }
    
    return attritubedString;
}

- (NSString *)description
{
    
    NSString *text = [_attributedFullText string];
    NSArray *types = _types;
    NSString *placeID = _placeID;
    return [NSString stringWithFormat:@"%@ %p: \"%@\", id: %@, types: %@", [self class], self, text, placeID, types];
}

@end
