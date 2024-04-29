//
//  MaintainResumeHomeController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/3/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MaintainResumeHomeController.h"
#import "MaintainResumeSearchController.h"

#import "SLMaitainResumeModel.h"
#import "SLResumeListModel.h"

#import "SLMaintainResumeCell.h"
#import "SLResumeBasicMessageCell.h"
#import "SLMaintainResumeHeadView.h"

#import "DEUnfinishDetailController.h"
#import "SGQRCodeWebController.h"

#import <AVFoundation/AVFoundation.h>
@interface MaintainResumeHomeController ()

@end

@implementation MaintainResumeHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"设备履历查询";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view  addSubview:self.tableView];
    self.tableView.defaultNoDataText=@"欢迎进入设备履历表查询";
    
    
    /**
        注册cell
        */
       [self.tableView registerNib:[UINib nibWithNibName:@"SLResumeBasicMessageCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
       [self.tableView registerNib:[UINib nibWithNibName:@"SLMaintainResumeCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    //一个扫描二维码  一个筛选
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectedMethod)];
    UIBarButtonItem *rigthItem2 =[[UIBarButtonItem alloc]initWithTitle:@"扫码" style:UIBarButtonItemStylePlain target:self action:@selector(camaraMethod)];
    NSArray * arr =@[rightItem1,rigthItem2];
    self.navigationItem.rightBarButtonItems = arr;
    
}

//扫码
-(void)camaraMethod{
    SGQRCodeWebController * controller =[SGQRCodeWebController new];
       [self QRCodeScanVC:controller];
       
       KWeakSelf
    controller.passScanResultBlock = ^(NSString * _Nonnull keyString) {
      if (keyString.length >0) {
         //请求设备履历接口
            [weakSelf getNetWithFacilityCode:keyString];
        }
    };
}


//筛选
-(void)selectedMethod{
    MaintainResumeSearchController * controller =[MaintainResumeSearchController new];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
    KWeakSelf
    controller.keyBlock = ^(NSString * _Nonnull deviceName, NSString * _Nonnull deviceCode) {
        [weakSelf loadResumeMethodWithCode:deviceCode deviceName:deviceName];
    };
}

/**
 UitableView
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else{
        SLMaitainResumeModel * model = [self.datasource firstObject];
        return model.list.count;
        
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.datasource.count ==0) {
        return 0;
    }
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        SLResumeBasicMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        SLMaitainResumeModel  * model = [self.datasource firstObject];
        cell.model =model;
       
        
        return cell;
    }else{
        SLMaintainResumeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        SLMaitainResumeModel * model = [self.datasource firstObject];
        NSArray * list = model.list;
        SLResumeListModel * subModel = list[indexPath.row];
        cell.model = subModel;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SLMaintainResumeHeadView * headView = [[NSBundle mainBundle]loadNibNamed:@"SLMaintainResumeHeadView" owner:self options:nil].firstObject;
    if (section ==0) {
        headView.basicMessageLabel.text = @"设备基本信息";
        headView.maintianTimeLabel.hidden = YES;
        headView.maintainCountLabel.hidden = YES;
       
    }else{
        SLMaitainResumeModel * model = [self.datasource firstObject];
        headView.basicMessageLabel.text = @"设备履历";
        headView.maintianTimeLabel.hidden = NO;
        headView.maintainCountLabel.hidden = NO;
        headView.maintianTimeLabel.text = [NSString stringWithFormat:@"维修耗时:%@(分)",model.MaintTime?:@""];
       headView.maintianTimeLabel.attributedText= [Units changeLabel:@"(分)" wholeString:headView.maintianTimeLabel.text font:[UIFont systemFontOfSize:13] color:[UIColor whiteColor]];
      
        
        headView.maintainCountLabel.text = [NSString stringWithFormat:@"维修单数:%@",model.MaintCount?:@""];
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1) {
        //判断是点检单还是维修单
        DEUnfinishDetailController * controller = [DEUnfinishDetailController new];
        SLMaitainResumeModel * model = [self.datasource firstObject];
        NSArray * models = model.list;
        SLResumeListModel *subModel = models[indexPath.row];
        if ([subModel.MaintainFaultName isEqualToString:@"点检"]||[subModel.MaintainFaultName isEqualToString:@"保养"]) {
            controller.controllerType = @"设备点检保养";
        }else{
            controller.controllerType =@"设备维修";
        }
        controller.maintainId = subModel.TaskId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(void)loadResumeMethodWithCode:(NSString*)deviceCode deviceName:(NSString*)deviceName{
   NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:deviceName?:@"" forKey:@"Name"];
    [parms setObject:deviceCode?:@"" forKey:@"Code"];
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    NSString * url =@"maint/maintaintask/getAllMaintainFacility";
    [HttpTool CanYouPostUrl:[url getWholeUrl] parms:parms sucess:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        /**
         转为json
         */
        NSArray * jsonArr = [Units jsonToArray:responseObject[@"data"]];
        NSString * facilityCode;
        for (NSDictionary * dict in jsonArr) {
            facilityCode = dict[@"FacilityCode"];
        }
        if (facilityCode.length >0) {
          [weakSelf getNetWithFacilityCode:facilityCode];
        }
        debugLog(@" == = %@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showStatusWithStutas:error];
    }];
}

-(void)getNetWithFacilityCode:(NSString*)code{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    [parm setObject:code forKey:@"Code"];
    [parm setObject:@"1" forKey:@"type"];
    [parm setObject:@"1" forKey:@"FactoryId"];
    [parm setObject:@"1" forKey:@"deviceType"];
    

    KWeakSelf
    [Units showLoadStatusWithString:@"加载中..."];
    NSString * url = @"maint/maintaintask/getMaintList";
    [HttpTool CanYouPostUrl:[url getWholeUrl] parms:parm sucess:^(id  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSString * jsonString = responseObject[@"data"];
            //json字符串转化为字典
            NSDictionary *jsonDict = [Units jsonToDictionary:jsonString];
            //取出list中的数据转为model
            SLMaitainResumeModel * model = [SLMaitainResumeModel mj_objectWithKeyValues:jsonDict];
            [weakSelf.datasource addObject:model];
            [weakSelf.tableView reloadData];
            
        }
        debugLog(@" ==    - - -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        debugLog(@" = == = == =error%@",error);
    }];
   
      
   
}
- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 -打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
