//
//  BaseDemoViewController.m
//  GooglePlaces
//
//  Created by xiaoyuan on 2018/10/26.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//


#import "BaseDemoViewController.h"

@implementation BaseDemoViewController

+ (NSString *)demoTitle {
  // This should be overridden by subclasses, so should not be called.
  return nil;
}

- (instancetype)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {
  if ((self = [super initWithNibName:name bundle:bundle])) {
    self.title = [[self class] demoTitle];
  }
  return self;
}

@end
