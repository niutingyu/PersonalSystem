//
//  MCMyTaskTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/17.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MCListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCMyTaskTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *processLab;

@property (weak, nonatomic) IBOutlet UILabel *timeSlotLab;
@property (weak, nonatomic) IBOutlet UILabel *checkTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

-(void)setupCellWithModel:(MCListModel*)model idx:(NSString*)idx;
@end

NS_ASSUME_NONNULL_END
