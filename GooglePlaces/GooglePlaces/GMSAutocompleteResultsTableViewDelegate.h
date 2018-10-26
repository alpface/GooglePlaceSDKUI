//
//  GMSAutocompleteResultsTableViewDelegate.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/23.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GMSAutocompleteResultsTableViewDelegate <NSObject>

@optional
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
