//
//  IQCDatePickerView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/9.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPopupMenuPath.h"
NS_ASSUME_NONNULL_BEGIN



/**
 箭头方向优先级

 当控件超出屏幕时会自动调整成反方向
 */
typedef NS_ENUM(NSInteger , IqcPopupMenuPriorityDirection) {
    IqcPopupMenuPriorityDirectionTop = 0,  //Default
    IqcPopupMenuPriorityDirectionBottom,
    IqcPopupMenuPriorityDirectionLeft,
    IqcPopupMenuPriorityDirectionRight,
    IqcPopupMenuPriorityDirectionNone      //不自动调整
};

@class IQCDatePickerView;
@protocol IQCPickViewDelegate <NSObject>

@optional

- (void)IqcPopupMenuBeganDismiss;
- (void)IqcPopupMenuDidDismiss;
- (void)IqcPopupMenuBeganShow;
- (void)IqcPopupMenuDidShow;

@end

@interface IQCDatePickerView : UIView

/**
 圆角半径 Default is 5.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 自定义圆角 Default is UIRectCornerAllCorners
 
 当自动调整方向时corner会自动转换至镜像方向
 */
@property (nonatomic, assign) UIRectCorner rectCorner;

/**
 是否显示阴影 Default is YES
 */
@property (nonatomic, assign , getter=isShadowShowing) BOOL isShowShadow;

/**
 是否显示灰色覆盖层 Default is YES
 */
@property (nonatomic, assign) BOOL showMaskView;

/**
 选择菜单项后消失 Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnSelected;

/**
 点击菜单外消失  Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnTouchOutside;

/**
 设置显示模式 Default is YBPopupMenuTypeDefault
 */
//@property (nonatomic, assign) YBPopupMenuType type;

/**
 设置偏移距离 (>= 0) Default is 0.0
 */
@property (nonatomic, assign) CGFloat offset;

/**
 边框宽度 Default is 0.0
 
 设置边框需 > 0
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 边框颜色 Default is LightGrayColor
 
 borderWidth <= 0 无效
 */
@property (nonatomic, strong) UIColor * borderColor;

/**
 箭头宽度 Default is 15
 */
@property (nonatomic, assign) CGFloat arrowWidth;

/**
 箭头高度 Default is 10
 */
@property (nonatomic, assign) CGFloat arrowHeight;

/**
 箭头位置 Default is center
 
 只有箭头优先级是YBPopupMenuPriorityDirectionLeft/YBPopupMenuPriorityDirectionRight/YBPopupMenuPriorityDirectionNone时需要设置
 */
@property (nonatomic, assign) CGFloat arrowPosition;

/**
 箭头方向 Default is YBPopupMenuArrowDirectionTop
 */
@property (nonatomic, assign) YBPopupMenuArrowDirection arrowDirection;

/**
 箭头优先方向 Default is YBPopupMenuPriorityDirectionTop
 
 当控件超出屏幕时会自动调整箭头位置
 */
@property (nonatomic, assign) IqcPopupMenuPriorityDirection priorityDirection;

/**
 item的高度 Default is 44;
 */
@property (nonatomic, assign) CGFloat itemHeight;



/**
 代理
 */
@property (nonatomic, weak) id <IQCPickViewDelegate> delegate;



+(IQCDatePickerView*)showRelyOnView:(UIView *)view ;

@end

NS_ASSUME_NONNULL_END
