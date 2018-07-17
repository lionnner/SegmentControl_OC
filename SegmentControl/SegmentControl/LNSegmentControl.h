//
//  LNSegmentControl.h
//  SegmentControl
//
//  Created by lvjialin on 2018/7/17.
//  Copyright © 2018年 lionnner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LNSegmentBlock)(NSInteger actionIndex);

@interface LNSegmentControl : UIView

- (void)reload:(NSArray *)titles selectIndex:(NSInteger)selectIndex actionIndex:(LNSegmentBlock)aBlock;

- (void)registerScrollView:(UIScrollView *)scrollView;

@end
