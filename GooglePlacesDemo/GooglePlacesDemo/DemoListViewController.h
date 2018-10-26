//
//  DemoListViewController.h
//  GooglePlaces
//
//  Created by xiaoyuan on 2018/10/26.
//  Copyright © 2018 alpface. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "DemoData.h"

/**
 * The class which displays the list of demos.
 */
@interface DemoListViewController : UITableViewController

/**
 * Construct a new list controller using the provided demo data.
 *
 * @param demoData The demo data to display in the list.
 */
- (instancetype)initWithDemoData:(DemoData *)demoData;

@end
