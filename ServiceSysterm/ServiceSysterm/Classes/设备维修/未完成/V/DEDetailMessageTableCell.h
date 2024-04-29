//
//  DEDetailMessageTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEUnfinishDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol DeDetailMessageCellDelegate <NSObject>

- (void)didChangeCell:(UITableViewCell *)cell;

@end
@interface DEDetailMessageTableCell : BaseTableViewCell
@property (nonatomic,strong)ExceptionModel * model;
@property (nonatomic,weak)id<DeDetailMessageCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
