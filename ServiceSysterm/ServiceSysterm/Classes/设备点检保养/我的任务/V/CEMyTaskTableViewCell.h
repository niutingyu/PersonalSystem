//
//  CEMyTaskTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/11.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CETaskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CEMyTaskTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (weak, nonatomic) IBOutlet UILabel *materialNameLab;

@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

-(void)configureCell:(NSMutableArray*)datasource rowIdx:(NSInteger)rowIdx model:(CETaskModel*)model;
@end

NS_ASSUME_NONNULL_END
