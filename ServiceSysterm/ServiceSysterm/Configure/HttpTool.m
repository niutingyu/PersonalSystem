//
//  HttpTool.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "HttpTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@implementation HttpTool


+(void)login:(NSString*)url parm:(NSDictionary*)parm sucess:(SucceedBlock)sucessCallback error:(ErrorBlock)errorCallback{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    NSString *signStr = [NSString stringWithFormat:@"slclient%@slclient_canyou",timeString];
    
    signStr = [HttpTool MD5:signStr];
    
    signStr = [signStr stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    
    
    NSMutableDictionary *parmetersAll = [NSMutableDictionary dictionary];
    NSDictionary *baseParams = @{@"appkey":@"slclient",
                                 @"time":timeString,
                                 @"sign":signStr,
                                 @"loginuser":@"admin",
                                 
                                 
                                 };
    parmetersAll =[[NSMutableDictionary alloc]initWithDictionary:baseParams];
    [parmetersAll addEntriesFromDictionary:parm];
    debugLog(@"- - - -%@ %@",parmetersAll,url);
    [manager POST:url parameters:parmetersAll headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucessCallback) {
            sucessCallback(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            if (errorCallback) {
                errorCallback(error.localizedDescription);
            }
        }
    }];
//    [manager POST:url parameters:parmetersAll progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
}
+(void)POST:(NSString *)url param:(NSDictionary *)param success:(SucceedBlock)successCallback error:(ErrorBlock)errorCallback{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    NSString *signStr = [NSString stringWithFormat:@"slclient%@slclient_canyou",timeString];
    
    signStr = [HttpTool MD5:signStr];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    signStr = [signStr stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    
 
     NSMutableDictionary *parmetersAll = [NSMutableDictionary dictionary];
    NSDictionary *baseParams = @{@"appkey":@"slclient",
                                 @"time":timeString,
                                 @"sign":signStr,
                                 @"loginuser":USERDEFAULT_object(JOBNUM),
                                 @"MRequestTime":date,
                               
                                 };
     parmetersAll =[[NSMutableDictionary alloc]initWithDictionary:baseParams];
     [parmetersAll addEntriesFromDictionary:param];
    debugLog(@"parm = %@  url ==%@",parmetersAll,url);
 
    [manager POST:url parameters:parmetersAll headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successCallback) {
            successCallback(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            if (errorCallback) {
                errorCallback(error.localizedDescription);
            }
            [Units showErrorStatusWithString:error.localizedDescription];
        }
    }];
//    [manager POST:url parameters:parmetersAll progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}

//SB请求
+(void)POSTWithParms:(NSString *)url param:(NSDictionary *)param success:(SucceedBlock)successCallback error:(ErrorBlock)errorCallback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    NSString *signStr = [NSString stringWithFormat:@"slclient%@slclient_canyou",timeString];
    
    signStr = [HttpTool  MD5:signStr];
    signStr = [signStr stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
   
    NSDictionary *baseParams = @{@"appkey":@"slclient",
                                 @"time":timeString,
                                 @"loginuser":@"admin",
                                 @"sign":signStr,
                                 @"MRequestTime":date,
                                 };
    NSMutableDictionary *parmetersAll = [NSMutableDictionary dictionary];
    parmetersAll =[[NSMutableDictionary alloc]initWithDictionary:baseParams];
    [parmetersAll addEntriesFromDictionary:param];
    debugLog(@" - -- --%@ %@",parmetersAll,url);
    [manager POST:url parameters:parmetersAll headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successCallback) {
            successCallback(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            if (errorCallback) {
                errorCallback(error.localizedDescription);
            }
        }
    }];
//    [manager POST:url parameters:parmetersAll progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}
+(void)CanYouPostUrl:(NSString*)url parms:(NSDictionary*)parms sucess:(SucceedBlock)sucessCallBlock error:(ErrorBlock)errorCallBlcok{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    AFJSONResponseSerializer *reson = [AFJSONResponseSerializer serializer];
    reson.removesKeysWithNullValues = YES;
    reson.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.responseSerializer = reson;
     
     // 设置请求时间
     [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
     manager.requestSerializer.timeoutInterval = 30.f;
     [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
     
     
     NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
     
     NSTimeInterval a=[dat timeIntervalSince1970];
     
     NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
     
     NSString *signStr = [NSString stringWithFormat:@"slclient%@slclient_canyou",timeString];
     
     signStr = [HttpTool  MD5:signStr];
     signStr = [signStr stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
     
//     NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//     [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
//     NSString *date = [formatter stringFromDate:[NSDate date]];
     
    
     NSDictionary *baseParams = @{@"appkey":@"slclient",
                                  @"time":timeString,
                                  @"loginuser":@"admin",
                                  @"sign":signStr,
                                @"servicename":@"%E6%BC%94%E7%A4%BA%E7%89%88",
                                  @"hostname":@"hwG621-TL00"
                                  };
     NSMutableDictionary *parmetersAll = [NSMutableDictionary dictionary];
     parmetersAll =[[NSMutableDictionary alloc]initWithDictionary:baseParams];
     [parmetersAll addEntriesFromDictionary:parms];
     debugLog(@" - -- --%@ %@",parmetersAll,url);
    [manager POST:url parameters:parmetersAll headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucessCallBlock) {
            sucessCallBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            if (errorCallBlcok) {
                errorCallBlcok(error.localizedDescription);
            }
        }
    }];
//     [manager POST:url parameters:parmetersAll progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//     }];
}
+ (NSString *)MD5:(NSString *)mdStr {
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


+(void)get:(NSString*)urlString parms:(id)parms sucess:(SucceedBlock)sucessBlock error:(ErrorBlock)errorBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:urlString parameters:parms headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucessBlock) {
            sucessBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error.localizedDescription);
        }
    }];
//    [manager GET:urlString parameters:parms progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//       
//    }];
}

//封装Net
+(void)NetRequestWithUrl:(NSString*)url completion:(void(^)(NSMutableDictionary *jsonDict))complete{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (response==nil) {
        complete(nil);
    }else {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        if (dic)
        {
            if (complete)
            {
                complete(dic);
            }
        }
        
    }
}
//取消网络请求
+(void)CancelRequest{
    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    if (manager.tasks.count >0) {
        [manager .tasks makeObjectsPerformSelector:@selector(cancel)];
    }
    
}
@end
