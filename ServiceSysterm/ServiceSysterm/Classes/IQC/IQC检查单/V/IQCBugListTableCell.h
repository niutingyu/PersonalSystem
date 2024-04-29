//
//  IQCBugListTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/10.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "IqcBugModel.h"
#import "IQCListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IQCBugListTableCell : BaseTableViewCell

-(void)configBugTableViewWithModel:(IqcTreatmentModel*)model number:(NSString*)number;

@property (nonatomic,strong)IqcTreatmentModel *treatmentModel;

@property (nonatomic,strong)IQCListModel *listModel;


@property (nonatomic,strong)UITextField *countTextf;


@property (nonatomic,strong)NSMutableArray *treatMentList;


@property (nonatomic,copy)void(^methodBlcok)(NSString *methodStr,NSString *methodIdStr);

@end

NS_ASSUME_NONNULL_END
