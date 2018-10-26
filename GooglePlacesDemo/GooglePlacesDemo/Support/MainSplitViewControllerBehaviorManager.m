//
//  MainSplitViewControllerBehaviorManager.m
//  GooglePlaces
//
//  Created by xiaoyuan on 2018/10/26.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//


#import "MainSplitViewControllerBehaviorManager.h"

@implementation MainSplitViewControllerBehaviorManager {
  BOOL _hasBeenCollapsedBefore;
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
    collapseSecondaryViewController:(UIViewController *)secondaryViewController
          ontoPrimaryViewController:(UIViewController *)primaryViewController {
  // This override is probably not needed in your own app. This tells the |UISplitViewController| to
  // display the list of demos on first launch if there is not enough space to have two panes,
  // instead of just the first demo in the list. After first launch if the device transitions from
  // regular to compact it will instead show the demo which is currently open.
  if (_hasBeenCollapsedBefore) {
    return NO;
  } else {
    _hasBeenCollapsedBefore = YES;
    return YES;
  }
}

@end
