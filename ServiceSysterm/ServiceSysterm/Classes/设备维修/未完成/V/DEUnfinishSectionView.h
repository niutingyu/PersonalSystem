//
//  DEUnfinishSectionView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DEUnfinishSectionView : UIView
@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UIButton * selecteBtn;
@property (nonatomic,copy)void(^open_closeBlock)(UIButton*,NSInteger sectionIdx);

@property (nonatomic,assign)NSInteger section;

@end

NS_ASSUME_NONNULL_END
