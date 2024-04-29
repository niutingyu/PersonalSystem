//
//  IQCDatePickerView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/9.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCDatePickerView.h"



#define YBMainWindow  [UIApplication sharedApplication].keyWindow



@interface IQCDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView      * menuBackView;
@property (nonatomic) CGRect                relyRect;
@property (nonatomic) CGPoint               point;
@property (nonatomic, strong) UIView      * mainView;
@property (nonatomic, assign) CGFloat       itemWidth;
@property (nonatomic, assign) BOOL          isChangeDirection;
@property (nonatomic, assign) BOOL          isCornerChanged;

@property (nonatomic, strong) UIPickerView *pickerView;

@end
@implementation IQCDatePickerView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultSettings];
    }
    return self;
}

+(IQCDatePickerView*)showRelyOnView:(UIView *)view {
    
    CGRect absoluteRect = [view convertRect:view.bounds toView:YBMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    IQCDatePickerView * pickView =[[IQCDatePickerView alloc]init];
    pickView.point = relyPoint;
    pickView.relyRect  = absoluteRect;
    pickView.itemWidth  =360;
    [pickView show];
    
    return pickView;
}

#pragma mark - privates
- (void)show
{
    [YBMainWindow addSubview:_menuBackView];
    [YBMainWindow addSubview:self];

    if (self.delegate && [self.delegate respondsToSelector:@selector(IqcPopupMenuBeganShow)]) {
        [self.delegate IqcPopupMenuBeganShow];
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self->_menuBackView.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(IqcPopupMenuDidShow)]) {
            [self.delegate IqcPopupMenuDidShow];
        }
    }];
}



- (void)setDefaultSettings
{
    
    _cornerRadius = 5.0;
    _rectCorner = UIRectCornerAllCorners;
    self.isShowShadow = YES;
    _dismissOnSelected = YES;
    _dismissOnTouchOutside = YES;
   
    _offset = 0.0;
    _relyRect = CGRectZero;
    _point = CGPointZero;
    _borderWidth = 0.0;
    _borderColor = [UIColor lightGrayColor];
    _arrowWidth = 15.0;
    _arrowHeight = 10.0;
   
    _arrowDirection = YBPopupMenuArrowDirectionTop;
    _priorityDirection = IqcPopupMenuPriorityDirectionTop;
   
   
    _itemHeight = 200;
    
    _showMaskView = YES;
    _menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _menuBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _menuBackView.alpha = 0;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
    [_menuBackView addGestureRecognizer: tap];
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
   // [self.menuBackView addSubview:self.pickerView];
    [self addSubview:self.mainView];
    
  
   
}

-(UIView*)mainView{
    if (!_mainView) {
        _mainView  =[[UIView alloc]init];
        _mainView.backgroundColor =[UIColor whiteColor];
    }
    return _mainView;
}


/////////////PickView

-(UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:(CGRectMake(0, 45.5, _itemWidth, _itemHeight))];
        //_pickerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    self.layer.shadowOpacity = isShowShadow ? 0.5 : 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = isShowShadow ? 2.0 : 0;
}

- (void)setShowMaskView:(BOOL)showMaskView
{
    _showMaskView = showMaskView;
    _menuBackView.backgroundColor = showMaskView ? [[UIColor blackColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
}







- (void)setPoint:(CGPoint)point
{
    _point = point;
    [self updateUI];
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self updateUI];
}


- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateUI];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self updateUI];
}

- (void)setArrowPosition:(CGFloat)arrowPosition
{
    _arrowPosition = arrowPosition;
    [self updateUI];
}

- (void)setArrowWidth:(CGFloat)arrowWidth
{
    _arrowWidth = arrowWidth;
    [self updateUI];
}

- (void)setArrowHeight:(CGFloat)arrowHeight
{
    _arrowHeight = arrowHeight;
    [self updateUI];
}

- (void)setArrowDirection:(YBPopupMenuArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self updateUI];
}




- (void)setPriorityDirection:(IqcPopupMenuPriorityDirection)priorityDirection
{
    _priorityDirection = priorityDirection;
    [self updateUI];
}

- (void)setRectCorner:(UIRectCorner)rectCorner
{
    _rectCorner = rectCorner;
    [self updateUI];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateUI];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self updateUI];
}

