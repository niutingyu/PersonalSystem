//
//  WasterDetailListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GarbageListModel.h"
#import "RecordEventModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WasterDetailListModel : NSObject

@property (nonatomic,strong)RecordEventModel*recordEvent;

@property (nonatomic,strong)NSArray<GarbageListModel*> *GarbageList;

@property (nonatomic,copy)NSString *QuanXian;

@end

@interface WasterBasicMessageModel : NSObject

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *content;


@end
NS_ASSUME_NONNULL_END
