//
//  QCAppearanceTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "QCSubmitMainModel.h"
NS_ASSUME_NONNULL_BEGIN

@class  QCAppearanceTableCell;
@protocol appearanceDelegate <NSObject>



-(void)didSelectedRowAtIndexPath:(NSIndexPath*)indexPath pathSection:(NSInteger)pathSection;

@end

@interface QCAppearanceTableCell : BaseTableViewCell


@property (nonatomic,weak)id<appearanceDelegate>delegate;



@property (nonatomic,strong)NSMutableArray * stringList;

@property (nonatomic,strong)QCSubmitMainModel * mainModel;



/**
 外观检查数组
 */
@property (nonatomic,strong)NSMutableArray * appranceList;


@property (nonatomic,copy)NSString *operationTypeStr;

@end

NS_ASSUME_NONNULL_END
