//
//  GarbageListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GarbageListModel : NSObject

@property (nonatomic,copy)NSString *Code;

@property (nonatomic,copy)NSString *Count;

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *MetalCode;

@property (nonatomic,copy)NSString *Metals;

@property (nonatomic,copy)NSString *Name;

@property (nonatomic,copy)NSString *Pieces;

@property (nonatomic,copy)NSString *Type;

@property (nonatomic,copy)NSString *TypeName;

@property (nonatomic,copy)NSString *WasteInformationId;

@property (nonatomic,copy)NSString *WasteSaleId;

@property (nonatomic,copy)NSString *Concentration;


@end

NS_ASSUME_NONNULL_END
