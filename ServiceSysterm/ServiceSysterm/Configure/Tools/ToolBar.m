//
//  ToolBar.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ToolBar.h"

@implementation ToolBar

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 30);
        
        UIBarButtonItem *fixButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *finishButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
        
        self.items = @[fixButton,finishButton];
        
    }
    return self;
}

+ (instancetype)toolBar{
    
    return [[self alloc]init];
}

- (void)finish{
    
    if (self.finishBlock) {
        self.finishBlock();
    }
}

@end
