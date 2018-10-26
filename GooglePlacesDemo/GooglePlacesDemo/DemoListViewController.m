//
//  DemoListViewController.m
//  GooglePlaces
//
//  Created by xiaoyuan on 2018/10/26.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "DemoListViewController.h"
#import <GooglePlaces/GooglePlaces.h>

// The cell reuse identifier we are going to use.
static NSString *const kCellIdentifier = @"DemoCellIdentifier";

@implementation DemoListViewController {
  DemoData *_demoData;
}

- (instancetype)initWithDemoData:(DemoData *)demoData {
  if ((self = [self init])) {
    _demoData = demoData;
    NSString *titleFormat =
        NSLocalizedString(@"App.NameAndVersion",
                          @"The name of the app to display in a navigation bar along with a "
                          @"placeholder for the SDK version number");
    self.title = [NSString stringWithFormat:titleFormat, [GMSPlacesClient SDKVersion]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Register a plain old UITableViewCell as this will be sufficient for our list.
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

/**
 * Private method which is called when a demo is selected. Constructs the demo view controller and
 * displays it.
 *
 * @param demo The demo to show.
 */
- (void)showDemo:(Demo *)demo {
  // Ask the demo to give us the view controller which contains the demo.
  UIViewController *viewController =
      [demo createViewControllerForSplitView:self.splitViewController];

  [self showDetailViewController:viewController sender:self];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _demoData.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _demoData.sections[section].demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Dequeue a table view cell to use.
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

  // Grab the demo object.
  Demo *demo = _demoData.sections[indexPath.section].demos[indexPath.row];

  // Configure the demo title on the cell.
  cell.textLabel.text = demo.title;

  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return _demoData.sections[section].title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Get the demo which was selected.
  Demo *demo = _demoData.sections[indexPath.section].demos[indexPath.row];

  [self showDemo:demo];
}

@end
