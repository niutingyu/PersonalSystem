//
//  DEMaterialTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEPickChosMaterialModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEMaterialTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *materialTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *materialCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *materialNameLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UILabel *stockLab;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;

@property (nonatomic,strong)DEPickChosMaterialModel * model;

@property (nonatomic,strong)NSMutableArray * materialArray;

@end

NS_ASSUME_NONNULL_END
