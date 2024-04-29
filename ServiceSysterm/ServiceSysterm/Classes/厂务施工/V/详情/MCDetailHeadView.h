//
//  MCDetailHeadView.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDetailHeadView : UIView

@property (nonatomic,strong)UILabel * titleLab;

@property (nonatomic,strong)UIButton * selecteBtn;

@property (nonatomic,copy)void(^open_closeBlock)(UIButton*);

@end

NS_ASSUME_NONNULL_END
