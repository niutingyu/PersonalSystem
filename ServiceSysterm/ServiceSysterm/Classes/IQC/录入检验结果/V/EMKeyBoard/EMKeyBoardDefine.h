//
//  EMKeyBoardDefine.h
//  XXXXXXXXX
//
//  Created by Andy on 2021/9/18.
//

#import "UIColor+EMColor.h"

#define kEMScreenWidth [UIScreen mainScreen].bounds.size.width
//键盘高度
#define kEMCustomKeyboardHeight 220
//数字键盘高度
#define kEMNumberKeyboardBtnHeight kEMCustomKeyboardHeight / 4
//字母键盘按钮水平间距
#define kEMASCIIKeyboardBtnHorizontalSpace 5
//字母键盘按钮垂直间距
#define kEMASCIIKeyboardBtnVerticalSpace 10
//字母键盘高度
#define kEMASCIIKeyboardBtnHeight (kEMCustomKeyboardHeight- kEMASCIIKeyboardBtnVerticalSpace*4)/4
//字母键盘按钮圆角
#define kEMASCIIKeyboardBtnCornerRadius 5
//数字键盘边框宽度
#define kEMASCIIKeyboardBtnBorderWith 0.5
//键盘背景色
#define kEMKeyboardViewBackgroundColor [UIColor colorWithHex:@"f1f1f1"]
//数字键盘边框颜色
#define kEMKeyboardBtnLayerColor [UIColor colorWithHex:@"dadada"]
//键盘按钮高亮状态颜色
#define kEMKeyboardBtnHighhlightColor [UIColor colorWithHex:@"d2d2d2"]
//有背景的按钮颜色
#define kEMKeyboardBtnDefaultColor [UIColor colorWithHex:@"e5e5e5"]
//白色背景按钮颜色
#define kEMKeyboardBtnWhiteColor [UIColor whiteColor]
//深色字体
#define kEMKeyboardBtnDarkTitleColor [UIColor colorWithHex:@"000000"]
//浅色字体
#define kEMKeyboardBtnLightTitleColor [UIColor colorWithHex:@"3d3d3d"]
//大字体
#define kEMKeyboardBtnBigFont [UIFont systemFontOfSize:24]
//小字体
#define kEMKeyboardBtnSmallFont [UIFont systemFontOfSize:18]
typedef NS_ENUM(NSInteger,EMKeyboardButtonType) {
    EMKeyboardButtonTypeNone = 10000,
    EMKeyboardButtonTypeNumber,
    EMKeyboardButtonTypeLetter,
    EMKeyboardButtonTypeDelete,
    EMKeyboardButtonTypeResign,
    EMKeyboardButtonTypeDecimal,
    EMKeyboardButtonTypeABC,
    EMKeyboardButtonTypeComplete,
    EMKeyboardButtonTypeComma,
    EMKeyboardButtonTypeToggleCase,
    EMKeyboardButtonTypeASCIIDelete,
    EMKeyboardButtonTypeToNumber,
    EMKeyboardButtonTypeASCIISpace,
    EMKeyboardButtonTypeASCIIResign,
    EMKeyboardButtonTypeASCIIDecimal,
    EMKeyboardButtonTypeStockHeader600,
    EMKeyboardButtonTypeStockHeader601,
    EMKeyboardButtonTypeStockHeader000,
    EMKeyboardButtonTypeStockHeader002,
    EMKeyboardButtonTypeStockHeader300,
    EMKeyboardButtonTypeStockHeader00,
    EMKeyboardButtonTypeStockPositionFull,
    EMKeyboardButtonTypeStockPositionHalf,
    EMKeyboardButtonTypeStockPositionOneThird,
    EMKeyboardButtonTypeStockPositionQuartern,
};

//#ifndef EMKeyBoardDefine_h
//#define EMKeyBoardDefine_h
//
//
//#endif /* EMKeyBoardDefine_h */
