//
//  MConstructionBaseController.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/14.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MConstructionBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray *datasource;

@end

NS_ASSUME_NONNULL_END
