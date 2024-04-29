//
//  CECheckUnFinishListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CECheckUnFinishListController.h"
#import "HGSegmentedPageViewController.h"
#import "CECheckUnFinishChildController.h"
#import "CEFIlterConditionController.h"
#import "CEUnFinishModel.h"
#import "CEMenuChosView.h"
#import "MoudleModel.h"
@interface CECheckUnFinishListController ()<HGSegmentedPageViewControllerDelegate>
{
    BOOL _isPop;
    NSString * _typeString;
}
@property (nonatomic,strong)HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong)NSMutableArray * selectedListArray;//滑动条

@property (nonatomic,strong)CEChosTypeModel *typeModel;

@property (nonatomic,copy)NSString *factoryId;

@end

@implementation CECheckUnFinishListController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isPop ==1 ) {
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"未完成";
     [self.view addSubview:self.tableView];
    if (!_selectedListArray) {
        _selectedListArray =[NSMutableArray array];
       
    }
    [self setupSegmetControl];
   
    [self loadMessage:@"0" model:nil];
    
   //取出工厂
     
      NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
      MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
      [modleArchiver finishDecoding];
    if (moudleStatus.FactoryList.count ==1) {
        UIButton * btn1  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitle:@"筛选" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
            
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        UIButton * btn1  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitle:@"筛选" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2  =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"工厂" forState:UIControlStateNormal];
        btn2.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(chosFactory) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * rightItem1  =[[UIBarButtonItem alloc]initWithCustomView:btn1];
        
        UIBarButtonItem *rightItem2  =[[UIBarButtonItem alloc]initWithCustomView:btn2];
        NSArray * arr  =@[rightItem1,rightItem2];
        self.navigationItem.rightBarButtonItems =arr;
    }
    _isPop = NO;
    _typeString =@"0";
   
}

-(void)filter{
    CEFIlterConditionController * controller =[CEFIlterConditionController new];
    [self.navigationController pushViewController:controller animated:YES];
    KWeakSelf
    controller.passTypeBlock = ^(CEChosTypeModel * _Nonnull model) {
        weakSelf.typeModel =model;
        [weakSelf  loadMessage:self->_typeString model:model];
    };
}

-(void)chosFactory{
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
        NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
          MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
        KWeakSelf
    NSMutableArray * factories =[NSMutableArray array];
    [factories removeAllObjects];
    [factories addObjectsFromArray:moudleStatus.FactoryList];
    [factories addObject:@{@"FactoryName":@"不限",@"FactoryId":@""}];
        for (int i =0; i<factories.count; i++) {
            NSString * title  =factories[i][@"FactoryName"];
            [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakSelf.factoryId  =factories[i][@"FactoryId"];
                [weakSelf loadMessage:self->_typeString model:weakSelf.typeModel];
                
                
            }]];
        }
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller animated:YES completion:nil];
}
//上面固定的五个选项
-(void)setupSegmetControl{
    CEMenuChosView * segment = [[CEMenuChosView alloc]init];
    segment.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [self.view addSubview:segment];
    KWeakSelf
    segment.chosItemBlock = ^(NSInteger idx) {
        if (weakSelf.segmentedPageViewController.view) {
            [weakSelf.segmentedPageViewController.view removeFromSuperview];
            [weakSelf.segmentedPageViewController removeFromParentViewController];
        }
        NSString * typeString =nil;
        if (idx ==0) {
            typeString =@"0";
        }else{
            typeString = [NSString stringWithFormat:@"%ld",idx+1];
        }
        self->_typeString = typeString;
        //选中每次请求网络获取最新数据
        [weakSelf loadMessage:typeString model:nil];
        
       
    };

}