- (void)updateUI
{

     _isChangeDirection = NO;
    if (_priorityDirection == IqcPopupMenuPriorityDirectionTop) {
        if (_point.y + _itemHeight + _arrowHeight > kScreenHeight - 10) {
            _arrowDirection = YBPopupMenuArrowDirectionBottom;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = YBPopupMenuArrowDirectionTop;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == IqcPopupMenuPriorityDirectionBottom) {
        if (_point.y - _itemHeight - _arrowHeight < 10) {
            _arrowDirection = YBPopupMenuArrowDirectionTop;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = YBPopupMenuArrowDirectionBottom;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == IqcPopupMenuPriorityDirectionLeft) {
        if (_point.x + _itemWidth + _arrowHeight > kScreenWidth - 10) {
            _arrowDirection = YBPopupMenuArrowDirectionRight;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = YBPopupMenuArrowDirectionLeft;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == IqcPopupMenuPriorityDirectionRight) {
        if (_point.x - _itemWidth - _arrowHeight < 10) {
            _arrowDirection = YBPopupMenuArrowDirectionLeft;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = YBPopupMenuArrowDirectionRight;
            _isChangeDirection = NO;
        }
    }
    [self setArrowPosition];
    [self setRelyRect];
    if (_arrowDirection == YBPopupMenuArrowDirectionTop) {
        CGFloat y = _isChangeDirection ? _point.y  : _point.y;
        if (_arrowPosition > _itemWidth / 2) {
            self.frame = CGRectMake(kScreenWidth - 10 - _itemWidth, y, _itemWidth, _itemHeight + _arrowHeight);
        }else if (_arrowPosition < _itemWidth / 2) {
            self.frame = CGRectMake(10, y, _itemWidth, _itemHeight + _arrowHeight);
        }else {
            self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, _itemHeight + _arrowHeight);
        }
    }else if (_arrowDirection == YBPopupMenuArrowDirectionBottom) {
        CGFloat y = _isChangeDirection ? _point.y - _arrowHeight - _itemHeight : _point.y - _arrowHeight - _itemHeight;
        if (_arrowPosition > _itemWidth / 2) {
            self.frame = CGRectMake(kScreenWidth - 10 - _itemWidth, y, _itemWidth, _itemHeight + _arrowHeight);
        }else if (_arrowPosition < _itemWidth / 2) {
            self.frame = CGRectMake(10, y, _itemWidth, _itemHeight + _arrowHeight);
        }else {
            self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, _itemHeight + _arrowHeight);
        }
    }else if (_arrowDirection == YBPopupMenuArrowDirectionLeft) {
        CGFloat x = _isChangeDirection ? _point.x : _point.x;
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, _itemHeight);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, _itemHeight);
        }else {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, _itemHeight);
        }
    }else if (_arrowDirection == YBPopupMenuArrowDirectionRight) {
        CGFloat x = _isChangeDirection ? _point.x - _itemWidth - _arrowHeight : _point.x - _itemWidth - _arrowHeight;
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, _itemHeight);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, _itemHeight);
        }else {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, _itemHeight);
        }
    }else if (_arrowDirection == YBPopupMenuArrowDirectionNone) {
        
    }
    
    if (_isChangeDirection) {
        [self changeRectCorner];
    }
    [self setAnchorPoint];
    [self setOffset];
    
    [self setNeedsDisplay];
}

- (void)setArrowPosition
{
    if (_priorityDirection == IqcPopupMenuPriorityDirectionNone) {
        return;
    }
    if (_arrowDirection == YBPopupMenuArrowDirectionTop || _arrowDirection == YBPopupMenuArrowDirectionBottom) {
        if (_point.x + _itemWidth / 2 > kScreenWidth - 10) {
            _arrowPosition = _itemWidth - (kScreenWidth - 10 - _point.x);
        }else if (_point.x < _itemWidth / 2 + 10) {
            _arrowPosition = _point.x - 10;
        }else {
            _arrowPosition = _itemWidth / 2;
        }
        
    }else if (_arrowDirection == YBPopupMenuArrowDirectionLeft || _arrowDirection == YBPopupMenuArrowDirectionRight) {
//        if (_point.y + _itemHeight / 2 > YBScreenHeight - _minSpace) {
//            _arrowPosition = _itemHeight - (YBScreenHeight - _minSpace - _point.y);
//        }else if (_point.y < _itemHeight / 2 + _minSpace) {
//            _arrowPosition = _point.y - _minSpace;
//        }else {
//            _arrowPosition = _itemHeight / 2;
//        }
    }
}

