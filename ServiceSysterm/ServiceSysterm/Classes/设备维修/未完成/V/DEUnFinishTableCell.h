//
//  DEUnFinishTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/7.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEUnFinishModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEUnFinishTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *beginedTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *finishProgressLab;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;
-(void)configureCell:(DEUnfinishModel*)model datasource:(NSMutableArray*)datasource idx:(NSInteger)idx;
@end

NS_ASSUME_NONNULL_END
