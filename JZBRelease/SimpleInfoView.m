//
//  SimpleInfoView.m
//  JZBRelease
//
//  Created by zcl on 2016/10/4.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SimpleInfoView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "DealNormalUtil.h"
@implementation SimpleInfoView{
    UILabel *intevalLabel,*intevalLabel1;
    UIView *intevalView;
}

-(instancetype)initWithFrame:(CGRect)frame WithData:(GetValueObject *) obj{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) updateFrameWithData:(GetValueObject *) obj{
    Users *user = (Users *)obj;
    if (!self.answerFromLabel) {
        NSString *ansStr = @"分享来自：";
        self.answerFromLabel = [[UILabel alloc]init];
        [self addSubview:self.answerFromLabel];
        [self.answerFromLabel setFont:[UIFont systemFontOfSize:14]];
        NSDictionary *ansAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        [self.answerFromLabel setFrame:CGRectMake(10, 17, [ansStr sizeWithAttributes:ansAttrs].width, [ansStr sizeWithAttributes:ansAttrs].height)];
        self.answerFromLabel.textAlignment = NSTextAlignmentLeft;
        [self.answerFromLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"2197f6"]];
        [self.answerFromLabel setText:ansStr];
    }
    if (!self.avatarView) {
        self.avatarView = [[UIImageView alloc]init];
        [self addSubview:self.avatarView];
        [self.avatarView setFrame:CGRectMake(self.answerFromLabel.frame.size.width + self.answerFromLabel.frame.origin.x, 13, 25, 25)];
        self.avatarView.layer.cornerRadius = 25.0 / 2;
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avtarTap)];
        [self.avatarView addGestureRecognizer:tap];
    }
    
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar]] placeholderImage:[UIImage imageNamed:@"bq_img_head"]];
    
    if (!self.nameBtn) {
        self.nameBtn = [[UIButton alloc]init];
        [self addSubview:self.nameBtn];
        [self.nameBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
        [self.nameBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    [self.nameBtn setTitle:user.nickname forState:UIControlStateNormal];
    NSDictionary *nameAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.nameBtn.frame = CGRectMake(self.avatarView.frame.origin.x + self.avatarView.frame.size.width + 10, 17, [user.nickname sizeWithAttributes:nameAttrs].width + user.inteval / 3, [user.nickname sizeWithAttributes:nameAttrs].height);
    
//    if (!self.vipRangeView) {
//        self.vipRangeView = [[UIImageView alloc]init];
//        [self addSubview:self.vipRangeView];
//    }
//    [self.vipRangeView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:user.level]];
//    self.vipRangeView.frame = CGRectMake(self.nameBtn.frame.origin.x + self.nameBtn.frame.size.width + 3, 16, 16, 12);
    
    if (!intevalLabel) {
        intevalLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameBtn.frame.origin.x + self.nameBtn.frame.size.width, self.nameBtn.frame.origin.y, 20, self.nameBtn.frame.size.height)];
        [intevalLabel setText:@"|"];
        [intevalLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"dddddd"]];
        [intevalLabel setFont:[UIFont systemFontOfSize:14]];
        intevalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:intevalLabel];
    }
    [intevalLabel setFrame:CGRectMake(self.nameBtn.frame.origin.x + self.nameBtn.frame.size.width, self.nameBtn.frame.origin.y, 20, self.nameBtn.frame.size.height)];
    
    if (!self.companyPositionLabel) {
        self.companyPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(intevalLabel.frame.origin.x + intevalLabel.frame.size.width, self.nameBtn.frame.origin.y, 20, self.nameBtn.frame.size.height)];
        self.companyPositionLabel.textAlignment = NSTextAlignmentLeft;
        [self.companyPositionLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.companyPositionLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.companyPositionLabel];
    }
    NSString *comStr;
    if (user.company) {
        if (user.company.length > 4) {
            comStr = [user.company substringToIndex:4];
        }else{
            comStr = user.company;
        }
    }
    if (user.job) {
        if (user.job.length > 10) {
            if (comStr) {
                comStr = [comStr stringByAppendingString:[user.job substringToIndex:10]];
            }else{
                comStr = [user.job substringToIndex:10];
            }
        }else{
            if (comStr) {
                comStr = [comStr stringByAppendingString:user.job];
            }else{
                comStr = user.job;
            }
        }
    }
    if (!comStr || comStr.length == 0 || [comStr isEqualToString:@""]) {
        self.companyPositionLabel.hidden = YES;
        intevalLabel.hidden = YES;
    }else{
        self.companyPositionLabel.hidden = NO;
        intevalLabel.hidden = NO;
    }
    [self.companyPositionLabel setText:comStr];
    [self.companyPositionLabel setFrame:CGRectMake(intevalLabel.frame.origin.x + intevalLabel.frame.size.width, self.nameBtn.frame.origin.y, [self.companyPositionLabel.text sizeWithAttributes:nameAttrs].width + 3, self.nameBtn.frame.size.height)];
    
    if (self.isCaina) {
        if (!self.cainaView) {
            self.cainaView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 44, 0, 44, 44)];
            [self.cainaView setImage:[UIImage imageNamed:@"WD_CN"]];
            [self addSubview:self.cainaView];
        }
        self.cainaView.hidden = NO;
    }else{
        self.cainaView.hidden = YES;
    }
    
    if (!self.delBtn) {
        self.delBtn = [[UIButton alloc]initWithFrame:CGRectMake(GLScreenW - 10 - 44, 0, 44, 44)];
        [self.delBtn setImage:[UIImage imageNamed:@"WD_delete"] forState:UIControlStateNormal];
        [self addSubview:self.delBtn];
    }
    
//    if (self.isEmergence) {
//        if (!self.emergenceView) {
//            self.emergenceView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 25 - 17, (44 - 25) / 2, 25, 25)];
//            [self.emergenceView setImage:[UIImage imageNamed:@"WD_urgent"]];
//            [self addSubview:self.emergenceView];
//        }
//        self.emergenceView.hidden = NO;
//    }else{
//        self.emergenceView.hidden = YES;
//    }

    
    
//    if (!intevalView) {
//        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
//        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
//        [self addSubview:intevalView];
//        self.botView = intevalView;
//    }
}

+(SimpleInfoView *) getInfoShowViewWithData:(GetValueObject *) obj WithFrame:(CGRect) frame{
    
    SimpleInfoView *view = [[SimpleInfoView alloc]initWithFrame:frame WithData:obj];
    
    return view;
}

- (void) avtarTap{
    if (self.returnAction) {
        self.returnAction(0);
    }
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

@end
