//
//  WasterInformationTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/20.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WasterInformationTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentTextf;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

-(void)configureCellWithIdx:(NSString*)idx list:(NSMutableArray*)informationList row:(NSInteger)indxRow;
@end

NS_ASSUME_NONNULL_END
