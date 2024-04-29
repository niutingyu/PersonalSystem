//
//  DESearchController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/30.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchController.h"
#import "DeviceModel.h"
#import "DESegmentControl.h"
#import "DESearchWholeController.h"
#import "DESearchPushMessageController.h"
#import "DESearchErrorController.h"
#import "DESearchRankListController.h"
#import "DESearchSortController.h"
#import "ZHPickView.h"

#import "MoudleModel.h"
@interface DESearchController ()<DESegmentControlDelegate,DESegmentControlDataSource,UIScrollViewDelegate,ZHPickViewDelegate,UITextFieldDelegate>{
    NSString * _selectedId;//选中id
    NSString * _selectedSort;//选中分数
}
@property (nonatomic,strong)NSMutableArray * datasource;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)DESegmentControl * segmentControl;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic,strong)NSMutableArray * districtArray;
@property (nonatomic,strong)UIBarButtonItem * rightItem;
@property (nonatomic,strong)NSMutableArray *maintainEngineerIdArray;//维修工程师id
@end

@implementation DESearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (!_districtArray) {
        _districtArray =[NSMutableArray array];
        NSArray * arr = @[@"不限",@"电子",@"干区",@"湿区"];
        [_districtArray addObjectsFromArray:arr];
    }
   
   
    
    for (DeviceModel * model in self.moudleArray) {
        if ([model.RtName isEqualToString:@"汇总"]||[model.RtName isEqualToString:@"推送"]||[model.RtName isEqualToString:@"异常"]||[model.RtName isEqualToString:@"排名"]||[model.RtName isEqualToString:@"积分"]) {
            [self.datasource addObject:model.RtName];
        }
    }
    [self setSegmentControl];
    [self setBgScrollview];
    [self setDetailView];
    
    KWeakSelf
    [self.datasource enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"汇总"]||[obj isEqualToString:@"积分"]) {
           
             UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shaixuan"] style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
            weakSelf.navigationItem.rightBarButtonItem = rightItem;
            weakSelf.rightItem =rightItem;
            
        }
       
    }];
    
   
   
}


-(void)filter{
    
    if (_segmentControl.tapIndex == 0) {
        [_districtArray removeAllObjects];
      NSArray * arr =@[@"不限",@"电子",@"干区",@"湿区"];
        [_districtArray addObjectsFromArray:arr];
        ZHPickView * pickView = [[ZHPickView alloc]initPickviewWithArray:self.districtArray isHaveNavControler:NO];
        pickView.delegate = self;
        [pickView show];
    }else if (_segmentControl.tapIndex ==4){
        
        [self loadMember];
    }
}

#pragma mark 人员 积分 请求网络获取数据

-(void)loadMember{
    NSDictionary * dict =@{@"Type":@"1",@"UserId":USERDEFAULT_object(USERID)};
    [self.districtArray removeAllObjects];
    [self.maintainEngineerIdArray removeAllObjects];
    [Units showStatusWithStutas:Loading];
    KWeakSelf
    [HttpTool POST:[DeviceEngineerURL getWholeUrl] param:dict success:^(id  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]integerValue ]== 0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            for (NSDictionary * responDict in arr) {
                [weakSelf.districtArray addObject:[NSString stringWithFormat:@"%@(%@)",responDict[@"FName"],responDict[@"UserName"]]];
                [weakSelf.maintainEngineerIdArray addObject:responDict[@"UserId"]];
            }
            [weakSelf.districtArray insertObject:@"不限" atIndex:0];//维修人名  显示
            [weakSelf.maintainEngineerIdArray insertObject:@"" atIndex:0];//维修id 传参数用
            ZHPickView * pickView = [[ZHPickView alloc]initPickviewWithArray:weakSelf.districtArray isHaveNavControler:NO];
            pickView.delegate = weakSelf;
            [pickView show];
        }
        
    } error:^(NSString * _Nonnull error) {
        
    }];
}

#pragma mark  pickview t弹出框 汇总  积分

