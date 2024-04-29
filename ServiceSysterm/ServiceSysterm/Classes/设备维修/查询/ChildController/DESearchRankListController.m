//
//  DESearchRankListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchRankListController.h"
#import "DESearchTImeFilterView.h"

#import "MoudleModel.h"

@interface DESearchRankListController ()<ZHPickViewDelegate>
@property (nonatomic,strong)DESearchTImeFilterView * filterView;
@end

@implementation DESearchRankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    //排名
    //覆盖之前的view
    UIView * bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    DESearchTImeFilterView * filterView =[[DESearchTImeFilterView alloc]init];
    filterView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    _filterView =filterView;
    [bottomView addSubview:filterView];
    
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    if (moudleStatus.FactoryList.count >0) {
        //默认
       [filterView.FactoryButton setTitle:moudleStatus.FactoryList[0][@"FactoryName"] forState:UIControlStateNormal];
        
    }
              
    KWeakSelf
    filterView.timeFilterBlock = ^{
        ZHPickView * pickView =[[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        pickView.delegate = weakSelf;
        [pickView show];
    };
    filterView.chosFactoryBlock = ^{
        [weakSelf chosFactory];
    };
   
    [self.mutableParms setObject:_selectedString?:[Units currentTimeWithFormat:@"yyyy-MM-dd"] forKey:@"SelectTime"];
    [self.mutableParms setObject:moudleStatus.FactoryList[0][@"FactoryId"]?:@"" forKey:@"FactoryId"];
    [self.mutableParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [self reloadMessage:self.mutableParms url:[DeviceWholeMessageURL getWholeUrl] flag:3];
    
    
   
}


-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    debugLog(@" - -%@",resultString);
    _selectedString =[Units timeWithTime:resultString beforeFormat:@"yyyy-MM-dd HH:mm" andAfterFormat:@"yyyy-MM-dd"];
    [_filterView.timeButton setTitle:[NSString stringWithFormat:@"查询时间:%@",_selectedString] forState:UIControlStateNormal];
    
    [self.mutableParms setObject:_selectedString?:@"" forKey:@"SelectTime"];
    [self reloadMessage:self.mutableParms url:[DeviceWholeMessageURL getWholeUrl] flag:3];
}
//选择工厂
-(void)chosFactory{
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    KWeakSelf;
    NSMutableArray * factories =[NSMutableArray array];
    [factories removeAllObjects];
    [factories addObjectsFromArray:moudleStatus.FactoryList];
    [factories addObject:@{@"FactoryName":@"不限",@"FactoryId":@""}];
    for (int i =0; i<factories.count; i++) {
        NSString * title  =factories[i][@"FactoryName"];
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.filterView.FactoryButton setTitle:title forState:UIControlStateNormal];
            [weakSelf.mutableParms setObject:self->_selectedString?:[Units currentTimeWithFormat:@"yyyy-MM-dd"] forKey:@"SelectTime"];
          
            [weakSelf.mutableParms setObject:factories[i][@"FactoryId"] forKey:@"FactoryId"];
            [weakSelf reloadMessage:weakSelf.mutableParms url:[DeviceWholeMessageURL getWholeUrl] flag:3];
            
            
        }]];
        
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}

@end
