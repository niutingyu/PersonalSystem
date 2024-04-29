//
//  DEStockContentController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DERootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEStockContentController : DERootViewController

@property (nonatomic,assign)NSInteger controllerTag;

-(void)reloadMessageWithUrl:(NSString*)url parms:(NSMutableDictionary*)parms flag:(NSInteger)flag;

- (NSString *)getNowDate:(NSInteger)mounth;
-(void)getTime:(NSNotification*)notification;
@end

NS_ASSUME_NONNULL_END
