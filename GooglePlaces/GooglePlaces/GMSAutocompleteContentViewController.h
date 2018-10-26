//
//  GMSAutocompleteContentViewController.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/23.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GMSAutocompleteViewController;

@interface GMSAutocompleteContentViewController : UIViewController 

/// 初始化方法
- (instancetype)initWithAutocompleteViewController:(GMSAutocompleteViewController *)autocompleteViewController requestSource:(id)requestSource widgetCallRequestSource:(NSString *)widgetCallRequestSource clearcutRequestOrigin:(int)clearcutRequestOrigin;

@end

NS_ASSUME_NONNULL_END
