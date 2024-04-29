//
//  MemberAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MemberAlertView : UIView
+(void)showAlertViewModel:(PeopleListModel*)model;
@end

NS_ASSUME_NONNULL_END
