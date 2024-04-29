//
//  SLResumeBasicMessageCell.h
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/19.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SLMaitainResumeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLResumeBasicMessageCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceCode;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *deviceLocation;
@property (weak, nonatomic) IBOutlet UILabel *deviceEnterTime;
@property (weak, nonatomic) IBOutlet UILabel *maitainTime;
@property (weak, nonatomic) IBOutlet UILabel *nextMaintainTime;
@property (nonatomic,strong)SLMaitainResumeModel *model;

@end

NS_ASSUME_NONNULL_END
