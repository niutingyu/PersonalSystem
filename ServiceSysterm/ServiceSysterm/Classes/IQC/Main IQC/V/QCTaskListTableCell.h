//
//  QCTaskListTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/8.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQCListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCTaskListTableCell : UITableViewCell

-(void)setupQCTaskListCellWithModel:(IQCListModel*)model number:(NSString*)number;


-(void)configureCellWithIsSelected:(BOOL)IsSelected;
@end

NS_ASSUME_NONNULL_END
