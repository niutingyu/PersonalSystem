//
//  DeviceCorrectionTaskListCell.h
//  ServiceSysterm
//
//  Created by Andy on 2022/3/11.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DeviceCorrectionTaskListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceCorrectionTaskListCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *durationLab;
-(void)configureCellWithModel:(DeviceCorrectionTaskListModel*)model idx:(NSString*)idx;
@end

NS_ASSUME_NONNULL_END
