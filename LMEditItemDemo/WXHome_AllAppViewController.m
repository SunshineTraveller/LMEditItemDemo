//
//  WXHome_AllAppViewController.m
//  WeiXingTianXia
//
//  Created by sunshine on 2017/3/21.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//
#define SCREENWIDTH         [UIScreen mainScreen].bounds.size.width
#define WIDTHCOUNT          SCREENWIDTH/375



#import "ZLMNoticeLabel.h"
#import "HttpEngine.h"
#import "SVProgressHUD.h"
#import "UIColorString.h"
#import "WX_HomeSectionOneModel.h"
#import "WXHome_AllAppViewController.h"
#import "WXHome_AllAppModel.h"
#import "WXHome_AllAppCell.h"
#import "WXHomePage_AllAppHeaderView.h"


@interface WXHome_AllAppViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIView                         *noticeView;
@property (nonatomic,strong) UICollectionView               *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout     *flowLayout;
@property (nonatomic,strong) NSMutableArray                 *firstArr;
@property (nonatomic,strong) NSMutableArray                 *secondArr;
@property (nonatomic,strong) NSMutableArray                 *thirdArr;

@property (nonatomic,strong) UILongPressGestureRecognizer   *recognize;       /** 抖动手势   */
@property (nonatomic,strong) UILongPressGestureRecognizer   *longGesture;     /** 移动手势   */
@property (nonatomic,assign) BOOL                           isBegin;          /** 是否抖动   */


@end

static NSString *REUSEDCELLID   = @"WXHome_AllAppCell";
static NSString *REUSEDHEADERID = @"WXHomePage_AllAppHeaderView";

@implementation WXHome_AllAppViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
    
}

