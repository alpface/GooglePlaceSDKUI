//
//  GMSAutocompleteFilter.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * \defgroup PlacesAutocompleteTypeFilter GMSPlacesAutocompleteTypeFilter
 * @{
 */

/**
 * EN: The type filters that may be applied to an autocomplete request to restrict results to different
 * types.
 *
 * 中文: 可应用于自动填充请求的类型过滤器，以将结果限制为不同类型。
 */
typedef NS_ENUM(NSInteger, GMSPlacesAutocompleteTypeFilter) {
    /**
     * All results.
     * 所有结果，不做任何过滤
     */
    kGMSPlacesAutocompleteTypeFilterNoFilter,
    /**
     * Geocoding results, as opposed to business results.
     * 与业务结果相反，地理编码产生结果。
     */
    kGMSPlacesAutocompleteTypeFilterGeocode,
    /**
     * Geocoding results with a precise address.
     * 具有精确地址的地理编码结果。
     */
    kGMSPlacesAutocompleteTypeFilterAddress,
    /**
     * Business results.
     * 行业结果
     */
    kGMSPlacesAutocompleteTypeFilterEstablishment,
    /**
     * Results that match the following types:
     * 符合以下类型的结果
     * "locality",
     * "sublocality"
     * "postal_code",
     * "country",
     * "administrative_area_level_1",
     * "administrative_area_level_2"
     */
    kGMSPlacesAutocompleteTypeFilterRegion,
    /**
     * Results that match the following types:
     * 符合以下类型的结果
     * "locality",
     * "administrative_area_level_3"
     */
    kGMSPlacesAutocompleteTypeFilterCity,
};

/**@}*/

/**
 * EN: This class represents a set of restrictions that may be applied to autocomplete requests. This
 * allows customization of autocomplete suggestions to only those places that are of interest.
 *
 * 中文: 此类表示可应用于自动完成请求的一组限制。 这个
 * 允许自定义自动填充建议仅限于那些感兴趣的地方。
 */
@interface GMSAutocompleteFilter : NSObject

/**
 * EN: The type filter applied to an autocomplete request to restrict results to different types.
 * Default value is kGMSPlacesAutocompleteTypeFilterNoFilter.
 *
 * 中文: 应用于自动填充请求的类型过滤器将结果限制为不同类型。
 * 默认值为kGMSPlacesAutocompleteTypeFilterNoFilter。
 */
@property(nonatomic, assign) GMSPlacesAutocompleteTypeFilter type;

/**
 * EN: The country to restrict results to. This should be a ISO 3166-1 Alpha-2 country code (case
 * insensitive). If nil, no country filtering will take place.
 *
 * 中文: 将结果限制为的国家/地区。 这应该是ISO 3166-1 Alpha-2国家代码（案例不敏感）。 如果为零，则不会进行国家/地区过滤。
 */
@property(nonatomic, copy, nullable) NSString *country;

@end

NS_ASSUME_NONNULL_END
