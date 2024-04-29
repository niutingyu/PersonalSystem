//
//  GarbageOrderHeadTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GarbageOrderHeadTableCell : BaseTableViewCell

@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UITextField *contentTextf;

-(void)configHeadCellWithIdx:(NSInteger)idx orderList:(NSMutableArray*)orderList;

@end

NS_ASSUME_NONNULL_END