-(void)setupUI {
    self.title = @"全部应用";
    self.view.backgroundColor = [UIColorString colorWithHexString:@"f5f5f5"];
    [self.view addSubview:self.collectionView];
    [self addRecognize];
}
-(void)loadData {
    
    [SVProgressHUD showWithStatus:@"正在加载中"];
    __weak typeof(self) weakSelf = self;
    [[HttpEngine sharedHttpEngine] lm_AllApplicationsWithID:@"188437" Success:^(MKNetworkOperation *completedOperation) {
      
        [SVProgressHUD dismiss];
        NSDictionary *dict = [completedOperation responseJSON];
        NSDictionary *dictData = dict[@"data"];
        if (![dictData isEqual:[NSNull null]]) {
            NSArray *arr1 = dictData[@"data1"];
            NSArray *arr2 = dictData[@"data2"];
            NSArray *arr3 = dictData[@"data3"];
            for (NSDictionary *dict in arr1) {
                WXHome_AllAppModel *model = [[WXHome_AllAppModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.firstArr addObject:model];
            }
            for (NSDictionary *dict in arr2) {
                WXHome_AllAppModel *model = [[WXHome_AllAppModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.secondArr addObject:model];
                
            }
            for (NSDictionary *dict in arr3) {
                WXHome_AllAppModel *model = [[WXHome_AllAppModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.thirdArr addObject:model];
            }
            [weakSelf.collectionView reloadData];
            [self.view addSubview:[ZLMNoticeLabel message:@"长按按钮，拖动图标，就能改变首页的内容和顺序！" delaySecond:4]];
        }else {
            [self.view addSubview:[ZLMNoticeLabel message:@"没数据了" delaySecond:4]];
        }
        
        
    } error:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD dismiss];
        [weakSelf.view addSubview:[ZLMNoticeLabel message:@"请检查网络" delaySecond:3]];
    }];
   
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
    

    if (sourceIndexPath.section == 0) {
        
        id objc = [self.firstArr objectAtIndex:sourceIndexPath.item];
        if (destinationIndexPath.section == 0) {
            [self.firstArr removeObject:objc];
            [self.firstArr insertObject:objc atIndex:destinationIndexPath.item];
        }else {
            [self.view addSubview:[ZLMNoticeLabel message:@"只能在同一功能里移动哦" delaySecond:2]];
        }
        
    }else if (sourceIndexPath.section == 1) {
        
        id objc = [self.secondArr objectAtIndex:sourceIndexPath.item];
        if (destinationIndexPath.section == 1) {
            [self.secondArr removeObject:objc];
            [self.secondArr insertObject:objc atIndex:destinationIndexPath.item];
        }else {
            [self.view addSubview:[ZLMNoticeLabel message:@"只能在同一功能里移动哦" delaySecond:2]];
        }
        
    }else {
        
        id objc = [self.thirdArr objectAtIndex:sourceIndexPath.item];
        if (destinationIndexPath.section == 2) {
            [self.thirdArr removeObject:objc];
            [self.thirdArr insertObject:objc atIndex:destinationIndexPath.item];
        }else {
            [self.view addSubview:[ZLMNoticeLabel message:@"只能在同一功能里移动哦" delaySecond:2]];
        }
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.firstArr.count;
    }else if(section == 1){
        return self.secondArr.count;
    }else {
        return self.thirdArr.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WXHome_AllAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEDCELLID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        WXHome_AllAppModel *model = self.firstArr[indexPath.row];
        cell.model = model;
        cell.backgroundColor = [UIColorString colorWithHexString:@"e44b32"];
    }else if(indexPath.section == 1){
        WXHome_AllAppModel *model = self.secondArr[indexPath.row];
        cell.model = model;
        cell.backgroundColor = [UIColorString colorWithHexString:@"ffa600"];
    }else {
        WXHome_AllAppModel *model = self.thirdArr[indexPath.row];
        cell.model = model;
        cell.backgroundColor = [UIColorString colorWithHexString:@"08c108"];
    }
   
    if (_isBegin == YES) {
        [self startLongPress:cell];
    }
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10*WIDTHCOUNT, 20*WIDTHCOUNT, 10*WIDTHCOUNT, 20*WIDTHCOUNT);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    WXHomePage_AllAppHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSEDHEADERID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            headerView.sectionTitle.text = @"房源应用";
        }else if (indexPath.section == 1) {
            headerView.sectionTitle.text = @"客源应用";
        }else if (indexPath.section == 2) {
            headerView.sectionTitle.text = @"我的应用";
        }
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *view = [[UICollectionReusableView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10*WIDTHCOUNT)];
        label.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:label];
        return view;
    }
    return headerView;
}
#pragma mark -- UICollectionViewFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH-40*WIDTHCOUNT-3*8*WIDTHCOUNT)/4, 44*WIDTHCOUNT);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 44*WIDTHCOUNT+1);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 17*WIDTHCOUNT;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8*WIDTHCOUNT;
}
#pragma mark -- Lazing Method
-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, SCREENWIDTH, self.view.frame.size.height) collectionViewLayout:self.flowLayout];
        [_collectionView addSubview:self.noticeView];
        _collectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[WXHome_AllAppCell class] forCellWithReuseIdentifier:REUSEDCELLID];
        [_collectionView registerClass:[WXHomePage_AllAppHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSEDHEADERID];
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
-(UIView *)noticeView {
    
    if (_noticeView == nil) {
        UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        notice.backgroundColor = [UIColor clearColor];
        notice.textColor = [UIColorString colorWithHexString:@"ef9e49"];
        notice.font = [UIFont systemFontOfSize:13];
        notice.numberOfLines = 2;
        notice.text = @"    长按按钮,拖动图标,就能改变首页的内容和顺序";
        
        UILabel *sep = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
        sep.backgroundColor = [UIColorString colorWithHexString:@"f0f0f0"];
        
        _noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, -44, SCREENWIDTH, 44)];
        _noticeView.backgroundColor = [UIColor whiteColor];
        [_noticeView addSubview:notice];
        [_noticeView addSubview:sep];
    }
    return _noticeView;
}
-(NSMutableArray *)firstArr {
    if (_firstArr == nil) {
        _firstArr = [NSMutableArray array];
    }
    return _firstArr;
}

-(NSMutableArray *)secondArr {
    if (_secondArr == nil) {
        _secondArr = [NSMutableArray array];
    }
    return _secondArr;
}

