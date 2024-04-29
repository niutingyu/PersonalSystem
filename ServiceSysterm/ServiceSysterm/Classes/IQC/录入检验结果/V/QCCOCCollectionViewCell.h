//
//  QCCOCCollectionViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/9/29.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCCOCCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *customLabel;

@property (nonatomic,copy)NSString *text;

@property (nonatomic,assign)BOOL isedit;

@end

NS_ASSUME_NONNULL_END
