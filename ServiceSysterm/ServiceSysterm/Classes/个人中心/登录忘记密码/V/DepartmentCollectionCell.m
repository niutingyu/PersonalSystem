//
//  DepartmentCollectionCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DepartmentCollectionCell.h"
#import "ToolBar.h"
#import "MemberAlertView.h"
#import "AssetConst.h"


@interface DepartmentCollectionCell ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)ToolBar *toolBar;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * countLabel;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end
@implementation DepartmentCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [self creatView];
    }
    return self;
}

-(void)creatView{
    UIImageView * headImage = [[UIImageView alloc]init];
    headImage.image =[UIImage imageNamed:@"qwer.jpg"];
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.clipsToBounds = YES;
    [self.contentView addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(100);
    }];
    UILabel * titleLab =[[UILabel alloc]init];
    titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLab;
    [headImage addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.right.mas_offset(-2);
        make.centerY.mas_equalTo(headImage);
        
    }];
    
    UIButton * cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelController) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(-2);
        make.top.mas_offset(-3);
        make.width.mas_equalTo(Ratio(36));
        make.height.mas_equalTo(Ratio(36));
    }];
    
    
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =[UIView new];
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-76);
            make.top.mas_equalTo(headImage.mas_bottom).mas_offset(0);
        }];
    }
    UIView * labView =[[UIView alloc]init];
    labView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:labView];
    [labView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(35);
    }];
    UILabel * countLab =[[UILabel alloc]init];
    countLab.font = [UIFont systemFontOfSize:14.0f];
    countLab.textAlignment = NSTextAlignmentCenter;
    countLab.text =@"0/0";
    _countLabel = countLab;
    [countLab sizeToFit];
    [labView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(labView);
        make.centerY.mas_equalTo(labView);
    }];
    
    UIView * textView =[[UIView alloc]init];
    textView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame)-45, self.contentView.frame.size.width, 45);
    textView.backgroundColor = RGBA(242, 242, 242, 1);
    [self.contentView addSubview:textView];
    CGFloat width = self.contentView.frame.size.width;
   
   
    UITextField * departmentTextF = [[UITextField alloc]init];
    departmentTextF.placeholder =@"部门搜索";
    departmentTextF.backgroundColor =[UIColor whiteColor];
    departmentTextF.textAlignment =NSTextAlignmentCenter;
    departmentTextF.inputAccessoryView =self.toolBar;
    departmentTextF.tag =100;
    self.departmentTextField =departmentTextF;
    [textView addSubview:departmentTextF];
    [departmentTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(1);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo((width-5)/3);
        
    }];
    
    UITextField *jobNumberTextF =[[UITextField alloc]init];
    jobNumberTextF.placeholder =@"工号搜索";
    jobNumberTextF.backgroundColor =[UIColor whiteColor];
    jobNumberTextF.textAlignment = NSTextAlignmentCenter;
    jobNumberTextF.inputAccessoryView =self.toolBar;
    jobNumberTextF.tag =101;
    self.jobTextField =jobNumberTextF;
    [textView addSubview:jobNumberTextF];
    [jobNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(departmentTextF.mas_right).mas_offset(1);
        make.top.mas_offset(1);
        make.width.mas_equalTo((width-5)/3);
        make.height.mas_equalTo(44);
    }];
    UITextField * nameTextF =[[UITextField alloc]init];
    nameTextF.placeholder =@"姓名搜索";
    nameTextF.backgroundColor =[UIColor whiteColor];
    nameTextF.textAlignment =NSTextAlignmentCenter;
    nameTextF.inputAccessoryView =self.toolBar;
    nameTextF.tag =102;
    self.nameTextField =nameTextF;
    [textView addSubview:nameTextF];
    [nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(jobNumberTextF.mas_right).mas_offset(1);
        make.top.mas_offset(1);
        make.width.mas_equalTo((width-5)/3);
        make.height.mas_equalTo(44);
    }];

}



-(void)cofigureCell:(NSMutableArray*)datasource itemIdx:(NSInteger)itemIdx model:(MemberModel*)model{

 
    _titleLabel.text = model.DepName;
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",itemIdx+1,datasource.count];
    
    _countLabel.attributedText = [Units changeLabel:[NSString stringWithFormat:@"%ld",itemIdx+1] wholeString:_countLabel.text];
    NSMutableArray * arr = [PeopleListModel mj_objectArrayWithKeyValuesArray:model.PepList];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:arr];
    [self.tableView reloadData];
    
    
}

-(void)congiureCell{
    _titleLabel.text = @"";
    _countLabel.text =@"0/0";
    
    _countLabel.attributedText = [Units changeLabel:[NSString stringWithFormat:@"%d",0] wholeString:_countLabel.text];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableReused"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableReused"];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.detailTextLabel.font =[UIFont systemFontOfSize:16.0f];
    cell.detailTextLabel.textColor =[UIColor blackColor];
    PeopleListModel * model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@",model.FName];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"工号:%@",model.UserName];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleListModel * model = self.dataArray[indexPath.row];
    [MemberAlertView showAlertViewModel:model];
}



-(void)cancelController{
    if (self.backBlock) {
        self.backBlock();
    }
}
- (ToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [ToolBar toolBar];
        
        __weak typeof(self) weakself = self;
        _toolBar.finishBlock = ^(){
            [weakself endEditing:YES];
        };
    }
    return _toolBar;
}
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }return _dataArray;
}
@end
