//
//  GMSPlacesResources.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/24.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMSPlacesResources : NSObject

+ (instancetype)sharedResources;
- (id)stringForID:(int)arg1;
+ (NSBundle *)placesResourcesBundle;

+ (UIImage *)bundleImageNamed:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
