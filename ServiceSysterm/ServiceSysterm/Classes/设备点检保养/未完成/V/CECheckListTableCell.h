//
//  CECheckListTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CEUnFinishModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CECheckListTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *maintainTypeLab;

@property (weak, nonatomic) IBOutlet UILabel *maintainStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *maiterialNameLab;
@property (weak, nonatomic) IBOutlet UILabel *avaliableTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
-(void)confiugeCell:(NSMutableArray*)datasource rowIdx:(NSInteger)rowIdx model:(CEUnFinishModel*)model;
@end

NS_ASSUME_NONNULL_END
