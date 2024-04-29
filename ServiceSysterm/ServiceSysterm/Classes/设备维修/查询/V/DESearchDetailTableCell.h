//
//  DESearchDetailTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DESortDetailMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DESearchDetailTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *codeNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *materialNameLab;
@property (weak, nonatomic) IBOutlet UILabel *facilityNameLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

-(void)confgiureCell:(DESortDetailMessageModel*)model rowIdx:(NSInteger)rowIdx datasource:(NSMutableArray*)datasource;

@end

NS_ASSUME_NONNULL_END
