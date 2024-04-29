//
//  UIView+EMUIView.m
//  XXXXXXXXX
//
//  Created by Andy on 2021/9/19.
//

#import "UIView+EMUIView.h"
#import <objc/runtime.h>
@implementation UIView (EMUIView)

- (NSArray<UIView*>*)deepResponderViews
{
    NSMutableArray<UIView*> *textFields = [[NSMutableArray alloc] init];
    
    for (UIView *textField in self.subviews)
    {
        if ((textField == self || textField.ignoreSwitchingByNextPrevious == NO) && [textField _IQcanBecomeFirstResponder])
        {
            [textFields addObject:textField];
        }
        //Sometimes there are hidden or disabled views and textField inside them still recorded, so we added some more validations here (Bug ID: #458)
        //Uncommented else (Bug ID: #625)
        else if (textField.subviews.count && [textField isUserInteractionEnabled] && ![textField isHidden] && [textField alpha]!=0.0)
        {
            [textFields addObjectsFromArray:[textField deepResponderViews]];
        }
    }

    //subviews are returning in incorrect order. Sorting according the frames 'y'.
    return [textFields sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        CGRect frame1 = [view1 convertRect:view1.bounds toView:self];
        CGRect frame2 = [view2 convertRect:view2.bounds toView:self];
        
        CGFloat x1 = CGRectGetMinX(frame1);
        CGFloat y1 = CGRectGetMinY(frame1);
        CGFloat x2 = CGRectGetMinX(frame2);
        CGFloat y2 = CGRectGetMinY(frame2);
        
        if (y1 < y2)  return NSOrderedAscending;
        
        else if (y1 > y2) return NSOrderedDescending;
        
        //Else both y are same so checking for x positions
        else if (x1 < x2)  return NSOrderedAscending;
        
        else if (x1 > x2) return NSOrderedDescending;
        
        else    return NSOrderedSame;
    }];

    return textFields;
}

-(BOOL)_IQcanBecomeFirstResponder
{
    BOOL _IQcanBecomeFirstResponder = NO;
    
    if ([self conformsToProtocol:@protocol(UITextInput)]) {
        if ([self respondsToSelector:@selector(isEditable)] && [self isKindOfClass:[UIScrollView class]])
        {
            _IQcanBecomeFirstResponder = [(UITextView*)self isEditable];
        }
        else if ([self respondsToSelector:@selector(isEnabled)])
        {
            _IQcanBecomeFirstResponder = [(UITextField*)self isEnabled];
        }
    }
    
    if (_IQcanBecomeFirstResponder == YES)
    {
        _IQcanBecomeFirstResponder = ([self isUserInteractionEnabled] && ![self isHidden] && [self alpha]!=0.0 && ![self isAlertViewTextField]  && !self.textFieldSearchBar);
    }
    
    return _IQcanBecomeFirstResponder;
}

-(BOOL)isAlertViewTextField
{
    UIResponder *alertViewController = [self viewContainingController];
    
    BOOL isAlertViewTextField = NO;
    while (alertViewController && isAlertViewTextField == NO)
    {
        if ([alertViewController isKindOfClass:[UIAlertController class]])
        {
            isAlertViewTextField = YES;
            break;
        }

        alertViewController = [alertViewController nextResponder];
    }
    
    return isAlertViewTextField;
}
-(UIViewController*)viewContainingController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;

    } while (nextResponder);

    return nil;
}

-(UISearchBar *)textFieldSearchBar
{
    UIResponder *searchBar = [self nextResponder];
    
    while (searchBar)
    {
        if ([searchBar isKindOfClass:[UISearchBar class]])
        {
            return (UISearchBar*)searchBar;
        }
        else if ([searchBar isKindOfClass:[UIViewController class]])    //If found viewcontroller but still not found UISearchBar then it's not the search bar textfield
        {
            break;
        }
        
        searchBar = [searchBar nextResponder];
    }
    
    return nil;
}
-(BOOL)ignoreSwitchingByNextPrevious
{
    NSNumber *ignoreSwitchingByNextPrevious = objc_getAssociatedObject(self, @selector(ignoreSwitchingByNextPrevious));
    
    return [ignoreSwitchingByNextPrevious boolValue];
}

-(BOOL)goToNextResponderOrResign:(UIView*)textField{
    NSArray<UIView*> *textFields = nil;
    textFields = [self deepResponderViews];
    NSUInteger index = [textFields indexOfObject:textField];
    
    //If it is not last textField. then it's next object becomeFirstResponder.
    if (index != NSNotFound && index < textFields.count-1)
    {
        [textFields[index+1] becomeFirstResponder];
        return NO;
    }
    else
    {
        [textField resignFirstResponder];
        return YES;
    }
    
}

@end
