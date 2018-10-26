//
//  GMSPlacePhotoMetadataList.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018年 alpface. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GMSPlacePhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN;

/**
 * A list of |GMSPlacePhotoMetadata| objects.
 */
@interface GMSPlacePhotoMetadataList : NSObject

/**
 * The array of |GMSPlacePhotoMetadata| objects.
 */
@property(nonatomic, readonly, copy) NSArray<GMSPlacePhotoMetadata *> *results;

@end

NS_ASSUME_NONNULL_END;
