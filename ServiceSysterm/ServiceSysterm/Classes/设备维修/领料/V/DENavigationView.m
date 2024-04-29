//
//  DENavigationView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DENavigationView.h"

@implementation DENavigationView

- (void)layoutSubviews {
    [super layoutSubviews];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        for (UIView *view in self.subviews) {
            if([NSStringFromClass([view class]) containsString:@"Background"]) {
                view.frame = self.bounds;
            }
            else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
                CGRect frame = view.frame;
                frame.origin.y = kIs_iPhoneX ? 44 : 20;
                frame.size.height = self.bounds.size.height - frame.origin.y;
                view.frame = frame;
            }
        }
    }
#endif
}

@end
