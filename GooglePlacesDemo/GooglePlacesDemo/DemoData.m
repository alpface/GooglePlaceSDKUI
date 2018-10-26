//
//  DemoData.m
//  GooglePlaces
//
//  Created by xiaoyuan on 2018/10/26.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "DemoData.h"

#import "BaseDemoViewController.h"
#import "AutocompleteModalViewController.h"
#import "AutocompletePushViewController.h"
#import "AutocompleteWithCustomColors.h"
#import "AutocompleteWithSearchDisplayController.h"
#import "AutocompleteWithSearchViewController.h"
#import "AutocompleteWithTextFieldController.h"

@implementation Demo {
  Class _viewControllerClass;
}

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass {
  if ((self = [self init])) {
    _title = [viewControllerClass demoTitle];
    _viewControllerClass = viewControllerClass;
  }
  return self;
}

- (UIViewController *)createViewControllerForSplitView:
    (UISplitViewController *)splitViewController {
  // Construct the demo view controller.
  UIViewController *demoViewController = [[_viewControllerClass alloc] init];

  // Configure its left bar button item to display the displayModeButtonItem provided by the
  // splitViewController.
  demoViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
  demoViewController.navigationItem.leftItemsSupplementBackButton = YES;

  // Wrap the demo in a navigation controller.
  UINavigationController *navigationController =
      [[UINavigationController alloc] initWithRootViewController:demoViewController];

  return navigationController;
}

@end

@implementation DemoSection

- (instancetype)initWithTitle:(NSString *)title demos:(NSArray<Demo *> *)demos {
  if ((self = [self init])) {
    _title = [title copy];
    _demos = [demos copy];
  }
  return self;
}

@end

@implementation DemoData

- (instancetype)init {
  if ((self = [super init])) {
    NSArray<Demo *> *autocompleteDemos = @[
      [[Demo alloc] initWithViewControllerClass:[AutocompleteWithCustomColors class]],
      [[Demo alloc] initWithViewControllerClass:[AutocompleteModalViewController class]],
      [[Demo alloc] initWithViewControllerClass:[AutocompletePushViewController class]],
      [[Demo alloc] initWithViewControllerClass:[AutocompleteWithSearchDisplayController class]],
      [[Demo alloc] initWithViewControllerClass:[AutocompleteWithSearchViewController class]],
      [[Demo alloc] initWithViewControllerClass:[AutocompleteWithTextFieldController class]],
    ];


    _sections = @[
      [[DemoSection alloc]
          initWithTitle:NSLocalizedString(@"Demo.Section.Title.Autocomplete",
                                          @"Title of the autocomplete demo section")
                  demos:autocompleteDemos],
    ];
  }
  return self;
}

- (Demo *)firstDemo {
  return _sections[0].demos[0];
}

@end
