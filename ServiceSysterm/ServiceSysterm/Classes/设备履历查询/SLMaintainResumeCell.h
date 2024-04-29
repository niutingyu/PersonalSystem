//
//  SLMaintainResumeCell.h
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/19.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SLMaitainResumeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLMaintainResumeCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *maintainTime;
@property (weak, nonatomic) IBOutlet UILabel *operationName;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@property (weak, nonatomic) IBOutlet UILabel *changeDeviceLabel;




@property (nonatomic,strong)SLResumeListModel *model;
@end

NS_ASSUME_NONNULL_END
