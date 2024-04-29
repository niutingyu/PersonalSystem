//
//  ArrowMarkButView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/5.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArrowMarkButView : UIView
@property (nonatomic,strong)UIButton * mainBut;

@property (nonatomic,strong)UIImageView * arrowMark;

@property (nonatomic,copy)void(^buttonBlock)(NSInteger butTag);


@end

NS_ASSUME_NONNULL_END
