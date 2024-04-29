//
//  CheckMyTaskController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/11.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CheckMyTaskController.h"
#import "CETaskModel.h"

#import "DESegmentControl.h"
#import "CECheckViewController.h"
#import "CERepairViewController.h"
#import "CEOutPackViewController.h"

#import "MoudleModel.h"
@interface CheckMyTaskController ()<DESegmentControlDelegate,DESegmentControlDataSource>
@property (nonatomic,strong)DESegmentControl * segmentControl;
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) UIScrollView *contentScrollView;


@end

@implementation CheckMyTaskController


-(void)loadMessageWithFactoryId:(NSString*)factoryId{
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:@"1" forKey:@"Type"];
    NSString * factoryString =[NSString stringWithFormat:@"%@",factoryId];
    if (factoryString.length >0) {
        [parms setObject:factoryString forKey:@"FactoryId"];
    }
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[CheckMyTaskURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [CETaskModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:arr1];
            [weakSelf setDetailView];
            
            
        }
        
        debugLog(@" - -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showHudWithText:error view:weakSelf.view model:MBProgressHUDModeText];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view addSubview:self.tableView];
    [self loadMessageWithFactoryId:@""];
    self.title =@"我的任务";
   
    //取出工厂
    
     NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
     MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
     [modleArchiver finishDecoding];
   
    if (moudleStatus.FactoryList.count >1) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"切换工厂" forState:UIControlStateNormal];
        btn.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chosFactory:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    _segmentTitles =@[@"点检列表",@"保养列表",@"外包列表"];
    [self setupSegmentcontrol];
    [self setBgScrollview];
    
    
    
}
#pragma mark  滑动条
-(void)setupSegmentcontrol{
    
    _segmentControl =[[DESegmentControl alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 40)];
    _segmentControl.dataSource =self;
    _segmentControl.delegate =self;
    _segmentControl.alpha =1.0;
    _segmentControl.bottomHight =2.0f;
    [self.view addSubview:_segmentControl];
    
    
    
}
-(NSArray*)getSegmentControlTitles{
    return self.segmentTitles;
}

- (void)setBgScrollview
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight)];
    _contentScrollView.delegate = self;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth * [self.segmentTitles count], kScreenHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    [self.view addSubview:_contentScrollView];
}
- (void)setDetailView{
    CGFloat tableH = _contentScrollView.frame.size.height-Height_TabBar-40-10;
    //点检
    CECheckViewController * checkController =[[CECheckViewController alloc]init];
    checkController.itemsArray = self.datasource;
    [self addChildViewController:checkController];
    [checkController didMoveToParentViewController:self];
    [checkController.view setFrame:CGRectMake(0, 0, kScreenWidth, tableH)];
    
    [_contentScrollView addSubview:checkController.view];
    
    //保养
    CERepairViewController * maintainControl =[[CERepairViewController alloc]init];
    maintainControl.itemsArray = self.datasource;
    [self addChildViewController:maintainControl];
    [maintainControl didMoveToParentViewController:self];
    [maintainControl .view setFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableH)];
    
    [_contentScrollView addSubview:maintainControl.view];
    
    //维修外包
    CEOutPackViewController * repairControl =[[CEOutPackViewController alloc]init];
    repairControl.itemsArray = self.datasource;
    [self addChildViewController:repairControl];
    [repairControl didMoveToParentViewController:self];
    [repairControl.view setFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, tableH)];
    
    [_contentScrollView addSubview:repairControl.view];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _contentScrollView) {
        
        NSInteger index = scrollView.mj_offsetX/kScreenWidth;
        
        [_segmentControl didSectedIndex:index];
        
    }
}

-(void)control:(DESegmentControl *)control didSelectedAtIndex:(NSInteger)index{
    [_contentScrollView setContentOffset:CGPointMake(kScreenWidth *index, 0) animated:YES];
    
}

-(void)chosFactory:(UIButton*)sender{
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
           
            [weakSelf loadMessageWithFactoryId:factories[i][@"FactoryId"]];
            
           
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
    
}
@end
