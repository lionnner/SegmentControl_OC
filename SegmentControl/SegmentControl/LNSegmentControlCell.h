//
//  LNSegmentControlCell.h
//  SegmentControl
//
//  Created by lvjialin on 2018/7/17.
//  Copyright © 2018年 lionnner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface LNSegmentControlCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSAttributedString *itemAttributedText;

@property (nonatomic, copy) NSAttributedString *itemSelectAttributedText;

@property (nonatomic, assign) UIEdgeInsets itemInset;
@end
