//
//  HandleTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/7/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HandleTaskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HandleTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *handLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *TTLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

-(void)congigureCellContent:(HandleTaskModel*)model rows:(NSInteger)rows models:(NSMutableArray*)models;
@end

NS_ASSUME_NONNULL_END
