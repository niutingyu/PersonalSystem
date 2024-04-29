//
//  DESegmentControl.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DESegmentControlDataSource <NSObject>

-(NSArray*)getSegmentControlTitles;

@end

@class DESegmentControl;
@protocol DESegmentControlDelegate <NSObject>

-(void)control:(DESegmentControl *)control didSelectedAtIndex:(NSInteger)index;

@end
@interface DESegmentControl : UIView
@property (nonatomic,weak) id<DESegmentControlDelegate>delegate;
@property (nonatomic,weak) id<DESegmentControlDataSource>dataSource;

@property (nonatomic,assign)CGFloat bottomHight;
-(void)didSectedIndex:(NSInteger)index;

@property (nonatomic, assign) NSInteger tapIndex;

@end

NS_ASSUME_NONNULL_END
