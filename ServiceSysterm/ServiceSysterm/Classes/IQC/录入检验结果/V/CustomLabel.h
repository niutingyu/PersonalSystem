//
//  CustomLabel.h
//  ServiceSysterm
//
//  Created by Andy on 2022/1/6.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSubmitMainModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomLabel : UILabel

@property (nonatomic,strong)QCDetailListModel *detailModel;

@end

NS_ASSUME_NONNULL_END
