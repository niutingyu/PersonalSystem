//
//  WasterTaskListTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "WasterTaskListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WasterTaskListTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *departmentLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *visitorLab;
@property (weak, nonatomic) IBOutlet UILabel *duratationLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

-(void)configureTaskListCellWithModel:(WasterTaskListModel*)model idx:(NSInteger)indx count:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
