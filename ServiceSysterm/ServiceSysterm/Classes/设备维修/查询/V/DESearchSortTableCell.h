//
//  DESearchSortTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DESearchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DESearchSortTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *namLab;
@property (weak, nonatomic) IBOutlet UILabel *sortLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *materialNameLab;
@property (weak, nonatomic) IBOutlet UILabel *errorLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@property (weak, nonatomic) IBOutlet UILabel *numberLab;

-(void)configureCell:(DESortModel*)model rowIdx:(NSInteger)rowIdx datasource:(NSMutableArray*)datasource;
@end

NS_ASSUME_NONNULL_END
