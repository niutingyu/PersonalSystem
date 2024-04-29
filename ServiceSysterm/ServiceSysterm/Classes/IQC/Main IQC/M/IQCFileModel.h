//
//  IQCFileModel.h
//  ServiceSysterm
//
//  Created by Andy on 2024/3/11.
//  Copyright © 2024 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IQCFileModel : BaseModel

@property (nonatomic,copy)NSString *Content;

@property (nonatomic,copy)NSString *CreatedBy;

@property (nonatomic,copy)NSString *CreatedOn;

@property (nonatomic,copy)NSString *FilePath;

@property (nonatomic,copy)NSString *FItemId;

@property (nonatomic,copy)NSString *FName;

@end

NS_ASSUME_NONNULL_END
