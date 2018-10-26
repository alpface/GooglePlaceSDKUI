//
//  DemoAppDelegate.m
//  GooglePlaces
//
//  Created by xiaoyuan on 2018/10/26.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//


#import "DemoAppDelegate.h"
#import <GooglePlaces/GooglePlaces.h>

#import "DemoData.h"
#import "DemoListViewController.h"
#import "SDKDemoAPIKey.h"
#import "MainSplitViewControllerBehaviorManager.h"
#import <objc/runtime.h>

@implementation DemoAppDelegate {
  MainSplitViewControllerBehaviorManager *_splitViewManager;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Build version: %d", __apple_build_version__);

  // Do a quick check to see if you've provided an API key, in a real app you wouldn't need this but
  // for the demo it means we can provide a better error message.
  if (!kAPIKey.length) {
    // Blow up if APIKeys have not yet been set.
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *format = @"Configure APIKeys inside SDKDemoAPIKey.h for your  bundle `%@`, see "
                       @"README.GooglePlacesDemos for more information";
    @throw [NSException exceptionWithName:@"DemoAppDelegate"
                                   reason:[NSString stringWithFormat:format, bundleId]
                                 userInfo:nil];
  }

  // Provide the Places API with your API key.
  [GMSPlacesClient provideAPIKey:kAPIKey];
  // Provide the Maps API with your API key. You may not need this in your app, however we do need
  // this for the demo app as it uses Maps.
//  [ERServices provideAPIKey:kAPIKey];

  // Log the required open source licenses! Yes, just NSLog-ing them is not enough but is good for
  // a demo.
//  NSLog(@"Google Maps open source licenses:\n%@", [ERServices openSourceLicenseInfo]);
  NSLog(@"Google Places open source licenses:\n%@", [GMSPlacesClient openSourceLicenseInfo]);


  // Manually create a window. If you are using a storyboard in your own app you can ignore the rest
  // of this method.
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

  // Create our view controller with the list of demos.
  DemoData *demoData = [[DemoData alloc] init];
  DemoListViewController *masterViewController =
      [[DemoListViewController alloc] initWithDemoData:demoData];
  UINavigationController *masterNavigationController =
      [[UINavigationController alloc] initWithRootViewController:masterViewController];

  _splitViewManager = [[MainSplitViewControllerBehaviorManager alloc] init];

  // Setup the split view controller.
  UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
  UIViewController *detailViewController =
      [demoData.firstDemo createViewControllerForSplitView:splitViewController];
  splitViewController.delegate = _splitViewManager;
  splitViewController.viewControllers = @[ masterNavigationController, detailViewController ];
  self.window.rootViewController = splitViewController;

  [self.window makeKeyAndVisible];
    
  return YES;
}

@end
