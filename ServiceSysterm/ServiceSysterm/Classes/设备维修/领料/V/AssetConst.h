//
//  AssetConst.h
//  SLPersonnelSystem
//
//  Created by Andy on 2019/4/22.
//  Copyright © 2019 深圳市深联电路有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 屏幕高度 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define DEFAULT_MAX_HEIGHT SCREEN_HEIGHT/3*2



//屏幕适配
/**当前设备对应375的比例*/
#define Ratio_375 (SCREEN_WIDTH/375.0)
/**转换成当前比例的数*/
#define Ratio(x) ((int)((x) * Ratio_375))

/** 入场出场动画时间 */
UIKIT_EXTERN const CGFloat SELAnimationTimeInterval;

/** 更新内容显示字体大小 */
UIKIT_EXTERN const CGFloat SELDescriptionFont;

/** 更新内容最大显示高度 */
UIKIT_EXTERN const CGFloat SELMaxDescriptionHeight;
