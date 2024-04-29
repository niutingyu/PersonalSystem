//
//  QCAppranceFormCollectionCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/26.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomRectLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCAppranceFormCollectionCell : UICollectionViewCell

@property (nonatomic,copy)NSString * text;

@property (nonatomic,strong)UIColor *labelColor;


@end

NS_ASSUME_NONNULL_END
