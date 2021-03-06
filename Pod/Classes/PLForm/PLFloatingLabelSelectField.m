//
//  PLFloatingLabelSelectField.m
//  PLForm
//
//  Created by Ash Thwaites on 11/12/2015.
//  Copyright (c) 2015 Pitch Labs. All rights reserved.
//


#import "PLFloatingLabelSelectField.h"
#import "PLExtras-UIView.h"

#import <PureLayout.h>

@interface PLFloatingLabelSelectField ()
{
    NSLayoutConstraint *floatingLabelCenterConstraint;
    NSLayoutConstraint *textLabelCenterConstraint;
    NSLayoutConstraint *valueLabelCenterConstraint;
}

@end


@implementation PLFloatingLabelSelectField


-(void)setup
{
    // create the additional floating label
    _floatingLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _floatingLabel.alpha = 0.0f;
    [self addSubview:_floatingLabel];
    
    [super setup];
    
    self.valueLabel.textAlignment = NSTextAlignmentLeft;
    self.valueLabel.alpha = 0.0f;
}

-(void)setFloatingFont:(UIFont *)font
{
    _floatingLabel.font = font;
}

-(UIFont*)floatingFont
{
    return _floatingLabel.font;
}

-(void)setFloatingColor:(UIColor *)color
{
    _floatingLabel.textColor = color;
}

-(UIColor *)floatingColor
{
    return _floatingLabel.textColor;
}

- (void)setTitle:(NSString *)title
{
    _floatingLabel.text = title;
    [super setTitle:title];
}

-(void)removeInsetConstraints
{
    [self removeConstraintsForView:_floatingLabel];
    floatingLabelCenterConstraint = nil;
    textLabelCenterConstraint = nil;
    valueLabelCenterConstraint = nil;
    [super removeInsetConstraints];
}


- (void)updateConstraints
{
    if (self.superview)
    {
        if (![self hasConstraintsForView:_floatingLabel])
        {
            [_floatingLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.contentInsets.left];
            floatingLabelCenterConstraint = [_floatingLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:0];
        }
        
        if (![self hasConstraintsForView:self.valueLabel])
        {
            [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.contentInsets.left];
            [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:self.contentInsets.right];
            valueLabelCenterConstraint = [self.valueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:0];
        }
        
        if (![self hasConstraintsForView:self.titleLabel])
        {
            [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.contentInsets.left];
            [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:self.contentInsets.right];
            textLabelCenterConstraint = [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:0];
        }
        if (self.valueLabel.text.length >0)
        {
            [self showFloatingLabel:NO];
        }
    }
    [super updateConstraints];
}

-(void)updateWithElement:(PLFormSelectFieldElement*)element
{
    [super updateWithElement:element];
    if (self.valueLabel.text.length >0)
    {
        [self showFloatingLabel:NO];
    }
}

#pragma mark -
#pragma mark Picker view data source

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [super pickerView:pickerView didSelectRow:row inComponent:component];
    if (self.element.index >=0)
        [self showFloatingLabel:YES];
    else
        [self hideFloatingLabel:YES];
}

#pragma mark Collection view data source

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    if (self.element.index >=0)
        [self showFloatingLabel:YES];
    else
        [self hideFloatingLabel:YES];
}

// we dont have a hide label method cos currently its not possible to delete a date once weve set one
- (void)showFloatingLabel:(BOOL)animated
{
    CGSize labelSize = [_floatingLabel intrinsicContentSize];
    CGSize textSize = [self.valueLabel intrinsicContentSize];
    floatingLabelCenterConstraint.constant = - ((self.bounds.size.height - labelSize.height) / 2.0f) + self.contentInsets.top;
    valueLabelCenterConstraint.constant = ((self.bounds.size.height - textSize.height) / 2.0f) - self.contentInsets.bottom;
    textLabelCenterConstraint.constant = valueLabelCenterConstraint.constant;
    
    void (^showBlock)() = ^{
        self.floatingLabel.alpha = 1.0f;
        self.valueLabel.alpha = 1.0f;
        self.titleLabel.alpha = 0.0f;
        [self layoutIfNeeded];
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else
    {
        showBlock();
    }
}

- (void)hideFloatingLabel:(BOOL)animated
{
    floatingLabelCenterConstraint.constant = 0;
    valueLabelCenterConstraint.constant = 0;
    textLabelCenterConstraint.constant = 0;

    void (^hideBlock)() = ^{
        self.floatingLabel.alpha = 0.0f;
        self.valueLabel.alpha = 0.0f;
        self.titleLabel.alpha = 1.0f;
        [self layoutIfNeeded];
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else
    {
        hideBlock();
    }
}

@end
