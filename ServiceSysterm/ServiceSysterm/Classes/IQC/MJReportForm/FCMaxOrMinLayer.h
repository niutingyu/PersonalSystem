//
//  FCMaxOrMinLayer.h
//  TestXXX
//
//  Created by Andy on 2021/6/3.
//

#import <QuartzCore/QuartzCore.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FCMaxOrMinLayerTypeMax,
    FCMaxOrMinLayerTypeMin,
} FCMaxOrMinLayerType;


@interface FCMaxOrMinLayer : CALayer

@property (nonatomic,assign)FCMaxOrMinLayerType type;

@end

NS_ASSUME_NONNULL_END
