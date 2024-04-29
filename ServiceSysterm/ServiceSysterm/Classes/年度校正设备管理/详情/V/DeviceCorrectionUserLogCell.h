//
//  DeviceCorrectionUserLogCell.h
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DeviceCorrectionUserLogModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceCorrectionUserLogCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *msgLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (nonatomic,strong)DeviceCorrectionUserLogModel *model;

@end

NS_ASSUME_NONNULL_END
