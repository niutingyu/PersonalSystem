//
//  DEChosMessageController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEChosMessageController.h"

#import "DESearchView.h"
#import "DECommitTableCell.h"
#import "ZTLetterIndex.h"
#import "NSString+PinYin.h"
#import <IQKeyboardManager.h>

#import <AVFoundation/AVFoundation.h>
#import "SGQRCodeWebController.h"
@interface DEChosMessageController ()
{
    ZTLetterIndex * _letterIndex;
    NSString *_condition;
}

@property (nonatomic,strong)NSMutableDictionary * sortDictionary;

@property (nonatomic,strong)NSMutableDictionary * nameAndNum;

@property (nonatomic,copy)NSArray * rightTitles;

@property (nonatomic,strong)NSMutableArray *filterMutableArray;
@end

@implementation DEChosMessageController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager]setEnable:NO];
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.title = @"选择设备信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    DESearchView * searchView = [[NSBundle mainBundle]loadNibNamed:@"DESearchView" owner:self options:nil].firstObject;
    searchView.searchContentTextField.inputAccessoryView =self.tool;
    
  
    KWeakSelf
    //查询
    searchView.searchBlock = ^{
       [weakSelf.filterMutableArray removeAllObjects];
       
        
        if (self->_condition.length == 0) {
            [Units showErrorStatusWithString:@"请输入设备名称"];
            return ;
        }
        [weakSelf.view endEditing:YES];
        for (DeviceCodeModel * model in weakSelf.datasource) {
            NSString * name =nil;
            if (weakSelf.chosIdx ==1001) {
                name = model.Name;
                //
            }else{
                name =model.FacilityName;
            }
      
           
            NSRange range = [name rangeOfString:self->_condition options:NSCaseInsensitiveSearch];
            if (range.location !=NSNotFound) {
               
                [weakSelf.filterMutableArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
       
    };
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(50);
        make.bottom.mas_offset(0);
    }];

 
    [self loaddata];
    
    //刷新
  
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新移除缓存
        YYCache * cache = [YYCache cacheWithName:DeviceProjectNameURL];
        [cache removeObjectForKey:@"project"];
        
        [weakSelf loaddata];
    }];
    // 注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:UITextFieldTextDidChangeNotification object:nil];
    //二维码
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saoma"] style:UIBarButtonItemStylePlain target:self action:@selector(QRCode)];
    self.navigationItem.rightBarButtonItem = rightItem;
                                  
    
}
-(void)QRCode{
    SGQRCodeWebController * controller =[SGQRCodeWebController new];
    [self QRCodeScanVC:controller];
  
   // NSMutableArray * filterArray = [NSMutableArray array];
    KWeakSelf
    controller.passScanResultBlock = ^(NSString * _Nonnull code) {
      //  [filterArray removeAllObjects];
          [self.filterMutableArray removeAllObjects];
       
       
        for (DeviceCodeModel * model in weakSelf.datasource) {
            NSRange range = [model.FacilityCode rangeOfString:code options:NSCaseInsensitiveSearch];
            if (range.location !=NSNotFound) {
                [self.filterMutableArray addObject:model];
                //[filterArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
      //  [weakSelf filterLetters:filterArray];
    };
}
-(void)changeText:(NSNotification*)notification{
    UITextField * textField = [notification object];
    _condition = textField.text;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray * sectionTitle  =[self.rightTitles objectAtIndex:section];
//    NSArray * sectionName = [self.sortDictionary objectForKey:sectionTitle];
//    debugLog(@" - -%ld",sectionName.count);
//    return sectionName.count;
    return self.filterMutableArray.count;
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.rightTitles objectAtIndex:section];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString * reusedIdtifire = @"cellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reusedIdtifire];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdtifire];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//    NSString *sectionTitle = [self.rightTitles objectAtIndex:indexPath.section];
//    NSArray *sectionName = [self.sortDictionary objectForKey:sectionTitle];
//    NSString *name = [sectionName objectAtIndex:indexPath.row];
    DeviceCodeModel * model = self.filterMutableArray[indexPath.row];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@ %@",model.FacilityName?:model,model.FacilityCode?:model.TaskCode];
    
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *sectionTitle = [self.rightTitles objectAtIndex:indexPath.section];
//    NSArray *sectionName = [self.sortDictionary objectForKey:sectionTitle];
//    NSString *name = [sectionName objectAtIndex:indexPath.row];
    DeviceCodeModel * model = self.filterMutableArray[indexPath.row];
    if (self.passCodeMessage) {
        self.passCodeMessage(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.rightTitles;
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [self.rightTitles indexOfObject:title];
//}
-(void)loaddata{
    
    [self.datasource removeAllObjects];
    [self.filterMutableArray removeAllObjects];
    NSDictionary * parm = [NSDictionary dictionary];
    NSString * urlString =nil;
    if (_chosIdx == 9999) {
//        //判断缓存
//        YYCache * cacheYY = [YYCache cacheWithName:DeviceProjectNameURL];
//        id cacheObj = [cacheYY objectForKey:@"project"];
//        NSArray * cacheArr = (NSArray*)cacheObj;
//        if (cacheArr.count) {
//            [self.datasource addObjectsFromArray:cacheArr];
//            [self filterLetters:self.datasource];
//            [self.tableView.mj_header endRefreshing];
//            return;
//        }
        //设备维修
        parm = @{@"UserId":USERDEFAULT_object(USERID),@"FactoryId":_factoryId?:@""};
        urlString = [DeviceCodeURL getWholeUrl];
    //开单设备名称
    }else if (_chosIdx == 1000){
        //判断缓存
//        YYCache * codeCache = [YYCache cacheWithName:DeviceCodeURL];
//        id codeObj = [codeCache objectForKey:@"deviceCode"];
//        NSArray * codeArr = (NSArray*)codeObj;
//        if (codeArr.count) {
//            [self.datasource addObjectsFromArray:codeArr];
//            [self filterLetters:self.datasource];
//            [self.tableView.mj_header endRefreshing];
//            return;
//        }
        //领料单号
        parm = @{@"Type":@"1",@"FactoryId":_factoryId};
        urlString = [DevicePickOrderNoURL getWholeUrl];
        //领料单号
    }else if (_chosIdx == 1002){
        
//        //判断缓存
//        YYCache * cacheYY = [YYCache cacheWithName:DeviceProjectNameURL];
//        id cacheObj = [cacheYY objectForKey:@"project"];
//        NSArray * cacheArr = (NSArray*)cacheObj;
//        if (cacheArr.count) {
//            [self.datasource addObjectsFromArray:cacheArr];
//            [self filterLetters:self.datasource];
//            [self.tableView.mj_header endRefreshing];
//            return;
//        }
        //设备点检保养
        parm = @{@"UserId":USERDEFAULT_object(USERID),@"FactoryId":_factoryId?:@""};
        urlString = [DeviceCheckCodeURL getWholeUrl];
    }else if (_chosIdx ==1001){
      parm = @{@"UserId":USERDEFAULT_object(USERID)};
        urlString = [DeviceCodeURL getWholeUrl];
    }
    else{
        //判断缓存
//        YYCache * cacheYY = [YYCache cacheWithName:DeviceProjectNameURL];
//        id cacheObj = [cacheYY objectForKey:@"project"];
//        NSArray * cacheArr = (NSArray*)cacheObj;
//        if (cacheArr.count) {
//            [self.datasource addObjectsFromArray:cacheArr];
//            [self filterLetters:self.datasource];
//            [self.tableView.mj_header endRefreshing];
//            return;
//        }
        NSDictionary * dict = @{@"Column":@"DepCode",@"Direction":@"Asc"};
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObject:dict];
        parm = @{@"sorts":[Units arrayToJson:arr]};
        urlString = [DeviceProjectNameURL getWholeUrl];
    }
  
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    if (_chosIdx ==1000) {
        //领料单号
        
        [HttpTool POSTWithParms:urlString param:parm success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            [weakSelf.datasource removeAllObjects];
            if ([[responseObject objectForKey:@"status"]integerValue ] == 0) {
                NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
                NSMutableArray * arr1 = [DeviceCodeModel mj_objectArrayWithKeyValuesArray:arr];
                if (arr1) {
                 [weakSelf.datasource addObjectsFromArray:arr1];
                    [weakSelf.filterMutableArray addObjectsFromArray:arr1];
                }
                
               // [weakSelf filterLetters:arr1];
                //yycache 缓存
               // YYCache * cache = [YYCache cacheWithName:DeviceCodeURL];
               // [cache setObject:self.datasource forKey:@"deviceCode"];
                
                
            }
            [weakSelf.tableView reloadData];
            debugLog(@" - -%@",responseObject);
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
        }];
    }else{
        
        [HttpTool POST:urlString param:parm success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            [weakSelf.datasource removeAllObjects];
            if ([[responseObject objectForKey:@"status"]integerValue ] == 0) {
                
                NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
                NSMutableArray * arr1 = [DeviceCodeModel mj_objectArrayWithKeyValuesArray:arr];
                if (arr1) {
                [weakSelf.datasource addObjectsFromArray:arr1];
                    [weakSelf.filterMutableArray addObjectsFromArray:arr1];
                }
               
              //  [weakSelf filterLetters:arr1];
//                for (int i =0; i<arr.count; i++) {
//                    NSDictionary * dict = arr[i];
//                    debugLog(@"- - - - == %@",dict);
//                }
                //yycache缓存
               // YYCache * cache = [YYCache cacheWithName:DeviceProjectNameURL];
              //  [cache setObject:self.datasource forKey:@"project"];
              //  debugLog(@" - -%@",arr1);
            }
            [weakSelf.tableView reloadData];
            debugLog(@" - -%@",responseObject);
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }
    
   
    
}

-(void)filterLetters:(NSArray*)array{
    KWeakSelf
    self.rightTitles =nil;
    self.nameAndNum = [NSMutableDictionary dictionary];
    
    NSMutableArray * nameArr = [NSMutableArray array];
    [nameArr removeAllObjects];
    [self.sortDictionary removeAllObjects];
    [self.nameAndNum removeAllObjects];

    for (DeviceCodeModel * model in array) {
        //做下判断
        if (_chosIdx ==1001) {
            [nameArr addObject:model.Name];
            [weakSelf.nameAndNum setObject:model forKey:model.Name];
            
        }else{
            [nameArr addObject:model.FacilityName?:@""];
            [weakSelf.nameAndNum setObject:model forKey:model.FacilityName];
            
        }
    }
   
  
    NSArray * sortArr = [nameArr arrayWithPinYinFirstLetterFormat];
    self->_sortDictionary = [NSMutableDictionary dictionary];
    for (int i =0; i<sortArr.count; i++) {
        [self->_sortDictionary setObject:[[sortArr objectAtIndex:i] objectForKey:@"content"] forKey:[[sortArr objectAtIndex:i] objectForKey:@"firstLetter"]];
    }
    weakSelf.rightTitles = [[weakSelf.sortDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    [weakSelf.tableView reloadData];
    [weakSelf.tableView .mj_header endRefreshing];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
-(NSMutableArray*)filterMutableArray{
    if (!_filterMutableArray) {
        _filterMutableArray  =[NSMutableArray array];
    }return _filterMutableArray;
}

@end
