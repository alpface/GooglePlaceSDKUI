//
//  GMSPlacesClient.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018年 alpface. All rights reserved.
//


#import "GMSPlacesClient.h"
#import "GMSPlacesErrors.h"
#import "GMSAutocompletePrediction.h"
#import "GMSAutocompleteMatchFragment.h"

static GMSPlacesClient *_placesClientInstance = nil;

@interface GMSAutocompleteMatchFragment ()
- (instancetype)initWithOffset:(NSUInteger)offset length:(NSUInteger)length;
@end

@interface GMSAutocompletePrediction ()

- (instancetype)initWithText:(NSString *)arg2
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

@interface GMSPlacesClient ()<NSURLSessionDelegate>
@end

@implementation GMSPlacesClient
+ (instancetype)sharedClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _placesClientInstance = [[GMSPlacesClient alloc] init];
    });
    return _placesClientInstance;
}


+ (BOOL)provideAPIKey:(NSString *)key{
    return YES;
}


+ (NSString *)openSourceLicenseInfo{
    return nil;
}


+ (NSString *)SDKVersion{
    return nil;
}


- (void)reportDeviceAtPlaceWithID:(NSString *)placeID{
    
}


- (void)lookUpPlaceID:(NSString *)placeID lang:(GMSPlacesLang)lang callback:(GMSPlaceResultCallback)callback{
    
}


- (void)lookUpPhotosForPlaceID:(NSString *)placeID
                      callback:(GMSPlacePhotoMetadataResultCallback)callback{
    
}


- (void)loadPlacePhoto:(GMSPlacePhotoMetadata *)photo
              callback:(GMSPlacePhotoImageResultCallback)callback{
    
}


- (void)loadPlacePhoto:(GMSPlacePhotoMetadata *)photo
     constrainedToSize:(CGSize)maxSize
                 scale:(CGFloat)scale
              callback:(GMSPlacePhotoImageResultCallback)callback{
    
}


- (void)currentPlaceWithCallback:(GMSPlaceLikelihoodListCallback)callback{
    
}


- (void)autocompleteQuery:(NSString *)query
                   bounds:(nullable GMSCoordinateBounds *)bounds
                   filter:(nullable GMSAutocompleteFilter *)filter
                 callback:(GMSAutocompletePredictionsCallback)callback{
    
}


- (void)autocompleteQuery:(NSString *)query
                   bounds:(nullable GMSCoordinateBounds *)bounds
               boundsMode:(GMSAutocompleteBoundsMode)boundsMode
                   filter:(nullable GMSAutocompleteFilter *)filter
                 callback:(GMSAutocompletePredictionsCallback)callback{
    
    // 返回结果例子
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (callback) {
            /**
             query = 华夏科技大厦 # 搜索的关键字
             primaryText = 华夏科技大厦 # 此字段对应搜索到的title，此字段和query不一定相同
             secondaryText = 中国北京市海淀区 # 此字段为对应搜索到的地址
             fullText = secondaryText+primaryText
             placeID = ChIJ80lLjT5W8DUREaoJkJsffv4
             types = @[establishment]
             
             */
            NSArray *textlist = @[@"东", @"西", @"南", @"北"];
            NSString *secondaryText = @"中国北京市海淀区"; // 地址
            NSString *primaryText = [NSString stringWithFormat:@"%@%@", query, textlist[(NSInteger)arc4random_uniform((uint32_t)textlist.count-1)]];      // 名称
            GMSAutocompletePrediction *prediction = [[GMSAutocompletePrediction alloc] initWithPlaceID:@"123456"
                                                                                         primaryText:primaryText
                                                                                       secondaryText:secondaryText
                                                                                               types:@[@"establishment"]
                                                                                           queryText:query];
            
            callback(arc4random_uniform(10)%2 == 0 ? @[prediction] : @[], nil);
        }
    });
}


@end

