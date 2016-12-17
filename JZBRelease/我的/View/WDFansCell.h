//
//  WDFansCell.h
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MySaleList.h"

@interface WDFansCell : UITableViewCell

/** isReferrer */
@property (nonatomic, assign) BOOL isReferrer;

/** item */
@property (nonatomic, strong) Users *item;

/** MySaleList */
@property (nonatomic, strong) MySaleList *model;

@end
