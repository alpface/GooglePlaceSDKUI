//
//  GMSAutocompleteBoundsMode.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/22.
//  Copyright © 2018 alpface. All rights reserved.
//

/**
 * \defgroup AutocompleteBoundsMode GMSAutocompleteBoundsMode
 * @{
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN;

/**
 * Specifies how autocomplete should intGMSPret the |bounds| parameters.
 */
typedef NS_ENUM(NSUInteger, GMSAutocompleteBoundsMode) {
    /** IntGMSPret |bounds| as a bias. */
    kGMSAutocompleteBoundsModeBias,
    /** IntGMSPret |bounds| as a restrict. */
    kGMSAutocompleteBoundsModeRestrict
};

NS_ASSUME_NONNULL_END;

/**@}*/
