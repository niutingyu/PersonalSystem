//
//  DEResotreListTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEStockModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEResotreListTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *departmentLab;
@property (weak, nonatomic) IBOutlet UILabel *departProgressLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *time_timeLab;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
-(void)configureCell:(DEMatrialListModel*)model idx:(NSInteger)indexSection datasource:(NSMutableArray*)datasource;

-(void)configStockCell:(DEStockListModel*)model idx:(NSInteger)stockSection stockArray:(NSMutableArray*)stockArray;//回仓列表
@end

NS_ASSUME_NONNULL_END
