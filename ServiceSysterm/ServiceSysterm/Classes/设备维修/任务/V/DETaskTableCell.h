//
//  DETaskTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/7.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DeTaskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DETaskTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *departmentLab;
@property (weak, nonatomic) IBOutlet UILabel *departmentCheckLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *checkProgressLab;
@property (weak, nonatomic) IBOutlet UILabel *checkTimeLab;
//@property (weak, nonatomic) IBOutlet UILabel *placeLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

-(void)configureCell:(NSMutableArray*)datasource rowIdx:(NSInteger)rowIdx ;
@end

NS_ASSUME_NONNULL_END
