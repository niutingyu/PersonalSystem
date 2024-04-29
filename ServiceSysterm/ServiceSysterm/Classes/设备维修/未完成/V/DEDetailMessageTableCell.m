//
//  DEDetailMessageTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEDetailMessageTableCell.h"
#import "DEDetailMessageCollectionCell.h"

@interface DEDetailMessageTableCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView * collectionView;

@end
@implementation DEDetailMessageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCell{
    [self.collectionView reloadData];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
//        debugLog(@"- - --%f",self.collectionView.collectionViewLayout.collectionViewContentSize.height);
//    }];
 
   // [self.delegate didChangeCell:self];
}
-(void)setModel:(ExceptionModel *)model{
    _model =model;
    [self.collectionView reloadData];
    model.contentH = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DEDetailMessageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.model.ContentName;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_model.contentW, 30);
}
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout =[[UICollectionViewFlowLayout alloc]init];
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate =self;
        _collectionView.dataSource =self;
        _collectionView.autoresizingMask =UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor =[UIColor whiteColor];
        [_collectionView registerClass:[DEDetailMessageCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
       // [self.contentView addSubview:_collectionView];
//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.edges.mas_equalTo(self);
//
//
//        }];
        
    }
    return _collectionView;
}


@end
