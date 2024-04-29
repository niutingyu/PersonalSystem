//
//  BaseTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell
- (NSString *)delayTime:(NSString *)time andEndTime:(NSString *)endTime;

-(NSString*)transferTime:(NSString*)timeString;
@end

NS_ASSUME_NONNULL_END
