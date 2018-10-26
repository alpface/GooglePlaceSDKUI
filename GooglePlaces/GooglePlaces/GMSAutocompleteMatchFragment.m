//
//  GMSAutocompleteMatchFragment.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAutocompleteMatchFragment.h"

@interface GMSAutocompleteMatchFragment ()


@end

@implementation GMSAutocompleteMatchFragment
- (instancetype)initWithOffset:(NSUInteger)offset length:(NSUInteger)length
{
    if (self = [super init]) {
        _offset = offset;
        _length = length;
    }
    return self;
}

- (BOOL)isEqualToAutocompleteMatchFragment:(GMSAutocompleteMatchFragment *)arg2
{
    BOOL res = 0x0;
    if (arg2 != 0x0) {
        if (arg2.offset == self.offset && arg2.length == self.length) {
            res = 0x1;
        }
    }
    return res;

}

- (BOOL)isEqual:(id)object
{
    BOOL res = 0x0;
    if (self != object) {
        if ([object isKindOfClass:[GMSAutocompleteMatchFragment class]]) {
            res = [self isEqualToAutocompleteMatchFragment:object];
        }
        else {
            res = 0x0;
        }
    }
    else {
        res = 0x1;
    }
    return res;
}
- (NSUInteger)hash {
    NSString *stringToHash = [NSString stringWithFormat:@"%ld:%ld",_length,_offset];
    return [stringToHash hash];
}
@end
