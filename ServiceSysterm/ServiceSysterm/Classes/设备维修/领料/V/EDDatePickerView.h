//
//  EDDatePickerView.h
//  FlyWithAll
//
//  Created by Groupfly on 2016/11/17.
//  Copyright © 2016年 Groupfly. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DatePickerBlock)(NSString *str);

@interface EDDatePickerView : UIView

@property (nonatomic,copy) DatePickerBlock confirmBlock;
@property (nonatomic,copy) DatePickerBlock cancelBlock;
// 当前日期
@property (nonatomic,copy) NSString *currentDate;

+ (instancetype)datePickerView;

@end
