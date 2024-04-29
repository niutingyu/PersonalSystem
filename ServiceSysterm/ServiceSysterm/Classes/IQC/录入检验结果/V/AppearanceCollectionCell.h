//
//  AppearanceCollectionCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/4.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppearanceCollectionCell : UICollectionViewCell

@property (nonatomic,strong)UIButton * typeBut;

@property (nonatomic,assign)CGFloat contentW;

@property (nonatomic,copy)NSString * title;


@end

NS_ASSUME_NONNULL_END
