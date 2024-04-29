//
//  DEChosMaterialSearchView.h
//  ServiceSysterm
//
//  Created by Andy on 2020/7/21.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DEChosMaterialSearchView : UIView
@property (weak, nonatomic) IBOutlet UITextField *materialInfoText;
@property (weak, nonatomic) IBOutlet UITextField *materialCodeText;

@property (weak, nonatomic) IBOutlet UITextField *materialNameText;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic,copy)void(^searchBlock)(NSString*materialInfo,NSString*materialName,NSString*materialCode);
@end

NS_ASSUME_NONNULL_END
