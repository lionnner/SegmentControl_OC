//
//  ViewController.m
//  SegmentControl
//
//  Created by lvjialin on 2018/7/17.
//  Copyright © 2018年 lionnner. All rights reserved.
//

#import "ViewController.h"
#import "LNSegmentControl.h"
#import "Masonry.h"
#import "ViewControllerCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    LNSegmentControl *_seg;
    UICollectionView *_collectionView;
    
    NSArray *_titles;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _seg = [[LNSegmentControl alloc] init];
    [self.view addSubview:_seg];
    [_seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.height.mas_equalTo(40);
    }];
    _titles = @[@"111111",@"2222222",@"3333333",@"4444444",@"55555555",@"66666666",@"777777777",@"88888888"];
    [_seg reload:_titles selectIndex:2 actionIndex:^(NSInteger actionIndex) {
        NSLog(@"--------%ld",(long)actionIndex);
        dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:actionIndex inSection:0] animated:false scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        });
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[ViewControllerCell class] forCellWithReuseIdentifier:@"ViewControllerCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = true;
    _collectionView.showsVerticalScrollIndicator = false;
    _collectionView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_seg.mas_bottom);
    }];
    
    [_seg registerScrollView:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ViewControllerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ViewControllerCell" forIndexPath:indexPath];
    UIColor *bgColor =  [UIColor colorWithRed:(float)(100 + indexPath.item * 15)/255 green:(float)(80 + indexPath.item * 18)/255 blue:(float)(60 + indexPath.item * 8)/255 alpha:1];
    cell.backgroundColor = bgColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}
@end
