//
//  FCItemCollectionViewCell.h
//  SLPersonnelSystem
//
//  Created by Andy on 2019/4/4.
//  Copyright © 2019 深圳市深联电路有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

NS_ASSUME_NONNULL_END
