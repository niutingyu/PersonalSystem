//
//  WasterAddInforModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/20.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WasterAddInforModel : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *place;

@property (nonatomic,copy)NSString *content;

@property (nonatomic,copy)NSString *code;

@end

//废品类别
@interface WasterTypeModel : NSObject

@property (nonatomic,copy)NSString *Code;

@property (nonatomic,copy)NSString *CreatedBy;

@property (nonatomic,copy)NSString *CreatedOn;

@property (nonatomic,copy)NSString *EnumDataId;

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *Name;

@property (nonatomic,copy)NSString *Remark;

@end

//参考金属

@interface WasterMatalModel : NSObject

@property (nonatomic,copy)NSString *Code;

@property (nonatomic,copy)NSString *CreatedBy;

@property (nonatomic,copy)NSString *CreatedOn;


@property (nonatomic,copy)NSString *EnumDataId;

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *Name;

@property (nonatomic,copy)NSString *Remark;

@property (nonatomic,copy)NSString *Sort;

@property (nonatomic,copy)NSString *Status;
@end
NS_ASSUME_NONNULL_END
