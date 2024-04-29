//
//  FormCollectionViewCell.m
//  TestXXX
//
//  Created by Andy on 2021/6/3.
//

#import "FormCollectionViewCell.h"
#import "FCMaxOrMinLayer.h"
#import <IQKeyboardManager.h>
@interface FormCollectionViewCell ()
@property (nonatomic,strong)CATextLayer *textLayer;

@property (nonatomic,strong)FCMaxOrMinLayer *maxLayer;
@property (nonatomic,strong)FCMaxOrMinLayer *minLayer;

@property (nonatomic,strong)UILabel *textLabel;

@end
@implementation FormCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        //[IQKeyboardManager sharedManager].enable =NO;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;

}



#pragma mark - Private Methods

- (void)configUI{
    self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.textLabel];
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

#pragma mark - Getter Methods

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel                 = [[UILabel alloc] init];
        _textLabel.textAlignment   = NSTextAlignmentCenter;
        _textLabel.textColor       = [UIColor blackColor];
        _textLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
        _textLabel.font            = [UIFont systemFontOfSize:17];
        _textLabel.numberOfLines   = 0;
    }
    return _textLabel;
}


- (CATextLayer *)textLayer{
    if (!_textLayer) {
        _textLayer = [[CATextLayer alloc] init];
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.foregroundColor = [UIColor blackColor].CGColor;
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.wrapped = NO;
        _textLayer.truncationMode = kCATruncationEnd;
        UIFont *font = [UIFont systemFontOfSize:17];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        _textLayer.font = fontRef;
        _textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
    }
    return _textLayer;
}

- (FCMaxOrMinLayer *)maxLayer{
    if (!_maxLayer) {
        _maxLayer = [FCMaxOrMinLayer layer];
        _maxLayer.type = FCMaxOrMinLayerTypeMax;
        _maxLayer.bounds = CGRectMake(0, 0, 36, 15) ;
        _maxLayer.contentsScale = [UIScreen mainScreen].scale;
        _maxLayer.hidden = YES;
    }
    return _maxLayer;
}
- (FCMaxOrMinLayer *)minLayer{
    if (!_minLayer) {
        _minLayer = [FCMaxOrMinLayer layer];
        _minLayer.type = FCMaxOrMinLayerTypeMin;
        _minLayer.bounds = CGRectMake(0, 0, 36, 15) ;
        _minLayer.contentsScale = [UIScreen mainScreen].scale;
        _minLayer.hidden = YES;
    }
    return _minLayer;
}

#pragma mark - Setter Methods

- (void)setText:(NSString *)text{
    _text = text;
    self.textLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}

-(void)setAligmentType:(TextAligment)aligmentType{
    _aligmentType  = aligmentType;
    switch (aligmentType) {
        case TextLeft:
            self.textLabel.textAlignment  =NSTextAlignmentLeft;
            break;
        case TextCenter:
            self.textLabel.textAlignment  =NSTextAlignmentCenter;
            break;
        case TextRight:
            self.textLabel.textAlignment  =NSTextAlignmentRight;
            
        default:
            break;
    }
}
- (void)setCellType:(FormCollectionViewCellType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case FCChartCollectionViewCellTypeDefault:
        {
            self.textLayer.frame = self.bounds;
            self.minLayer.hidden = YES;
            self.maxLayer.hidden = YES;
            self.textLayer.alignmentMode = kCAAlignmentCenter;
        }
            break;
        case FCChartCollectionViewCellTypeMax:
        {
            self.textLayer.frame = CGRectMake(0, (self.bounds.size.height-21)/2, self.bounds.size.width/2, 16);
            self.minLayer.hidden = YES;
            self.maxLayer.hidden = NO;
            self.textLayer.alignmentMode = kCAAlignmentRight;

        }
            break;
        case FCChartCollectionViewCellTypeMin:
        {
            self.textLayer.frame = CGRectMake(0, (self.bounds.size.height-21)/2, self.bounds.size.width/2, 16);
            self.minLayer.hidden = NO;
            self.maxLayer.hidden = YES;
            self.textLayer.alignmentMode = kCAAlignmentRight;

        }
            break;
            
        default:
            break;
    }
}

@end
