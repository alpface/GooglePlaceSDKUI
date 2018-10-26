//
//  GMSPlacesResources.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/24.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSPlacesResources.h"

@implementation GMSPlacesResources

+ (instancetype)sharedResources {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSBundle *)placesResourcesBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"GMSPlacesResources.bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)bundleImageNamed:(NSString *)imageName
{
    if (!imageName) {
        return nil;
    }
    if ([imageName hasPrefix:@"GMSPlacesResources.bundle/"]) {
        return [UIImage imageNamed:imageName];
    }
    return [UIImage imageNamed:imageName inBundle:[self placesResourcesBundle] compatibleWithTraitCollection:nil];
}
@end
