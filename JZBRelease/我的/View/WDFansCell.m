//
//  WDFansCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "WDFansCell.h"
#import "InfoShowView.h"

@interface WDFansCell ()

@property (nonatomic, weak) InfoShowView *infoView;

@end

@implementation WDFansCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
        self.infoView = infoView;
        
        [self addSubview:infoView];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultTableView"];
    if (self) {
        
        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
        self.infoView = infoView;
        
        [self addSubview:infoView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
    self.infoView = infoView;
    
    [self addSubview:infoView];
    
}

-(void)setIsReferrer:(BOOL)isReferrer
{
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    tipButton1.layer.cornerRadius = 5;
    tipButton1.layer.borderWidth = 1;
    tipButton1.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"757575"].CGColor;
    tipButton1.clipsToBounds = YES;
    
    [tipButton1 setTitle:@"审核" forState:UIControlStateNormal];
    
    [self addSubview:tipButton1];
    
    tipButton1.frame = CGRectMake(GLScreenW - 66, 64/2 - 22/2, 44, 22);

    [tipButton1 setFont:[UIFont systemFontOfSize:14]];
    
    [tipButton1 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
    
    tipButton1.userInteractionEnabled = NO;
//    @"通过",@"拒绝",@"返回"
    if ([self.model.status isEqualToString:@"0"]) {
        [tipButton1 setTitle:@"审核" forState:UIControlStateNormal];
    }else if ([self.model.status isEqualToString:@"1"]) {
        [tipButton1 setTitle:@"已通过" forState:UIControlStateNormal];
    }else if ([self.model.status isEqualToString:@"2"]) {
        [tipButton1 setTitle:@"已拒绝" forState:UIControlStateNormal];
    }
    
    [tipButton1 sizeToFit];
    
}

- (void)setItem:(Users *)item
{
    _item = item;
    
    [self.infoView updateFrameWithData:item];
    
    self.infoView.botView.hidden = YES;
}

- (void)setModel:(MySaleList *)model
{

    _model = model;
    [self.infoView updateFrameWithData:model.user];
    
    self.infoView.botView.hidden = YES;
}

@end