-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    NSString * selectedStr;
    if (_segmentControl.tapIndex == 0) {
        selectedStr = resultString;
       
    }else if (_segmentControl.tapIndex ==4){
        selectedStr = self.maintainEngineerIdArray[resultIndex];
    }
   
    //这里发个通知  通知选中的区域
    NSDictionary * dict =@{@"parms":selectedStr};
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"passParm-%ld",_segmentControl.tapIndex] object:dict];
}
#pragma mark -=== = = = ===滑动选择条

-(void)setSegmentControl{
    _segmentControl = [[DESegmentControl alloc] initWithFrame:CGRectMake(0, 0, 45 * [self.datasource count], 40)];
    
    _segmentControl.delegate = self;
    _segmentControl.dataSource = self;
    _segmentControl.alpha = 1;
    self.navigationItem.titleView = _segmentControl;
}
- (NSArray *)getSegmentControlTitles
{
    return self.datasource;
}

- (void)setBgScrollview
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _contentScrollView.delegate = self;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth * [self.datasource count], kScreenHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    [self.view addSubview:_contentScrollView];
}
- (void)setDetailView
{
   
    //汇总
    CGFloat tableH = _contentScrollView.frame.size.height-Height_TabBar-20;
    DESearchWholeController *pickListController = [[DESearchWholeController alloc] init];
   
    [self addChildViewController:pickListController];
    [pickListController didMoveToParentViewController:self];
    [pickListController.view setFrame:CGRectMake(0, 0, kScreenWidth, tableH)];
    [_contentScrollView addSubview:pickListController.view];
    
    
    
    
    //推送
    DESearchPushMessageController *backController = [[DESearchPushMessageController alloc] init];
    [self addChildViewController:backController];
    [backController didMoveToParentViewController:self];
    [backController.view setFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableH )];
    [_contentScrollView addSubview:backController.view];
    
    //异常
    DESearchErrorController *listController = [[DESearchErrorController alloc] init];
    [self addChildViewController:listController];
    [listController didMoveToParentViewController:self];
    [listController.view setFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, tableH)];
    [_contentScrollView addSubview:listController.view];
    //排名
    DESearchRankListController * rankController =[[DESearchRankListController alloc]init];
    [self addChildViewController:rankController];
    [rankController didMoveToParentViewController:self];
    [rankController.view setFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, tableH)];
    [_contentScrollView addSubview:rankController.view];
    //积分
    DESearchSortController * sortController =[[DESearchSortController alloc]init];
    [self addChildViewController:sortController];
    [sortController didMoveToParentViewController:self];
    [sortController.view setFrame:CGRectMake(kScreenWidth*4, 0, kScreenWidth, tableH)];
    [_contentScrollView addSubview:sortController.view];
}

#pragma mark -- UIScrollViewDelegate 用于控制头部视图滑动的视差效果

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _contentScrollView) {
        
        NSInteger index = scrollView.mj_offsetX/kScreenWidth;
        NSString * tipString = self.datasource[index];
        if ([tipString isEqualToString:@"推送"]||[tipString isEqualToString:@"异常"]||[tipString isEqualToString:@"排名"]) {
            self.navigationItem.rightBarButtonItem =nil;
        }
        else{
            self.navigationItem.rightBarButtonItem =_rightItem;
        }
        
        [_segmentControl didSectedIndex:index];
        
    }
}

-(void)control:(DESegmentControl *)control didSelectedAtIndex:(NSInteger)index{
    [_contentScrollView setContentOffset:CGPointMake(kScreenWidth *index, 0) animated:YES];
    NSString * tipString = self.datasource[index];
    if ([tipString isEqualToString:@"推送"]||[tipString isEqualToString:@"异常"]||[tipString isEqualToString:@"排名"]) {
        self.navigationItem.rightBarButtonItem =nil;
    }else{
        self.navigationItem.rightBarButtonItem =_rightItem;
    }
}


-(NSMutableArray*)datasource{
    if (!_datasource) {
        _datasource =[NSMutableArray array];

    }
    return _datasource;
}
-(NSMutableArray*)maintainEngineerIdArray{
    if (!_maintainEngineerIdArray) {
        _maintainEngineerIdArray =[NSMutableArray array];
    }return _maintainEngineerIdArray;
}
@end
