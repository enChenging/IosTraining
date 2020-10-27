//
//  YCFlowLayout.m
//  IosTraining
//
//  Created by release on 2020/10/27.
//  Copyright © 2020 Mr. release. All rights reserved.
//

#import "YCFlowLayout.h"
/*
   自定义布局:只要了解5个方法

- (void)prepareLayout;

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior

- (CGSize)collectionViewContentSize;

*/
@implementation YCFlowLayout

/*
UICollectionViewLayoutAttributes:确定cell的尺寸
一个UICollectionViewLayoutAttributes对象就对应一个cell
拿到UICollectionViewLayoutAttributes相当于拿到cell
*/

// 重写它方法,扩展功能

// 什么时候调用:collectionView第一次布局,collectionView刷新的时候也会调用
// 作用:计算cell的布局,条件:cell的位置是固定不变
// - (void)prepareLayout
//{
//    [super prepareLayout];
//
//    NSLog(@"%s",__func__);
//
//}


// 作用:指定一段区域给你这段区域内cell的尺寸
// 可以一次性返回所有cell尺寸,也可以每隔一个距离返回cell
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
//    NSLog(@"%s",__func__);
    //1.获取当前显示cell的布局
    NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    for (UICollectionViewLayoutAttributes *attr in attrs) {
//        YCLog(@"-------%f--------",attr.center.x - self.collectionView.contentOffset.x);
//        YCLog(@"-------%f--------",self.collectionView.bounds.size.width * 0.5);

        //2.计算中心点距离
        CGFloat delta = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
        //3.计算比例
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width * 0.5 ) * 0.2;
        
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return attrs;
    
}

// 什么时候调用:用户手指一松开就会调用
// 作用:确定最终偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{

    // 拖动比较快 最终偏移量 不等于 手指离开时偏移量
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    // 最终偏移量
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    //1.获取最终显示的区域
    CGRect targetRect = CGRectMake(targetP.x, 0, collectionW, MAXFLOAT);
    
    //2.获取最终显示的cell
    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
    
    //获取最小间距
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        //获取距离中心点距离：注意：应该用最终的x
        CGFloat delta = (attr.center.x - targetP.x) - self.collectionView.bounds.size.width * 0.5;
        if (fabs(delta) < fabs(minDelta)) {
            minDelta = delta;
        }
    }
    
    //移动间距
    targetP.x += minDelta;
    if (targetP.x < 0) {
        targetP.x = 0;
    }
    
    return targetP;
}

// Invalidate:刷新
// 在滚动的时候是否允许刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

// 计算collectionView滚动范围
//- (CGSize)collectionViewContentSize{
//    return [super collectionViewContentSize];
//}

@end
