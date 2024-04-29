//
//  DEUnfinishController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEUnfinishController.h"
#import "DEUnfinishModel.h"
#import "DEUnFinishTableCell.h"

#import "HGSegmentedPageViewController.h"
#import "DEUnfinishChildrenController.h"

@interface DEUnfinishController ()<HGSegmentedPageViewControllerDelegate>
{
    NSString * _beginTime;
    NSString * _endTime;
    NSString * _districtId;
    NSString * _engineer;
    NSString * _departmentNo;
    NSString * _deviceId;
    NSString * _orderNo;
    NSString *_orderUserName;
    NSString * _selectedTitle;//选择的标题
    
}

@property (nonatomic,strong)HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong)NSMutableArray * titlesArray;
@property (nonatomic,strong)NSMutableArray * selectedTitleArray;
@end

@implementation DEUnfinishController



- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray array];
    }
    if (!_selectedTitleArray) {
        _selectedTitleArray =[NSMutableArray array];
    }
   // self.title = @"未完成";
   // [self setupSegmetControl];

   // [self loadMessage:@"0"];
}
-(void)setupSegmetControl{
    NSArray * items = @[@"未完成",@"超时未完成"];
    UISegmentedControl * segmentControl =[[UISegmentedControl alloc]initWithItems:items];
    
    segmentControl.bounds = CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, 25);
//    segmentControl.backgroundColor =[UIColor whiteColor];
//    segmentControl.tintColor =[UIColor blackColor];
    segmentControl.selectedSegmentIndex =0;
    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    [segmentControl addTarget:self action:@selector(chosItem:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
}

-(void)chosItem:(UISegmentedControl*)segment{
   
    NSString * typeString;
    if (segment.selectedSegmentIndex ==0) {
       
        typeString = @"0";
        
    }else{
        
        typeString = @"2";
    }
    NSDictionary * dict = @{@"item":typeString};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chosItem" object:dict];
   // [self selectedTitle:_selectedTitle?:@"所有"];
}

-(void)loadMessageparms:(NSMutableDictionary *)parms url:(NSString*)url{
  
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POSTWithParms:url param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        [self.datasource removeAllObjects];
        [self.selectedTitleArray removeAllObjects];
        self->_segmentedPageViewController =nil;
        [self->_segmentedPageViewController.view removeFromSuperview];
        debugLog(@"- - -%@",responseObject);
        if ([[responseObject objectForKey:@"status"]integerValue] == 0 ) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            
            NSMutableArray * arr1 = [DEUnfinishModel mj_objectArrayWithKeyValuesArray:arr];
            [self.datasource addObjectsFromArray:arr1];
        }
        
        if (![self.selectedTitleArray containsObject:@"所有"]) {
            [self.selectedTitleArray addObject:@"所有"];
        }
        
        for (DEUnfinishModel * model in self.datasource) {
            if (![self.selectedTitleArray containsObject:model.TaskStatusName]) {
                [self.selectedTitleArray addObject:model.TaskStatusName];
            }
        }
        //创建滑动条
        
        [self setupSegmentWithTitles:self.selectedTitleArray];
     
        [self.tableView reloadData];
    } error:^(NSString * _Nonnull error) {
        debugLog(@"- - -- %@",error);
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
        
    }];
}

//滑动条
-(void)setupSegmentWithTitles:(NSMutableArray*)titles{
    if (!_segmentedPageViewController) {
  
        NSMutableArray * controllers = [NSMutableArray array];
        for (NSInteger i =0; i<titles.count; i++) {
            DEUnfinishChildrenController * controller = [DEUnfinishChildrenController new];
            
            controller.mouleArray = self.datasource;
            controller.selectedTypeString = self.selectedTitleArray[i];
            [controllers addObject:controller];
        }
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc]init];
        _segmentedPageViewController.categoryView.originalIndex = 0;
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:14];
        _segmentedPageViewController.categoryView.titleSelectedFont = [UIFont systemFontOfSize:16];
        _segmentedPageViewController.categoryView.titleSelectedColor = RGBA(95, 168, 228, 1);
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.separator.hidden = YES;
        _segmentedPageViewController.categoryView.titleNormalColor = [UIColor darkGrayColor];
        _segmentedPageViewController.categoryView.titleSelectedColor = [UIColor blackColor];
        _segmentedPageViewController.delegate = self;
        [self addChildViewController:_segmentedPageViewController];
        [self.view addSubview:_segmentedPageViewController.view];
        
        
        [_segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_offset(0);
            make.bottom.mas_equalTo(self.view).mas_offset(0);
        }];
    }
    
    //选中
   
    _segmentedPageViewController.categoryView.selectedItem = ^(NSUInteger idx) {
      

    };
    
}
-(void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index{
 
    [Units hiddenHudWithView:self.view];
}
-(void)segmentedPageViewControllerWillBeginDragging{
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
}


-(NSMutableDictionary*)mutaleParms{
    if (!_mutaleParms) {
        _mutaleParms =[NSMutableDictionary dictionary];
    }
    return _mutaleParms;
}
@end
