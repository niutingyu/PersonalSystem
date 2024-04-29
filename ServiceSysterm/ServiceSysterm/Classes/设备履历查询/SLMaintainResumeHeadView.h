//
//  SLMaintainResumeHeadView.h
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/19.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLMaintainResumeHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *basicMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintainCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintianTimeLabel;

@end

NS_ASSUME_NONNULL_END