-(void)loadMessage:(NSString*)typeString model:(CEChosTypeModel*)model{
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [parms setObject:typeString forKey:@"ListType"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    if (model.startTime.length) {
        [parms setObject:model.startTime forKey:@"StartTime"];
    }if (model.endTime.length) {
        [parms setObject:model.endTime forKey:@"EndTime"];
    }if (model.maintainEngineerId.length) {
        [parms setObject:model.maintainEngineerId forKey:@"AcceptUser"];
    }if (model.districtId.length) {
        [parms setObject:model.districtId forKey:@"MaintainDistrictId"];
    }if (model.departmentId.length) {
        [parms setObject:model.departmentId forKey:@"OrId"];
    }if (model.deviceId.length) {
        [parms setObject:model.deviceId forKey:@"FacilityId"];
    }if (model.maintainCode.length) {
        [parms setObject:model.maintainCode forKey:@"TaskCode"];
    }
    id num  = _factoryId;
   
    
    if (num !=0) {
        [parms setObject:_factoryId forKey:@"FactoryId"];
    }
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POSTWithParms:[DeviceCheckUnFinishListURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        [self.datasource removeAllObjects];
        [self.selectedListArray removeAllObjects];
        //每次请求网络重新创建segment 移除原来的
        self->_segmentedPageViewController =nil;
        [self.segmentedPageViewController.view removeFromSuperview];

       
        
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 =[CEUnFinishModel mj_objectArrayWithKeyValuesArray:arr];
            [self.datasource addObjectsFromArray:arr1];
           
            if (self.datasource.count >0) {
             [self.selectedListArray addObject:@"所有"];
            }
            
            
           
            for (CEUnFinishModel * model in self.datasource) {
                if (![self.selectedListArray containsObject:model.TaskStatusName]) {
                    [self.selectedListArray addObject:model.TaskStatusName];
                    
                }
            }
            //创建滑动条
            [self setupSegmentWithTitles:self.selectedListArray];
         //f通知刷新数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTableView" object:nil];
        }else{
            [Units showErrorStatusWithString:responseObject[@"info"]];
        }
       
       
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
    }];
   
}


//滑动条
-(void)setupSegmentWithTitles:(NSMutableArray*)titles{
    if (!_segmentedPageViewController) {
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc]init];
        _segmentedPageViewController.categoryView.height = 35.0f;
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:14];
        _segmentedPageViewController.categoryView.titleSelectedFont = [UIFont systemFontOfSize:16];
        _segmentedPageViewController.categoryView.titleSelectedColor = RGBA(95, 168, 228, 1);
        _segmentedPageViewController.categoryView.titleNormalColor = [UIColor darkGrayColor];
        _segmentedPageViewController.categoryView.titleSelectedColor = [UIColor blackColor];
        _segmentedPageViewController.delegate = self;
        if (titles.count) {
            NSMutableArray * controllers = [NSMutableArray array];
            for (int i =0; i<titles.count; i++) {
                CECheckUnFinishChildController * controller = [CECheckUnFinishChildController new];
                
                controller.dataArray = self.datasource;
                controller.tipTitleString = self.selectedListArray[i];
                [controllers addObject:controller];
            }
            _segmentedPageViewController.pageViewControllers = controllers.copy;
            _segmentedPageViewController.categoryView.titles = titles;
            _segmentedPageViewController.categoryView.originalIndex =0;
            [self addChildViewController:_segmentedPageViewController];
            [self.view addSubview:_segmentedPageViewController.view];
            [_segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.top.mas_offset(42);
                make.bottom.mas_equalTo(self.view).mas_offset(0);
            }];
        }
       
        
    }
    
    //选中
   
    _segmentedPageViewController.categoryView.selectedItem = ^(NSUInteger idx) {
       // [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeText];
    };
    
}
-(void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index{

    [Units hiddenHudWithView:self.view];
}
-(void)segmentedPageViewControllerWillBeginDragging{
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
}

-(NSMutableArray*)selectedListArray{
    if (!_selectedListArray) {
        _selectedListArray =[NSMutableArray array];
    }return _selectedListArray;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isPop = YES;
}
@end
