//
//  AlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/3.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectedMaintainId)(NSString*,NSString*);
@interface AlertView : UIView
+(void)showAlertWithDatasource:(NSArray*)datasource maintainId:(selectedMaintainId)maintainId;

@property (nonatomic,copy)selectedMaintainId  maintainIdBlock;
@end

NS_ASSUME_NONNULL_END
