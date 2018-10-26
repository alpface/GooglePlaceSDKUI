/*
 * Copyright 2016 Google Inc. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "AutocompletePushViewController.h"

#import <GooglePlaces/GooglePlaces.h>

@interface AutocompletePushViewController () <ERAutocompleteViewControllerDelegate>
@property(nonatomic, strong) ERAutocompleteViewController *autocompleteViewController;
@end

@implementation AutocompletePushViewController

+ (NSString *)demoTitle {
  return NSLocalizedString(
      @"Demo.Title.Autocomplete.Push",
      @"Title of the pushed autocomplete demo for display in a list or nav header");
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  // Configure the UI. Tell our superclass we want a button and a result view below that.
  UIButton *button =
      [self createShowAutocompleteButton:@selector(showAutocompleteWidgetButtonTapped)];
  [self addResultViewBelow:button];
}

#pragma mark - Getters/Setters

- (ERAutocompleteViewController *)autocompleteViewController {
  if (_autocompleteViewController == nil) {
    _autocompleteViewController = [[ERAutocompleteViewController alloc] init];
    _autocompleteViewController.delegate = self;
  }
  return _autocompleteViewController;
}

#pragma mark - Actions

- (IBAction)showAutocompleteWidgetButtonTapped {
  // When the button is tapped just push the autocomplete view controller onto the stack.
  [self.navigationController pushViewController:self.autocompleteViewController animated:YES];
}

#pragma mark - ERAutocompleteViewControllerDelegate

- (void)viewController:(ERAutocompleteViewController *)viewController
    didAutocompleteWithPlace:(ERPlace *)place {
  // Dismiss the view controller and tell our superclass to populate the result view.
  [self.navigationController popToViewController:self animated:YES];
  [self autocompleteDidSelectPlace:place];
}

- (void)viewController:(ERAutocompleteViewController *)viewController
    didFailAutocompleteWithError:(NSError *)error {
  // Dismiss the view controller and notify our superclass of the failure.
  [self.navigationController popToViewController:self animated:YES];
  [self autocompleteDidFail:error];
}

- (void)wasCancelled:(ERAutocompleteViewController *)viewController {
  // Dismiss the controller and show a message that it was canceled.
  [self.navigationController popToViewController:self animated:YES];
  [self autocompleteDidCancel];
}

- (void)didRequestAutocompletePredictions:(ERAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(ERAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
