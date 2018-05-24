//
//  GWFDiscoverCell.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFDiscoverCell.h"
#import "GWFdiscoverImageItemCell.h"

@interface GWFDiscoverCell ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIImageView       *_iconView;
    UILabel           *_nameLabel;
    UILabel           *_timerLabel;
    UILabel           *_titleLabel;
    UILabel           *_contentLabel;
    UICollectionView  *_imageCollectionView;
}

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation GWFDiscoverCell

static NSString *const kReuseIdentifierOfCell = @"kReuseIdentifierOfGWFDiscoverCell";

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews {
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(40), GENERAL_SIZE(20), GENERAL_SIZE(90), GENERAL_SIZE(90))];
    _iconView.layer.cornerRadius = GENERAL_SIZE(90)/2;
    _iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame)+GENERAL_SIZE(20), GENERAL_SIZE(20), SCREEN_WIDTH - GENERAL_SIZE(170), GENERAL_SIZE(40))];
    _nameLabel.textColor = RGBACOLOR(114, 114, 114, 1);
    _nameLabel.font = LabelFont(30);
    [self.contentView addSubview:_nameLabel];
    
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame)+GENERAL_SIZE(20), CGRectGetMaxY(_nameLabel.frame) + GENERAL_SIZE(20), SCREEN_WIDTH - GENERAL_SIZE(170), GENERAL_SIZE(30))];
    _timerLabel.textColor = RGBACOLOR(192, 192, 192, 1);
    _timerLabel.font = LabelFont(28);
    [self.contentView addSubview:_timerLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = RGBACOLOR(114, 114, 114, 1);
    _titleLabel.font = LabelFont(30);
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = RGBACOLOR(114, 114, 114, 1);
    _contentLabel.font = LabelFont(30);
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(((SCREEN_WIDTH-GENERAL_SIZE(20)*2)/3), ((SCREEN_WIDTH-GENERAL_SIZE(20)*2)/3));
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), 220, SCREEN_WIDTH-GENERAL_SIZE(20)*2, GENERAL_SIZE(120)) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    // 注册 collectionView 的 cell
    [_collectionView registerClass:[GWFdiscoverImageItemCell class] forCellWithReuseIdentifier:kReuseIdentifierOfCell];
    [self.contentView addSubview:_collectionView];
}

-(void)setCommentModel:(GWFCommentModel *)commentModel {

    _commentModel = commentModel;
    _iconView.image = [UIImage imageNamed:@"localImage0"];
    _nameLabel.text = @"墨色烟雨人倾城";
    _timerLabel.text = [self createTime:commentModel.postTime];
    _titleLabel.text = commentModel.topTitle;
    _contentLabel.text = commentModel.topContent;
    
    if (self.commentModel.imageArray.count == 0) {
        _collectionView.hidden = YES;
    } else {
        _collectionView.hidden = NO;
        [_collectionView reloadData];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat Y = CGRectGetMaxY(_iconView.frame)+GENERAL_SIZE(20);
    
    CGSize textSize = CGSizeMake(SCREEN_WIDTH-GENERAL_SIZE(40)*2, MAXFLOAT);
    // 高度自适应
    CGSize LabelSize = [self sizeWithText:_titleLabel.text textFont:_titleLabel.font MaxSize:textSize].size;
    
    if ([_commentModel.topContent isEqualToString:@""]) {
        _titleLabel.frame = CGRectMake(GENERAL_SIZE(40), Y, LabelSize.width, 0);
    } else {
        _titleLabel.frame = CGRectMake(GENERAL_SIZE(40), Y, LabelSize.width, LabelSize.height);
    }
    
    
    CGFloat Y1 = CGRectGetMaxY(_titleLabel.frame)+GENERAL_SIZE(20);
    // 高度自适应
    CGSize LabelSize1 = [self sizeWithText:_contentLabel.text textFont:_contentLabel.font MaxSize:textSize].size;
    
    if ([_commentModel.topContent isEqualToString:@""]) {
        _contentLabel.frame = CGRectMake(GENERAL_SIZE(40), Y1, LabelSize1.width, 0);
    } else {
        _contentLabel.frame = CGRectMake(GENERAL_SIZE(40), Y1, LabelSize1.width, LabelSize1.height);
    }
    
    
    //重新计算collectionview的高度  = 总行数(rows) * itemH
    // rows = (item的总个数(count) - 1) / 列数(column) + 1
    NSInteger count = self.commentModel.imageArray.count;
    NSInteger rows = (count - 1) / 3 + 1;
    
    CGFloat collectionViewH = rows * ((SCREEN_WIDTH-GENERAL_SIZE(20)*2)/3);
    CGRect frame = _collectionView.frame;
    frame.size.height = collectionViewH;
    if ([_commentModel.topContent isEqualToString:@""]) {
        frame.origin.y = CGRectGetMaxY(_contentLabel.frame);
    } else {
        frame.origin.y = CGRectGetMaxY(_contentLabel.frame)+GENERAL_SIZE(20);
    }
    
    _collectionView.frame = frame;
}

#pragma mark ---  collectionView 的数据源方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.commentModel.imageArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWFdiscoverImageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifierOfCell forIndexPath:indexPath];
    
    [cell setDiscoverImage:self.commentModel.imageArray[indexPath.item]];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didImageItemWithIndexPath:imageArray:)]) {
        [self.delegate didImageItemWithIndexPath:indexPath imageArray:self.commentModel.origionImageArray];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"GWFDiscoverViewController";
    GWFDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GWFDiscoverCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//把时间戳转换成使用天数表示
- (NSString *)createTime:(NSString *)_updateTime
{
    NSRange range = NSMakeRange(11,8);
    NSString *hourMinitue = [_updateTime substringWithRange:range];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2014-08-06
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //#warning 真机调试的时候，必须加上这句
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CH"];
    //获取微博的发表时间
    NSDate *createDate = [formatter dateFromString:_updateTime];
    NSDate *nowDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: nowDate];
    NSDate *localeDate = [nowDate  dateByAddingTimeInterval: interval];
    NSTimeInterval now = [localeDate timeIntervalSinceDate:createDate];
    //判断是否是今年
    if (createDate.isThisYear) {
        if (createDate.isToday) {//代表今天
            return [NSString stringWithFormat:@"今天 %@",hourMinitue];
        }
        if (now/86400 > 1) {
            //超过一天
            NSString *timeString = [NSString stringWithFormat:@"%f", now/86400];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            int num = [timeString intValue];
            if (num<2) {
                return [NSString stringWithFormat:@"昨天 %@",hourMinitue];
            }else if (num>=2 && num<3) {
                return [NSString stringWithFormat:@"前天 %@",hourMinitue];
            } else {
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                return [formatter stringFromDate:createDate];
            }
        }
    }else//代表非今年
    {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [formatter stringFromDate:createDate];
    }
    return nil;
    
}
//计算文字的尺寸
-(CGRect)sizeWithText:(NSString *)text textFont:(UIFont *)font MaxSize:(CGSize)maxSize {
    NSDictionary *attr = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
}

@end
