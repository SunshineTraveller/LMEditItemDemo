//
//  MoveItemController.m
//  test
//
//  Created by CBCT_MBP on 2020/7/23.
//  Copyright © 2020 zgcx. All rights reserved.
//

#import "MoveItemController.h"

#import "MoveItemCell.h"

@interface MoveItemController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView               *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout     *flowLayout;

// data
@property(nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) UILongPressGestureRecognizer   *recognize;
@property (nonatomic,strong) UILongPressGestureRecognizer   *longGesture;
@property (nonatomic,assign) BOOL                           isBegin;

@end

@implementation MoveItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    [self addRecognize];
    
}

#pragma mark -- UICollectionView / DataSource Delegate
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/**
 移动item

 @param collectionView collectionView
 @param sourceIndexPath 开始
 @param destinationIndexPath 结束
 */
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id objc = [self.data objectAtIndex:sourceIndexPath.item];
    
    [self.data removeObject:objc];
    [self.data insertObject:objc atIndex:destinationIndexPath.item];
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoveItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoveItemCell" forIndexPath:indexPath];
    cell.title.text = self.data[indexPath.item];
    if (_isBegin == YES) {
        [self startLongPress:cell];
    }
    return cell;
}


#pragma mark -- UICollectionViewFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 30);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 17;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.data[indexPath.item];
    NSLog(@"%@",title);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

/**
 *  添加长按抖动手势
 */
-(void)addRecognize {
    
    if (!_recognize) {
        _recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    }
    _recognize.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:_recognize];
}
/**
 *  添加长按拖动item手势
 */
-(void)addLongGesture {
    
    if (_longGesture == nil) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    }
    _longGesture.minimumPressDuration = 0;
    [self.collectionView addGestureRecognizer:_longGesture];
}

/**
 *  添加右上角确定按钮
 */
-(void)addConfirmBtn {
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(0, 0, 54, 44);
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    confirm.backgroundColor = [UIColor clearColor];
    [confirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    
}

#pragma mark -- Target_Action_Methods
/**
 *  长按手势
 */
-(void)startLongPress:(MoveItemCell *)cell {
    
    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:@"rotation"];
    if (animation == nil) {
        [self shakeImage:cell];
    }else{
        [self resume:cell];
    }
}

// 复原
-(void)resume:(MoveItemCell *)cell {
    cell.layer.speed = 1.0;
}

/** 动画 */
-(void)shakeImage:(MoveItemCell *)cell {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:0.1];
    animation.fromValue = @(-M_1_PI/6);
    animation.toValue = @(M_1_PI/6);
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [cell.layer addAnimation:animation forKey:@"rotation"];
    
}
/**
 *  长按手势
 */
-(void)longPressGestureAction:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            // 判断手势点是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            
            if (indexPath.row >= 0) {
                _isBegin = YES;
                [self.collectionView removeGestureRecognizer:_recognize];
                [self addLongGesture];
                [self addConfirmBtn];
                [self.collectionView reloadData];
            }else {
                break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {}
            break;
        case UIGestureRecognizerStateEnded: {}
            break;
        default:
            break;
    }
}


-(void)confirmBtnAction:(UIButton *)btn {
 
    // 移除拖动手势 替换成抖动手势
    [self.collectionView removeGestureRecognizer:_longGesture];
    _isBegin = NO;
    [self addRecognize];
    [self.collectionView reloadData];
    
}


/**
 *  长按拖动手势事件
 */
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
   static NSInteger index = 0;    // 记录section，防止跨section移动
    switch (longGesture.state) {
            // 设置房源大厅不可移动
        case UIGestureRecognizerStateBegan:{
            // 通过手势获取点，通过点获取点击的indexPath， 移动该item
            NSIndexPath *AindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
//            if (AindexPath.row > 0) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:AindexPath];
                index = AindexPath.section;
//            }else{
//                break;
//            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            // 更新移动位置
            NSIndexPath *BindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            
//            if (BindexPath.row<1) {
//                break;
//            }else {
                // 同一section
                if (index == BindexPath.section) {
                    [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
                }
//            }
            break;
        }
            break;
        case UIGestureRecognizerStateEnded:
            // 移动完成关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
            
        default:
            [self.collectionView endInteractiveMovement];
            break;
    }
}

-(NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
        NSArray *sdasd = @[@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888",@"999",@"AAA",@"VVV",@"SSS",@"DDD",@"EEE",];
        [_data addObjectsFromArray:sdasd];
    }
    return _data;
}


-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.flowLayout];

        _collectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MoveItemCell class] forCellWithReuseIdentifier:@"MoveItemCell"];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

@end
