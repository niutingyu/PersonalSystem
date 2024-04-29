//
//  IQCCheckItemTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/9.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "IQCListModel.h"
#import "IqcBugModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IQCCheckItemTableCell : BaseTableViewCell

@property (nonatomic,strong)IQCListModel * listModel;

@property (nonatomic,strong)NSMutableArray *bugCodeList;

@end

NS_ASSUME_NONNULL_END
