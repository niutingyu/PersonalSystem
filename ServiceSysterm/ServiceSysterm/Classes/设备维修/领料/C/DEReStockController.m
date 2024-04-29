//
//  DEReStockController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEReStockController.h"
#import "DEReStockFilterView.h"
#import "DENavigationView.h"
#import "DEAlertFilterView.h"
#import "DEStockContentController.h"
#import "DEFilterMaterialController.h"

#import "DESegmentControl.h"

#import "DEChildPickListController.h"
#import "DEReBackController.h"
#import "DEStockListController.h"
#import "DETimeFilterView.h"
#import "ZHPickView.h"

@interface DEReStockController ()<UIScrollViewDelegate,DESegmentControlDataSource,DESegmentControlDelegate,UITextFieldDelegate,ZHPickViewDelegate>

@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic,strong)DESegmentControl * segmentControl;

@property (nonatomic,weak)DETimeFilterView * timeFilterView;

@end

@implementation DEReStockController


-(void)viewWillAppear:(BOOL)animated{
  
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _segmentTitles = @[@"领料单",@"可回仓",@"回仓表"];

   //滑动选择条
    [self setSegmentControl];
    [self setupTimeFilterView];
    [self setBgScrollview];
    [self setDetailView];
    
   
    

   //筛选条件
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shaixuan"] style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
    self.navigationItem.rightBarButtonItem = rightItem;
 
}
-(void)filter{
    DEFilterMaterialController * controller = [DEFilterMaterialController new];
    if (self.segmentControl.tapIndex  ==0 || self.segmentControl.tapIndex ==1) {
        controller.flag = 100;
    }else{
        controller.flag =  101;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -=== = = = ===滑动选择条

-(void)setSegmentControl{
    _segmentControl = [[DESegmentControl alloc] initWithFrame:CGRectMake(kScreenWidth/2 - (70 * [_segmentTitles count])/2, 0, 70 * [_segmentTitles count], 40)];
    
    _segmentControl.delegate = self;
    _segmentControl.dataSource = self;
    _segmentControl.alpha = 1;
    
    self.navigationItem.titleView =_segmentControl;
}

-(void)setupTimeFilterView{
    UIView * backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [self.view addSubview:backgroundView];
    DETimeFilterView * timeView = [[NSBundle mainBundle]loadNibNamed:@"DETimeFilterView" owner:nil options:nil].firstObject;
    timeView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    timeView.beginTimeTextField.delegate = self;
    timeView.endTimeTextField.delegate = self;
    self.timeFilterView = timeView;
    timeView.beginTimeTextField.inputView =[UIView new];
    timeView.endTimeTextField.inputView =[UIView new];
    [backgroundView addSubview:timeView];
}
- (NSArray *)getSegmentControlTitles
{
    return _segmentTitles;
}
- (void)setBgScrollview
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight-50)];
    _contentScrollView.delegate = self;
    _contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth * [_segmentTitles count], kScreenHeight-50);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    [self.view addSubview:_contentScrollView];
}
- (void)setDetailView
{
    //这里为了避免该控制器耦合性高的问题，所以使用addChildViewController的形式，来添加视图
    //详情
    CGFloat tableH = _contentScrollView.frame.size.height;
    DEChildPickListController *pickListController = [[DEChildPickListController alloc] init];
    //_detailViewController.image = _image;
    [self addChildViewController:pickListController];
    [pickListController didMoveToParentViewController:self];
    pickListController.controllerTag =0;
    [pickListController.view setFrame:CGRectMake(0, 0, kScreenWidth, tableH)];
    //注意视图要添加到_bgScrollView上
    [_contentScrollView addSubview:pickListController.view];
    
    
    
    
    //可回仓
    DEReBackController *backController = [[DEReBackController alloc] init];
    [self addChildViewController:backController];
    [backController didMoveToParentViewController:self];
    backController.controllerTag = 1;
    [backController.view setFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableH )];
    [_contentScrollView addSubview:backController.view];
    
    //回仓表
    DEStockListController *listController = [[DEStockListController alloc] init];
    [self addChildViewController:listController];
    [listController didMoveToParentViewController:self];
    listController.controllerTag = 2;
    [listController.view setFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, tableH)];
    [_contentScrollView addSubview:listController.view];
}

#pragma mark -- UIScrollViewDelegate 用于控制头部视图滑动的视差效果

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

//UITextFeildDelelgate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    ZHPickView * pick =[[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
    pick.delegate = self;
    pick.tag = textField.tag;
    [pick show];
    KWeakSelf
    pick.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
    return YES;
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSDictionary * resultDict = @{@"result":resultString,@"textFieldTag":[NSString stringWithFormat:@"%ld",pickView.tag]};
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%ld",self.segmentControl.tapIndex] object:resultDict];
    //赋值
    if (pickView.tag ==100) {
    self.timeFilterView.beginTimeTextField.text = resultString;
    }else{
     self.timeFilterView.endTimeTextField.text = resultString;
    }
    [self.view endEditing:YES];
}
@end