-(NSMutableArray *)thirdArr {
    if (_thirdArr == nil) {
        _thirdArr = [NSMutableArray array];
    }
    return _thirdArr;
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
    [confirm setTitleColor:[UIColorString colorWithHexString:@"333333"] forState:UIControlStateNormal];
    confirm.backgroundColor = [UIColor clearColor];
    [confirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    
}

#pragma mark -- Target_Action_Methods
/**
 *  长按手势
 */
-(void)startLongPress:(WXHome_AllAppCell *)cell {
    
    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:@"rotation"];
    if (animation == nil) {
        [self shakeImage:cell];
    }else{
        [self resume:cell];
    }
}

// 复原
-(void)resume:(WXHome_AllAppCell *)cell {
    cell.layer.speed = 1.0;
}

/** 动画 */
-(void)shakeImage:(WXHome_AllAppCell *)cell {
    
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
            // 设置房源大厅不可移动
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
    [self.view addSubview:[ZLMNoticeLabel message:@"改变成功!" delaySecond:2]];
    
}

/**
 *  确定按钮事件  这段代码为  将排好序的顺序拼成字典然后转成JSON字符串传给后台，然后在首页界面就会改变对应的顺序 读者不必理会 应根据实际项目需求去定
 
-(void)confirmBtnAction:(UIButton *)btn {
    
    NSMutableArray *arr1  = [NSMutableArray array];
    NSMutableArray *arr2  = [NSMutableArray array];
    NSMutableArray *arr3  = [NSMutableArray array];
    
    
    for (int i=0 ; i<self.firstArr.count; i++) {
        WXHome_AllAppModel *model = self.firstArr[i];
        model.orders = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic = [NSDictionary dictionary];
        dic = @{@"id":StringFromObject(model.fid),@"moduleID":model.moduleID,@"orders":model.orders};
        [arr1 addObject:dic];
    }
    for (int i=0 ; i<self.secondArr.count; i++) {
        WXHome_AllAppModel *model = self.secondArr[i];
        model.orders = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic = [NSDictionary dictionary];
        dic = @{@"id":StringFromObject(model.fid),@"moduleID":model.moduleID,@"orders":model.orders};
        [arr2 addObject:dic];
    }
    for (int i=0 ; i<self.thirdArr.count; i++) {
        WXHome_AllAppModel *model = self.thirdArr[i];
        model.orders = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic = [NSDictionary dictionary];
        dic = @{@"id":StringFromObject(model.fid),@"moduleID":model.moduleID,@"orders":model.orders};
        [arr3 addObject:dic];
    }
    

    NSDictionary *dicc = @{@"data":@[arr1,arr2,arr3]};
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载中"];
    DLog(@"%@",[@[arr1,arr2,arr3] mj_JSONString]);
    [[HttpEngine sharedHttpEngine] lm_setAllAppOrderWithID:USER_VALUE data:[dicc mj_JSONString]  success:^(MKNetworkOperation *completedOperation) {
        
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [completedOperation responseJSON];
        if ([StringFromObject(dict[@"code"]) isEqualToString:@"0"]) {
            // 移除拖动手势 替换成抖动手势
            [self.collectionView removeGestureRecognizer:_longGesture];
            _isBegin = NO;
            [self addRecognize];
            [btn removeFromSuperview];
            if ([weakSelf.delegate respondsToSelector:@selector(sortedApplications)]) {
                [weakSelf.delegate sortedApplications];
            }
            
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            [weakSelf.view addSubview:[ZLMNoticeLabel message:msg delaySecond:3]];
        }
    } error:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [weakSelf.view addSubview:[ZLMNoticeLabel message:@"请检查网络" delaySecond:3]];
        [SVProgressHUD dismiss];
    
    }];
    

}

*/
/**
 *  长按拖动手势事件
 */
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
   static NSInteger index = 0;    // 记录section，防止跨section移动
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            // 通过手势获取点，通过点获取点击的indexPath， 移动该item
            NSIndexPath *AindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (AindexPath.row > 0) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:AindexPath];
                index = AindexPath.section;
            }else{
                break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            // 更新移动位置
            NSIndexPath *BindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            
            if (BindexPath.row<1) {
                break;
            }else {
                // 同一section
                if (index == BindexPath.section) {
                    [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
                }else {
                    [self.view addSubview:[ZLMNoticeLabel message:@"只能在同一功能里移动" delaySecond:3]];
                }
                
            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end























