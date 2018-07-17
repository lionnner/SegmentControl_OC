//
//  LNSegmentControl.m
//  SegmentControl
//
//  Created by lvjialin on 2018/7/17.
//  Copyright © 2018年 lionnner. All rights reserved.
//

#import "LNSegmentControl.h"
#import "LNSegmentControlCell.h"

@interface LNSegmentControl () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSArray *_titles;
    NSIndexPath *_selectIndexPath;
    UIEdgeInsets _itemInset;
    NSMutableArray<NSValue *>*_itemSize;
    NSDictionary *_itemAttributes;
    NSDictionary *_itemSelectAttributes;
    UIScrollView *_registerScrollView;
    BOOL _isClickSelect;
    LNSegmentControlCell *_selectItem;
}
@property (nonatomic) LNSegmentBlock aBlock;
@end

@implementation LNSegmentControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
        _itemSelectAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor redColor],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        _itemInset = UIEdgeInsetsMake(5, 10, 5, 10);
        _titles = [NSArray array];
        [self setSubViews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = false;
    _collectionView.showsHorizontalScrollIndicator = false;
    [_collectionView registerClass:[LNSegmentControlCell class] forCellWithReuseIdentifier:@"LNSegmentControlCell"];
    [self addSubview:_collectionView];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LNSegmentControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LNSegmentControlCell" forIndexPath:indexPath];
    cell.itemInset = _itemInset;
    cell.itemAttributedText = [[NSAttributedString alloc] initWithString:[_titles objectAtIndex:indexPath.item] attributes:_itemAttributes];
    cell.itemSelectAttributedText = [[NSAttributedString alloc] initWithString:[_titles objectAtIndex:indexPath.item] attributes:_itemSelectAttributes];
    cell.isSelect = indexPath == _selectIndexPath;
    if (cell.isSelect) {
        _selectItem = cell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   NSValue *itemSize = _itemSize[indexPath.item];
    return [itemSize CGSizeValue];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isClickSelect = true;
    [self setSelectIndexPath:indexPath];
    [collectionView selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - PrivateMethod
- (void)touchPan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        _isClickSelect = false;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!_isClickSelect) {
        [self monitor:_registerScrollView];
    }
}

- (void)monitor:(UIScrollView *)scrollView
{
    if (_titles && _selectIndexPath) {
        CGFloat page = scrollView.contentOffset.x / scrollView.frame.size.width;
        NSInteger nextIndex = _selectIndexPath.item + 1;
        NSInteger lastIndex = _selectIndexPath.item - 1;
        if (page > (float)_selectIndexPath.item) {
            // 下一个
            if (nextIndex < _titles.count) {
                if (page >= (float)nextIndex) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:nextIndex inSection:0];
                    [_collectionView selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                    [self setSelectIndexPath:indexPath];
                }
            }
        } else {
            //上一个
            if (lastIndex >= 0) {
                if (page <= (float)lastIndex) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastIndex inSection:0];
                    [_collectionView selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                    [self setSelectIndexPath:indexPath];
                }
            }
        }
    }
}

- (void)reloadItemSizes
{
    _itemSize = [NSMutableArray arrayWithCapacity:0];
    if (_titles) {
        for (NSString *title in _titles) {
            CGSize itemTitleSize = [self getItemTitleSize:title attributes:_itemAttributes];
            if (!_itemSelectAttributes) {
                CGSize itemSelectTitleSize = [self getItemTitleSize:title attributes:_itemSelectAttributes];
                itemTitleSize = itemTitleSize.width >= itemSelectTitleSize.width? itemTitleSize: itemSelectTitleSize;
            }
            CGSize itemSize = CGSizeMake(itemTitleSize.width + _itemInset.left + _itemInset.right, self.frame.size.height);
            [_itemSize addObject:[NSValue valueWithCGSize:itemSize]];
        }
    } else {
        [_itemSize removeAllObjects];
    }
}

- (void)setSelectIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndexPath != indexPath) {
        _selectIndexPath =  indexPath;
        if (indexPath != nil) {
            _selectItem.isSelect = false;
            _selectItem = (LNSegmentControlCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            _selectItem.isSelect = true;
            _aBlock(indexPath.item);

        } else {
            _selectItem = nil;
        }
    }
}
- (CGSize)getItemTitleSize:(NSString *)title attributes:(NSDictionary *)attributes
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    return [attrStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height - _itemInset.top - _itemInset.bottom) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

#pragma mark - PublicMethod
- (void)reload:(NSArray *)titles selectIndex:(NSInteger)selectIndex actionIndex:(LNSegmentBlock)aBlock
{
    [self layoutIfNeeded];
    _aBlock = aBlock;
    _isClickSelect = true;
    _titles = [NSArray arrayWithArray:titles];
    [self setSelectIndexPath:nil];
    [_collectionView reloadData];
    [self reloadItemSizes];

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectIndex inSection:0];
    [self setSelectIndexPath:indexPath];
    [_collectionView selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)registerScrollView:(UIScrollView *)scrollView
{
    if (_registerScrollView != scrollView) {
        if (_registerScrollView != nil) {
            [[_registerScrollView panGestureRecognizer] removeTarget:self action:@selector(touchPan:)];
            [_registerScrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        }
        _registerScrollView = scrollView;
        [[_registerScrollView panGestureRecognizer] addTarget:self action:@selector(touchPan:)];
        [_registerScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

@end
