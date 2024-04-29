//
//  MCUnfinshListViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/14.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCUnfinshListViewController.h"
#import "HGSegmentedPageViewController.h"

#import "MCUnfinishChildController.h"

#import "MCListModel.h"
@interface MCUnfinshListViewController ()<HGSegmentedPageViewControllerDelegate>

@property (nonatomic,strong)HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong)NSMutableArray * selectedTitleArray;

@end

@implementation MCUnfinshListViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDatas];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"未完成";
    
    // Do any additional setup after loading the view.
    if (!_selectedTitleArray) {
        _selectedTitleArray  =[NSMutableArray array];
    }
   // [self getDatas];

    
    
    
}


-(void)getDatas{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:@"0" forKey:@"ListType"];
    NSString * beginTimeString = [NSString stringWithFormat:@"%@ 00:00:00",[Units getNowDate:-29]];
    NSString * endTimeString =[NSString stringWithFormat:@"%@ 23:59:59",[Units getNowDate:0]];
       
    [parms setObject:beginTimeString forKey:@"StartTime"];
       
    [parms setObject:endTimeString forKey:@"EndTime"];
    NSString * url  = @"maint/construstiontask/applyLists";
    
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            [weakSelf.selectedTitleArray removeAllObjects];
            
            NSArray * arr  = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1  = [MCListModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:arr1];
            if (weakSelf.datasource.count >0) {
                if (![weakSelf.selectedTitleArray containsObject:@"所有"]) {
                   [weakSelf.selectedTitleArray addObject:@"所有"];
                }
                
            }
            for (MCListModel * model in weakSelf.datasource) {
                if (![weakSelf.selectedTitleArray containsObject:model.taskStatus]) {
                    [weakSelf.selectedTitleArray addObject:model.taskStatus];
                }
            }
            
            if (weakSelf.selectedTitleArray.count >0) {
              [weakSelf setupSegmentWithTitles:weakSelf.selectedTitleArray];
            }
            
           
        }
        
       
        
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
        [weakSelf.tableView.mj_header endRefreshing];
       
    }];
}

//滑动条
-(void)setupSegmentWithTitles:(NSMutableArray*)titles{
    debugLog(@" -- == = == = =%@",titles);
   
  
        NSMutableArray * controllers = [NSMutableArray array];
        for (NSInteger i =0; i<titles.count; i++) {
            MCUnfinishChildController * controller = [MCUnfinishChildController new];
            
            controller.moudleArray = self.datasource;
            controller.selectedTypeString = titles[i];
            [controllers addObject:controller];
            
        }
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc]init];
        _segmentedPageViewController.categoryView.originalIndex = 0;
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:14];
        _segmentedPageViewController.categoryView.titleSelectedFont = [UIFont systemFontOfSize:16];
       
        //_segmentedPageViewController.categoryView.titleSelectedColor = RGBA(95, 168, 228, 1);
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.separator.hidden = YES;
        _segmentedPageViewController.categoryView.titleNormalColor = [UIColor darkGrayColor];
        _segmentedPageViewController.categoryView.titleSelectedColor = RGBA(221, 102, 94, 1);
        _segmentedPageViewController.delegate = self;
    _segmentedPageViewController.categoryView.underline.backgroundColor  = RGBA(221, 102, 94, 1);
    
        [self addChildViewController:_segmentedPageViewController];
        [self.view addSubview:_segmentedPageViewController.view];
    //221 102 94
        
     
        
        [_segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_offset(self.tabBarController.navigationController.navigationBar.frame.size.height+20);
            make.bottom.mas_equalTo(self.view).mas_offset(0);
        }];
    
    
  
    
}
-(void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index{
 
    [Units hiddenHudWithView:self.view];
}
-(void)segmentedPageViewControllerWillBeginDragging{
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
}


@end
