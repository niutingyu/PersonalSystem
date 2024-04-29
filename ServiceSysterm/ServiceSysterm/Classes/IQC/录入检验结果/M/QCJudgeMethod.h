//
//  QCJudgeMethod.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/29.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCDetailListModel.h"
#import "QCSubmitMainModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCJudgeMethod : NSObject

+(void)calculateWithName:(NSString*)name listModel:(QCDetailListModel*)listModel mainModel:(QCSubmitMainModel*)mainModel idx:(NSInteger)idx;

+(void)diagonalCalculateWithName:(NSString*)name listModel:(QCDetailListModel*)listModel mainModel:(QCSubmitMainModel*)mainModel;


@end

NS_ASSUME_NONNULL_END
