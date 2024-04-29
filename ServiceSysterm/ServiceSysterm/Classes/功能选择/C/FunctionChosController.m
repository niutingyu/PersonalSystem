//
//  FunctionChosController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/23.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "FunctionChosController.h"

#import "HGSegmentedPageViewController.h"
#import "FunctionChildrenController.h"
#import "MoudleModel.h"
#import "MoudleListModel.h"
#import "UserModel.h"
#import "UserPrivileModel.h"
#import "FactoryTabbarController.h"

@interface FunctionChosController ()<HGSegmentedPageViewControllerDelegate>
@property (nonatomic,strong)HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong)NSMutableArray * topTitleArray;
@property (nonatomic,strong)NSMutableArray * mouleArray;

@property (nonatomic,strong)NSMutableArray * moudleIdArray;



@end

@implementation FunctionChosController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能选择";
   
    [self loadmoudleDatas];
    [self addChildViewController:self.segmentedPageViewController];
    [self.view addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
   
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(HGSegmentedPageViewController*)segmentedPageViewController{
    if (!_segmentedPageViewController) {
       
        //
        if (!_topTitleArray) {
            _topTitleArray = [NSMutableArray array];
            NSArray * arr = @[@"维修"];
            [_topTitleArray addObjectsFromArray:arr];
        }
        
        NSMutableArray * controllers = [NSMutableArray array];
        
        for (NSInteger i =0; i<_topTitleArray.count; i++) {
            FunctionChildrenController * controller = [FunctionChildrenController new];
            controller.favirivateArray = self.mouleArray;
            controller.faviriteIdArray = self.moudleIdArray;
            [controllers addObject:controller];
        }
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc]init];
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = self.topTitleArray;
        _segmentedPageViewController.categoryView.originalIndex = 0;
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:17];
        _segmentedPageViewController.categoryView.separator.hidden = YES;
        _segmentedPageViewController.categoryView.titleNormalColor = [UIColor blackColor];
        _segmentedPageViewController.categoryView.titleSelectedColor = [UIColor blackColor];
        _segmentedPageViewController.delegate = self;
        
        
        
        //点击选中
        KWeakSelf
        _segmentedPageViewController.categoryView.selectedItem = ^(NSUInteger idx) {
            NSString * selectedTitle = weakSelf.topTitleArray[idx];
            [weakSelf selectedTitleWithTitle:selectedTitle];
            
        };
        
    }
    return _segmentedPageViewController;
}
-(void)selectedTitleWithTitle:(NSString*)title{
     [self loadmoudleDatas];
    
}

-(void)loadmoudleDatas{
    //解档
    [self.mouleArray removeAllObjects];
    [self.moudleIdArray removeAllObjects];
   
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    debugLog(@" -- -%@",moudleStatus.FactoryList);
    [modleArchiver finishDecoding];
    NSMutableArray * arr = [MoudleListModel mj_objectArrayWithKeyValuesArray:moudleStatus.ModulesList];
    [self.datasource addObjectsFromArray:arr];
    for (MoudleListModel * dictModel in self.datasource) {
        if ([dictModel.ModuleName isEqualToString:@"设备维修"]||[dictModel.ModuleName isEqualToString:@"设备点检保养"]||[dictModel.ModuleName isEqualToString:@"维修工具管理"]||[dictModel.ModuleName isEqualToString:@"设备履历查询"]) {
            if (![self.mouleArray containsObject:@"设备维修"]||![self.mouleArray containsObject:@"设备点检保养"]||![self.mouleArray containsObject:@"设备工具管理"]||![self.mouleArray containsObject:@"设备履历查询"]) {
                [self.mouleArray addObject:dictModel.ModuleName];
                [self.moudleIdArray addObject:dictModel.ModuleId];
            }
        }
        
    }

    
    //发通知
    NSDictionary * dict =@{@"itemKey":self.mouleArray,@"itemIdKey":self.moudleIdArray};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"moudleName" object:dict];
}
-(NSMutableArray*)mouleArray{
    if (!_mouleArray) {
        _mouleArray = [NSMutableArray array];
    }
    return _mouleArray;
}

-(NSMutableArray*)moudleIdArray{
    if (!_moudleIdArray) {
        _moudleIdArray = [NSMutableArray array];
    }
    return _moudleIdArray;
}
@end
