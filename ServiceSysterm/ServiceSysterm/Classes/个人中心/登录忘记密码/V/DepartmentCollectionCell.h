//
//  DepartmentCollectionCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DepartmentCollectionCell : UICollectionViewCell
-(void)cofigureCell:(NSMutableArray*)datasource itemIdx:(NSInteger)itemIdx model:(MemberModel*)model;

-(void)congiureCell;
@property (nonatomic,copy)void(^backBlock)(void);
@property (nonatomic,strong)UITextField * departmentTextField;
@property (strong,nonatomic)UITextField * jobTextField;
@property (strong,nonatomic)UITextField * nameTextField;
@end

NS_ASSUME_NONNULL_END
