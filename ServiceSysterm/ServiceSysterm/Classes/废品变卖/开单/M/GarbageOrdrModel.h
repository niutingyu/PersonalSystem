//
//  GarbageOrdrModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GarbageOrdrModel : NSObject

//写的固定的
@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *place;

@property (nonatomic,copy)NSString *content;




@end

//写的固定的废品信息
@interface GarbageNameModel : NSObject

@property (nonatomic,copy)NSString *materName;

@property (nonatomic,copy)NSString *matal;

@property (nonatomic,copy)NSString *count;

@property (nonatomic,copy)NSString *nameContent;

@property (nonatomic,copy)NSString *matalContent;

@property (nonatomic,copy)NSString *countContent;

@property (nonatomic,copy)NSString *ID;

@end

//返回的废品信息
@interface WasterInformationModel : NSObject

@property (nonatomic,copy)NSString  *Code;

@property (nonatomic,copy)NSString *EnvironmentCode;

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *MetalCode;

@property (nonatomic,copy)NSString *Metals;

@property (nonatomic,copy)NSString *Name;

@property (nonatomic,copy)NSString *Pieces;

@property (nonatomic,copy)NSString *Remark;

@property (nonatomic,copy)NSString *Type;


@end

NS_ASSUME_NONNULL_END
