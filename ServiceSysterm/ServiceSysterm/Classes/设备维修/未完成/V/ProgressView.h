//
//  ProgressView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView
-(instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr;
-(instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr grayColor:(UIColor *)grayColor lightColor:(UIColor *)lightColor;

///当前选中的index
@property(nonatomic,assign)NSUInteger index;
@end

NS_ASSUME_NONNULL_END
