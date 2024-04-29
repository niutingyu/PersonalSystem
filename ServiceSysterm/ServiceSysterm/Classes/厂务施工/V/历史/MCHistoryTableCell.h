//
//  MCHistoryTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "MCListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCHistoryTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *departmentLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *constructionTypelab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *constructionDepartmentLab;

@property (weak, nonatomic) IBOutlet UILabel *countLab;


-(void)setupCellWithModel:(MCListModel*)model idx:(NSString*)idx;
@end

NS_ASSUME_NONNULL_END
