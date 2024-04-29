//
//  NetworkViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/27.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "NetworkViewController.h"

@interface NetworkViewController ()
@property (nonatomic,strong)NSIndexPath * selIndex;
@property (nonatomic,copy)NSString * selectedURL;
@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"选择网址";
    [self.view addSubview:self.listView];
    self.listView.rowHeight = 50;
    self.listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.listView.backgroundColor = RGBA(242, 242, 242, 1);
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self setupData];
    // 默认选中行
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.listView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    if ([self.listView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.listView.delegate tableView:self.listView didSelectRowAtIndexPath:firstPath];
    }
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back{
    
    
    NSDictionary * dict = @{@"network":_selectedURL?:[self.datasource firstObject]};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"serverAddress" object:dict];
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.text = self.datasource[indexPath.row];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请选择网址";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //之前选中的，取消选择
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.accessoryType = UITableViewCellAccessoryNone;
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedURL = self.datasource[indexPath.row];
    
    [tableView reloadData];
}
-(void)setupData{
    NSArray * arr = @[NetworkServerAddress,ServerAddress];
    [self.datasource addObjectsFromArray:arr];
    
}

@end
