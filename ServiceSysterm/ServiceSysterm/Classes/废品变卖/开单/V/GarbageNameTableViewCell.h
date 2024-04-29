//
//  GarbageNameTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GarbageNameTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *nameTextf;
@property (weak, nonatomic) IBOutlet UILabel *matalLab;
@property (weak, nonatomic) IBOutlet UITextField *matalTextf;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UITextField *countTextf;

-(void)configGarbageNameCellWithIdx:(NSInteger)idx nameList:(NSMutableArray*)nameList;

@end

NS_ASSUME_NONNULL_END
