//
//  DeviceBaseController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * datasource;

@property (nonatomic,strong)ToolBar * tool;

@property (nonatomic,strong)NSDateFormatter * formatter;
@end

NS_ASSUME_NONNULL_END
