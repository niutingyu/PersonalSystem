//
//  HttpTool.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^SucceedBlock)(id responseObject);

typedef void(^ErrorBlock)(NSString *error);

@interface HttpTool : NSObject

+ (void)POST:(NSString *)url param:(NSDictionary *)param success:(SucceedBlock)successCallback error:(ErrorBlock)errorCallback;

+(void)login:(NSString*)url parm:(NSDictionary*)parm sucess:(SucceedBlock)sucessCallback error:(ErrorBlock)errorCallback;

+(void)POSTWithParms:(NSString *)url param:(NSDictionary *)param success:(SucceedBlock)successCallback error:(ErrorBlock)errorCallback;

+(void)CanYouPostUrl:(NSString*)url parms:(NSDictionary*)parms sucess:(SucceedBlock)sucessCallBlock error:(ErrorBlock)errorCallBlcok;

+(void)get:(NSString*)urlString parms:(id)parms sucess:(SucceedBlock)sucessBlock error:(ErrorBlock)errorBlock;

+(void)NetRequestWithUrl:(NSString*)url completion:(void(^)(NSMutableDictionary *jsonDict))complete;

+(void)CancelRequest;
@end

NS_ASSUME_NONNULL_END
