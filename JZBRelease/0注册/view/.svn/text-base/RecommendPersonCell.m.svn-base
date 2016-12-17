//
//  RecommendPersonCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RecommendPersonCell.h"
#import "InfoShowView.h"

@interface RecommendPersonCell ()

@property (nonatomic, weak) InfoShowView *infoView;

@end

@implementation RecommendPersonCell

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

- (void)setItem:(RecommendPersonItem *)item
{
    _item = item;
    
    [self.infoView updateFrameWithData:item];
    
    self.infoView.botView.hidden = YES;
}



@end