- (void)changeRectCorner
{
    if (_isCornerChanged || _rectCorner == UIRectCornerAllCorners) {
        return;
    }
    BOOL haveTopLeftCorner = NO, haveTopRightCorner = NO, haveBottomLeftCorner = NO, haveBottomRightCorner = NO;
    if (_rectCorner & UIRectCornerTopLeft) {
        haveTopLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerTopRight) {
        haveTopRightCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomLeft) {
        haveBottomLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomRight) {
        haveBottomRightCorner = YES;
    }
    
    if (_arrowDirection == YBPopupMenuArrowDirectionTop || _arrowDirection == YBPopupMenuArrowDirectionBottom) {
        
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        
    }else if (_arrowDirection == YBPopupMenuArrowDirectionLeft || _arrowDirection == YBPopupMenuArrowDirectionRight) {
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
    }
    
    _isCornerChanged = YES;
}

- (void)setAnchorPoint
{
    if (_itemWidth == 0) return;
    
    CGPoint point = CGPointMake(0.5, 0.5);
    if (_arrowDirection == YBPopupMenuArrowDirectionTop) {
        point = CGPointMake(_arrowPosition / _itemWidth, 0);
    }else if (_arrowDirection == YBPopupMenuArrowDirectionBottom) {
        point = CGPointMake(_arrowPosition / _itemWidth, 1);
    }else if (_arrowDirection == YBPopupMenuArrowDirectionLeft) {
        point = CGPointMake(0, (_itemHeight - _arrowPosition) / _itemHeight);
    }else if (_arrowDirection == YBPopupMenuArrowDirectionRight) {
        point = CGPointMake(1, (_itemHeight - _arrowPosition) / _itemHeight);
    }
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

- (void)setOffset
{
    if (_itemWidth == 0) return;
    
    CGRect originRect = self.frame;
    
    if (_arrowDirection == YBPopupMenuArrowDirectionTop) {
        originRect.origin.y += _offset;
    }else if (_arrowDirection == YBPopupMenuArrowDirectionBottom) {
        originRect.origin.y -= _offset;
    }else if (_arrowDirection == YBPopupMenuArrowDirectionLeft) {
        originRect.origin.x += _offset;
    }else if (_arrowDirection == YBPopupMenuArrowDirectionRight) {
        originRect.origin.x -= _offset;
    }
    self.frame = originRect;
}
- (void)setRelyRect
{
    if (CGRectEqualToRect(_relyRect, CGRectZero)) {
        return;
    }
    if (_arrowDirection == YBPopupMenuArrowDirectionTop) {
        _point.y = _relyRect.size.height + _relyRect.origin.y;
    }else if (_arrowDirection == YBPopupMenuArrowDirectionBottom) {
        _point.y = _relyRect.origin.y;
    }else if (_arrowDirection == YBPopupMenuArrowDirectionLeft) {
        _point = CGPointMake(_relyRect.origin.x + _relyRect.size.width, _relyRect.origin.y + _relyRect.size.height / 2);
    }else {
        _point = CGPointMake(_relyRect.origin.x, _relyRect.origin.y + _relyRect.size.height / 2);
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_arrowDirection == YBPopupMenuArrowDirectionTop) {
        self.mainView.frame = CGRectMake(_borderWidth, _borderWidth + _arrowHeight, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == YBPopupMenuArrowDirectionBottom) {
        self.mainView.frame = CGRectMake(_borderWidth, _borderWidth, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == YBPopupMenuArrowDirectionLeft) {
        self.mainView.frame = CGRectMake(_borderWidth + _arrowHeight, _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }else if (_arrowDirection == YBPopupMenuArrowDirectionRight) {
        self.mainView.frame = CGRectMake(_borderWidth , _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }
}
- (void)touchOutSide
{
    if (_dismissOnTouchOutside) {
        [self dismiss];
    }
}
- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(IqcPopupMenuBeganDismiss)]) {
        [self.delegate IqcPopupMenuBeganDismiss];
    }
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self->_menuBackView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(IqcPopupMenuDidDismiss)]) {
            [self.delegate IqcPopupMenuDidDismiss];
        }
        self.delegate = nil;
        [self removeFromSuperview];
        [self->_menuBackView removeFromSuperview];
    }];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [YBPopupMenuPath yb_bezierPathWithRect:rect rectCorner:_rectCorner cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor backgroundColor:[UIColor whiteColor] arrowWidth:_arrowWidth arrowHeight:_arrowHeight arrowPosition:_arrowPosition arrowDirection:_arrowDirection];
    [bezierPath fill];
    [bezierPath stroke];
}
@end
