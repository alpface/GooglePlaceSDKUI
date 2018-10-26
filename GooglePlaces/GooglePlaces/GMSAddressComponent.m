//
//  GMSAddressComponent.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAddressComponent.h"

@interface GMSAddressComponent ()

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *name;

@end

@implementation GMSAddressComponent
- (instancetype)initWithType:(NSString *)type name:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
        _type = type;
    }
    return self;
}

- (BOOL)isEqualToAddressComponent:(GMSAddressComponent *)object
{
    BOOL res = 0x0;
    if (object != 0x0) {
        if ([object.type isEqualToString:self.type] && [object.name isEqualToString:self.name]) {
            res = 0x1;
        }
    }
    else {
        res = 0x0;
    }
    return res;
}

- (BOOL)isEqual:(id)object
{
    BOOL res = 0x0;
    if (object != self) {
        if ([object isKindOfClass:[GMSAddressComponent class]]) {
            res = [self isEqualToAddressComponent:object];
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
    NSString *stringToHash = [NSString stringWithFormat:@"%@:%@",_name,_type];
    return [stringToHash hash];
}

@end
