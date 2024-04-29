//
//  HRBaseViewController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * listView;

@property (nonatomic,strong)NSMutableArray * datasource;
@end

NS_ASSUME_NONNULL_END
