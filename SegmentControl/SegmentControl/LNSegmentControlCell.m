//
//  LNSegmentControlCell.m
//  SegmentControl
//
//  Created by lvjialin on 2018/7/17.
//  Copyright © 2018年 lionnner. All rights reserved.
//

#import "LNSegmentControlCell.h"

@interface LNSegmentControlCell ()
{
    UILabel *_title;
}
@end

@implementation LNSegmentControlCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc] init];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(_itemInset.left, _itemInset.top, self.frame.size.width - _itemInset.left - _itemInset.right, self.frame.size.height - _itemInset.top - _itemInset.bottom);
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (isSelect) {
        _title.attributedText = _itemSelectAttributedText;
    } else {
        _title.attributedText = _itemAttributedText;
    }
}

@end
