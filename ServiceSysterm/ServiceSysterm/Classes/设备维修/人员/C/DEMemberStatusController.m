//
//  DEMemberStatusController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMemberStatusController.h"
#import "DEUnFinishTableCell.h"
#import "DECheckListController.h"
#import "DEMaintainListController.h"
#import "DERepairListController.h"
#import "DESegmentControl.h"
@interface DEMemberStatusController ()<DESegmentControlDelegate,DESegmentControlDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray * titleArray;//滑动条
@property (nonatomic,strong)DESegmentControl *segmentControl;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation DEMemberStatusController
-(NSMutableArray*)titleArray{
    if (!_titleArray) {
        _titleArray =[NSMutableArray array];
        NSArray * titles =@[@"点检列表",@"保养列表",@"维修列表"];
        [_titleArray addObjectsFromArray:titles];
    }return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title =@"详细信息";
    self.view.backgroundColor =[UIColor whiteColor];
   
    [self loadMessage];
    
}

#pragma mark  滑动条
-(void)setupSegmentcontrol{
    
    _segmentControl =[[DESegmentControl alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 40)];
    _segmentControl.dataSource =self;
    _segmentControl.delegate =self;
    _segmentControl.alpha =1.0;
    _segmentControl.bottomHight =2.0f;
    [self.view addSubview:_segmentControl];
    //加一条横线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(_segmentControl.frame)-1, kScreenWidth-4, 1)];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line];
   
    
    
}
-(NSArray*)getSegmentControlTitles{
    return self.titleArray;
}

- (void)setBgScrollview
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight)];
    _contentScrollView.delegate = self;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth * [self.titleArray count], kScreenHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    [self.view addSubview:_contentScrollView];
}
- (void)setDetailView{
   CGFloat tableH = _contentScrollView.frame.size.height-Height_TabBar-40-10;
    DECheckListController * checkController =[[DECheckListController alloc]init];
    checkController.itemsArray = self.datasource;
    [self addChildViewController:checkController];
    [checkController didMoveToParentViewController:self];
    [checkController.view setFrame:CGRectMake(0, 0, kScreenWidth, tableH)];
    
    [_contentScrollView addSubview:checkController.view];
    
    //保养
    DEMaintainListController * maintainControl =[[DEMaintainListController alloc]init];
    maintainControl.itemsArray = self.datasource;

    [self addChildViewController:maintainControl];
    [maintainControl didMoveToParentViewController:self];
    [maintainControl .view setFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableH)];
    
    [_contentScrollView addSubview:maintainControl.view];
    
    //维修
    DERepairListController * repairControl =[[DERepairListController alloc]init];
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
-(void)loadMessage{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:@"2" forKey:@"Type"];
    [parms setObject:self.maintainUserId forKey:@"UserId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POSTWithParms:[DeviceTaskURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [DEUnfinishModel mj_objectArrayWithKeyValuesArray:arr];
            [self.datasource addObjectsFromArray:arr1];
            //创建滑动条
            [self setupSegmentcontrol];
            [self setBgScrollview];
            [self setDetailView];
        }
       
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:self.view];
        [Units showErrorStatusWithString:error];
    }];
}
@end
