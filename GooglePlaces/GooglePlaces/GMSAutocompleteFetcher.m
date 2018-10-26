//
//  GMSAutocompleteFetcher.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAutocompleteFetcher.h"
#import "GMSAutocompleteFilter.h"
#import  "GMSPlacesClient.h"

@interface GMSAutocompleteFetcher ()
{
    NSString *_delayedRequest;
    BOOL _isDelayingRequests;
    unsigned int _requestCount;
    unsigned int _errorCount;
    unsigned int _textChangedCount;
}

@property(readonly, nonatomic) unsigned int errorCount;
@property(nonatomic) BOOL isWaitingForPredictions;
@property(nonatomic) unsigned int requestCount;
@property(copy, nonatomic) NSString *requestSource;
@property(readonly, nonatomic) unsigned int textChangedCount;
@property (nonatomic, copy) NSString *currentSearchText;

@end

@implementation GMSAutocompleteFetcher
- (instancetype)init
{
    return [self initWithBounds:nil filter:nil];
}

- (instancetype)initWithBounds:(GMSCoordinateBounds *)bounds filter:(GMSAutocompleteFilter *)filter
{
    if (self = [super init]) {
        self.autocompleteBounds = bounds;
        self.autocompleteFilter = filter;
    }
    return self;
}

- (instancetype)initWithBounds:(GMSCoordinateBounds *)bounds filter:(GMSAutocompleteFilter *)filter requestSource:(NSString *)requestSource
{
    if (self = [self init]) {
        [self configureWithBounds:bounds filter:filter requestSource:requestSource];
    }
    return self;
}

- (void)configureWithBounds:(GMSCoordinateBounds *)bounds filter:(GMSAutocompleteFilter *)filter requestSource:(NSString *)requestSource
{
    self.autocompleteBounds = bounds;
    self.autocompleteFilter = filter;
    self.requestSource = requestSource;
    self.autocompleteBoundsMode = 0x0;
    _isWaitingForPredictions = 0x0;
}

- (void)sourceTextHasChanged:(NSString *)text
{
    _currentSearchText = text;
    _textChangedCount += 1;
    [self sendOrDelayRequest:_currentSearchText];
}

- (void)sendOrDelayRequest:(NSString *)text
{
    if (_isDelayingRequests != 0x0) {
        _delayedRequest = text;
    }
    else {
        [self requestAutocompleteResultsWithText:text];
    }
}

- (void)requestAutocompleteResultsWithText:(NSString *)text
{
    _isWaitingForPredictions = 0x1;
    if ([self.delegate respondsToSelector:@selector(willAutocompleteWithPredictions)]) {
        [self.delegate willAutocompleteWithPredictions];
    }
    if (text.length != 0x0) {
        // 查询
        _requestCount++;
        __weak typeof(self) weakSelf = self;
        [[GMSPlacesClient sharedClient] autocompleteQuery:text bounds:self.autocompleteBounds boundsMode:self.autocompleteBoundsMode filter:self.autocompleteFilter callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
            if ([weakSelf.currentSearchText isEqualToString:text]) {
                weakSelf.isWaitingForPredictions = NO;
                if (error == nil) {
                    [weakSelf.delegate didAutocompleteWithPredictions:results];
                }
                else {
                    [weakSelf.delegate didFailAutocompleteWithError:error];
                }
            }
            else {
                //  搜索结果已经与当前搜索的关键字不相同，不刷新数据
            }
        }];
    }
    else {
        _isWaitingForPredictions = NO;
        [self.delegate didAutocompleteWithPredictions:@[]];
    }
}

@end
