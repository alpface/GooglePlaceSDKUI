//
//  GMSPlace.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class GMSAddressComponent;
@class GMSCoordinateBounds;


/**
 * \defgroup PlacesOpenNowStatus GMSPlacesOpenNowStatus
 * @{
 */

/**
 * EN: Describes the current open status of a place.
 * 中文: 描述一个地方的当前开放状态。
 */
typedef NS_ENUM(NSInteger, GMSPlacesOpenNowStatus) {
    /** The place is open now. */
    kGMSPlacesOpenNowStatusYes,
    /** The place is not open now. */
    kGMSPlacesOpenNowStatusNo,
    /** We don't know whether the place is open now. */
    kGMSPlacesOpenNowStatusUnknown,
};

/**
 * EN: The current language of a place.
 * 中文: 这个地方的语言。
 */
typedef NS_ENUM(NSInteger, GMSPlacesLang) {
    /**unkown, get phone language*/
    kGMSPlacesLangUnknown = 0,
    /** Chinese */
    kGMSPlacesLangCH = 4,
    /** english */
    kGMSPlacesLangEN = 8,
    /** French */
    kGMSPlacesLangFR = 10,
};

/**@}*/

/**
 * \defgroup PlacesPriceLevel GMSPlacesPriceLevel
 * @{
 */

/**
 * EN: Describes the price level of a place.
 * 中文: 描述一个地方的价格水平。
 */
typedef NS_ENUM(NSInteger, GMSPlacesPriceLevel) {
    kGMSPlacesPriceLevelUnknown = -1,
    kGMSPlacesPriceLevelFree = 0,
    kGMSPlacesPriceLevelCheap = 1,
    kGMSPlacesPriceLevelMedium = 2,
    kGMSPlacesPriceLevelHigh = 3,
    kGMSPlacesPriceLevelExpensive = 4,
};

/**@}*/

/**
 * EN: Represents a particular physical place. A GMSPlace encapsulates information about a physical
 * location, including its name, location, and any other information we might have about it. This
 * class is immutable.
 *
 * 中文: 代表一个特定的物理位置。 GMSPlace封装了有关物理的信息
 * 位置，包括其名称，位置以及我们可能拥有的任何其他信息。 这个
 * 类是不可变的。
 */
@interface GMSPlace : NSObject

/**
 * EN: Name of the place.
 *
 * 中文: 地名
 */
@property(nonatomic, copy, readonly) NSString *name;

/**
 * EN: Place ID of this place.
 
 * 中文: 这个地点的Place ID。
 */
@property(nonatomic, copy, readonly) NSString *placeID;

/**
 * EN: Location of the place. The location is not necessarily the center of the Place, or any
 * particular entry or exit point, but some arbitrarily chosen point within the geographic extent of
 * the Place.
 *
 * 中文: 这个地方的位置。 地点不一定是地方的中心，或任何地方
 * 特定的进入或退出点，但在地理范围内有一些任意选择的点
 * 地方。
 */
@property(nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;

/**
 * EN: Represents the open now status of the place at the time that the place was created.
 *
 * 中文: 表示创建场所时场所的现在打开状态。
 */
@property(nonatomic, readonly, assign) GMSPlacesOpenNowStatus openNowStatus;

/**
 * EN: Phone number of this place, in international format, i.e. including the country code prefixed
 * with "+".  For example, alpface's phone number is "+86 010-51664166".
 *
 * 中文: 该地点的电话号码，采用国际格式，即包括前缀的国家代码
 * 带“+”。 例如，旅图的电话号码为“+86 010-51664166”。
 */
@property(nonatomic, copy, readonly, nullable) NSString *phoneNumber;

/**
 * EN: Address of the place as a simple string.
 *
 * 中文: 地址字符串
 */
@property(nonatomic, copy, readonly, nullable) NSString *formattedAddress;

/**
 * EN: Five-star rating for this place based on user reviews.
 *
 * Ratings range from 1.0 to 5.0.  0.0 means we have no rating for this place (e.g. because not
 * enough users have reviewed this place).
 *
 * 中文: 根据用户评论，这个地方的五星级评级。
 *
 * 评级范围从1.0到5.0。 0.0表示我们对这个地方没有评级（例如因为没有
 * 足够的用户已经评论过这个地方）。
 */
@property(nonatomic, readonly, assign) float rating;

/**
 * EN: Price level for this place, as integers from 0 to 4.
 *
 * e.g. A value of 4 means this place is "$$$$" (expensive).  A value of 0 means free (such as a
 * museum with free admission).
 *
 * 中文: 此地点的价格水平，从0到4的整数。
 *
 * 例如 值为4表示此地点为“$$$$”（贵）。 值0表示空闲（例如a博物馆免费入场）。
 */
@property(nonatomic, readonly, assign) GMSPlacesPriceLevel priceLevel;

/**
 * EN: The types of this place.  Types are NSStrings, valid values are any types documented at
 *
 * 中文: 这个地方的类型。 类型是NSStrings，有效值是记录的任何类型
 */
@property(nonatomic, copy, readonly) NSArray<NSString *> *types;

/**
 * EN: Website for this place.
 *
 * 中文: 这个地方的网站。
 */
@property(nonatomic, copy, readonly, nullable) NSURL *website;

/**
 * EN: The data provider attribution string for this place.
 *
 * These are provided as a NSAttributedString, which may contain hyperlinks to the website of each
 * provider.
 *
 * In general, these must be shown to the user if data from this GMSPlace is shown, as described in
 * the Places API Terms of Service.
 *
 * 中文: 此地点的数据提供者归属字符串。
 *
 * 这些是作为NSAttributedString提供的，它可能包含指向每个网站的超链接提供者。
 *
 * 通常，如果显示来自此GMSPlace的数据，则必须向用户显示这些内容，如中所述Places API服务条款。
 */
@property(nonatomic, copy, readonly, nullable) NSAttributedString *attributions;

/**
 * The recommended viewport for this place. May be nil if the size of the place is not known.
 *
 * EN: This returns a viewport of a size that is suitable for displaying this place. For example, a
 * |GMSPlace| object representing a store may have a relatively small viewport, while a |GMSPlace|
 * object representing a country may have a very large viewport.
 *
 * 中文: 这将返回适合显示此位置的大小的视口。 例如a   | GMSPlace | 表示商店的对象可能具有相对较小的视口，而| GMSPlace |
 * 表示国家/地区的对象可能具有非常大的视口。
 */
@property(nonatomic, strong, readonly, nullable) GMSCoordinateBounds *viewport;

/**
 * EN: An array of |GMSAddressComponent| objects representing the components in the place's address.
 * These components are provided for the purpose of extracting structured information about the
 * place's address: for example, finding the city that a place is in.
 *
 * These components should not be used for address formatting. If a formatted address is required,
 * use the |formattedAddress| property, which provides a localized formatted address.
 *
 * 中文: | GMSAddressComponent |的数组 表示地点地址中组件的对象。
 * 提供这些组件是为了提取有关的结构化信息
 * 地点的地址：例如，找到一个地方所在的城市。
 *
 * 这些组件不应用于地址格式化。 如果需要格式化的地址，
 * 使用| formattedAddress | property，提供本地化的格式化地址。
 */
@property(nonatomic, copy, readonly, nullable) NSArray<GMSAddressComponent *> *addressComponents;

@end

NS_ASSUME_NONNULL_END
