//
//  NSObject+KVOExtension.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "NSObject+KVOExtension.h"

@implementation NSObject (KVOExtension)
-(void)obsKey:(NSString *)key handler:(obsResultHandler)handler{
    [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:CFBridgingRetain([handler copy])];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if(object == self){
        obsResultHandler handler = (__bridge obsResultHandler)context;
        handler(change[@"new"],change[@"old"],self);
    }
}
@end
