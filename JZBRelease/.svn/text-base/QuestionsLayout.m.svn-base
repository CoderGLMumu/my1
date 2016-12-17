//
//  QuestionsLayout.m
//  JZBRelease
//
//  Created by cl z on 16/7/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "QuestionsLayout.h"
#import "DealNormalUtil.h"
#import "LWConstraintManager.h"
#import "QuestionEvaluateModel.h"
@implementation QuestionsLayout

- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(QuestionsModel *)questionsModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
               IsDetail:(BOOL)isDetail
                 IsLast:(BOOL)isLast{
    self = [super initWithContainer:container];
    if (self) {
        /****************************生成Storage 相当于模型*************************************/
        /*********LWAsyncDisplayView用将所有文本跟图片的模型都抽象成LWStorage，方便你能预先将所有的需要计算的布局内容直接缓存起来***/
        /*******而不是在渲染的时候才进行计算*******************************************/
        self.questionsModel = questionsModel;
        LWTextStorage* titleTextStorage1;
        LWTextStorage* titleTextStorage0;
        if ([questionsModel.reward_score integerValue] == 0) {
            if ([questionsModel.type integerValue] != 1) {
                titleTextStorage0 = [[LWTextStorage alloc] init];
                titleTextStorage0.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                titleTextStorage0.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                titleTextStorage0.linespace = 1.0f;
                NSDictionary *titleTextAttrs = @{NSFontAttributeName:titleTextStorage0.font};
                NSString *singleStr = [questionsModel.title substringToIndex:1];
                BOOL isChinese = NO;
                int single = [singleStr characterAtIndex:0];
                if( single > 0x4e00 && single < 0x9fff)
                {
                    isChinese = YES;
                }
                int singleWidth = [singleStr sizeWithAttributes:titleTextAttrs].width;
                int count = (SCREEN_WIDTH - 50) / singleWidth;
                if (questionsModel.title.length > count) {
                    NSString *sub = [questionsModel.title substringToIndex:count];
                    titleTextStorage0.text = sub;
                    if (isChinese) {
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, SCREEN_WIDTH  - 50, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }else{
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, SCREEN_WIDTH - 50, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }
                    
                    [container addStorage:titleTextStorage0];
                    
                    titleTextStorage1 = [[LWTextStorage alloc] init];
                    titleTextStorage1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                    titleTextStorage1.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                    titleTextStorage1.linespace = 1.0f;
                    NSString *remind = [questionsModel.title substringFromIndex:count];
                    titleTextStorage1.text = remind;
                    [titleTextStorage1 setFrame:CGRectMake(10, titleTextStorage0.bottom + 4, SCREEN_WIDTH -  20, [titleTextStorage1.text sizeWithAttributes:titleTextAttrs].height)];
                    [container addStorage:titleTextStorage1];
                }else{
                    titleTextStorage0.text = questionsModel.title;
                    if (isChinese) {
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, SCREEN_WIDTH - 50, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }else{
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, SCREEN_WIDTH - 50, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }
                    [container addStorage:titleTextStorage0];
                }
                
                LWImageStorage *typeImageStorage = [[LWImageStorage alloc]init];
                typeImageStorage.type = LWImageStorageLocalImage;
                typeImageStorage.image = [UIImage imageNamed:@"BB_J"];
                [typeImageStorage setFrame:CGRectMake(SCREEN_WIDTH - 30, 21, 20, 20)];
                [container addStorage:typeImageStorage];
            }else{
                titleTextStorage0 = [[LWTextStorage alloc] init];
                titleTextStorage0.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                titleTextStorage0.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                titleTextStorage0.linespace = 1.0f;
                NSDictionary *titleTextAttrs = @{NSFontAttributeName:titleTextStorage0.font};
                titleTextStorage0.text = questionsModel.title;
                NSString *singleStr = [questionsModel.title substringToIndex:1];
                BOOL isChinese = NO;
                int single = [singleStr characterAtIndex:0];
                if( single > 0x4e00 && single < 0x9fff)
                {
                    isChinese = YES;
                }
                if (isChinese) {
                    [titleTextStorage0 setFrame:CGRectMake(10, 19, SCREEN_WIDTH  - 20, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                }else{
                    [titleTextStorage0 setFrame:CGRectMake(10, 19, SCREEN_WIDTH - 20, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                }
                [container addStorage:titleTextStorage0];
            }
            
        }else{
            if ([questionsModel.type integerValue] != 1) {
                
                LWTextStorage* xuanShangValueTextStorage = [[LWTextStorage alloc] init];
                xuanShangValueTextStorage.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                xuanShangValueTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9901"];
                xuanShangValueTextStorage.linespace = 1.0f;
                xuanShangValueTextStorage.text = questionsModel.reward_score;
                NSDictionary *xuanShangValueAttrs = @{NSFontAttributeName:xuanShangValueTextStorage.font};
                [xuanShangValueTextStorage setFrame:CGRectMake(SCREEN_WIDTH - 10 - [xuanShangValueTextStorage.text sizeWithAttributes:xuanShangValueAttrs].width - 2, 21, [xuanShangValueTextStorage.text sizeWithAttributes:xuanShangValueAttrs].width + 2, [xuanShangValueTextStorage.text sizeWithAttributes:xuanShangValueAttrs].height)];
                [container addStorage:xuanShangValueTextStorage];
                
                LWImageStorage *xuanShangImageStorage = [[LWImageStorage alloc]init];
                xuanShangImageStorage.type = LWImageStorageLocalImage;
                xuanShangImageStorage.image = [UIImage imageNamed:@"BB_XS"];
                [xuanShangImageStorage setFrame:CGRectMake(xuanShangValueTextStorage.frame.origin.x - 7 - 20, 21, 20, 20)];
                [container addStorage:xuanShangImageStorage];
                
                LWImageStorage *typeImageStorage = [[LWImageStorage alloc]init];
                typeImageStorage.type = LWImageStorageLocalImage;
                typeImageStorage.image = [UIImage imageNamed:@"BB_J"];
                [typeImageStorage setFrame:CGRectMake(xuanShangImageStorage.frame.origin.x - 5 - 20, 21, 20, 20)];
                [container addStorage:typeImageStorage];
                
                
                titleTextStorage0 = [[LWTextStorage alloc] init];
                titleTextStorage0.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                titleTextStorage0.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                titleTextStorage0.linespace = 1.0f;
                NSDictionary *titleTextAttrs = @{NSFontAttributeName:titleTextStorage0.font};
                NSString *singleStr = [questionsModel.title substringToIndex:1];
                BOOL isChinese = NO;
                int single = [singleStr characterAtIndex:0];
                if( single > 0x4e00 && single < 0x9fff)
                {
                    isChinese = YES;
                }
                int singleWidth = [singleStr sizeWithAttributes:titleTextAttrs].width;
                int count = (typeImageStorage.left - 18) / singleWidth;
                if (questionsModel.title.length > count) {
                    NSString *sub = [questionsModel.title substringToIndex:count];
                    titleTextStorage0.text = sub;
                    if (isChinese) {
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, typeImageStorage.frame.origin.x - 18 , [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }else{
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, typeImageStorage.frame.origin.x - 18 , [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }
                    [container addStorage:titleTextStorage0];
                    
                    titleTextStorage1 = [[LWTextStorage alloc] init];
                    titleTextStorage1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                    titleTextStorage1.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                    titleTextStorage1.linespace = 1.0f;
                    NSString *remind = [questionsModel.title substringFromIndex:count];
                    titleTextStorage1.text = remind;
                    [titleTextStorage1 setFrame:CGRectMake(10, titleTextStorage0.bottom + 4, SCREEN_WIDTH - 20, [titleTextStorage1.text sizeWithAttributes:titleTextAttrs].height)];
                    [container addStorage:titleTextStorage1];
                }else{
                    titleTextStorage0.text = questionsModel.title;
                    if (isChinese) {
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, typeImageStorage.frame.origin.x - 18, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }else{
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, typeImageStorage.frame.origin.x - 18, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }
                    
                    [container addStorage:titleTextStorage0];
                }
                
                
            }else{
                LWTextStorage* xuanShangValueTextStorage = [[LWTextStorage alloc] init];
                xuanShangValueTextStorage.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                xuanShangValueTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9901"];
                xuanShangValueTextStorage.linespace = 1.0f;
                xuanShangValueTextStorage.text = questionsModel.reward_score;
                NSDictionary *xuanShangValueAttrs = @{NSFontAttributeName:xuanShangValueTextStorage.font};
                [xuanShangValueTextStorage setFrame:CGRectMake(SCREEN_WIDTH - 10 - [xuanShangValueTextStorage.text sizeWithAttributes:xuanShangValueAttrs].width - 2, 21, [xuanShangValueTextStorage.text sizeWithAttributes:xuanShangValueAttrs].width + 2, [xuanShangValueTextStorage.text sizeWithAttributes:xuanShangValueAttrs].height)];
                [container addStorage:xuanShangValueTextStorage];
                
                LWImageStorage *xuanShangImageStorage = [[LWImageStorage alloc]init];
                xuanShangImageStorage.type = LWImageStorageLocalImage;
                xuanShangImageStorage.image = [UIImage imageNamed:@"BB_XS"];
                [xuanShangImageStorage setFrame:CGRectMake(xuanShangValueTextStorage.frame.origin.x - 7 - 20, 21, 20, 20)];
                [container addStorage:xuanShangImageStorage];
                
                
                titleTextStorage0 = [[LWTextStorage alloc] init];
                titleTextStorage0.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                titleTextStorage0.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                titleTextStorage0.linespace = 1.0f;
                NSDictionary *titleTextAttrs = @{NSFontAttributeName:titleTextStorage0.font};
                if (questionsModel.title.length < 1) return nil;
                NSString *singleStr = [questionsModel.title substringToIndex:1];
                BOOL isChinese = NO;
                int single = [singleStr characterAtIndex:0];
                if( single > 0x4e00 && single < 0x9fff)
                {
                    isChinese = YES;
                }
                int singleWidth = [singleStr sizeWithAttributes:titleTextAttrs].width;
                int count = (xuanShangImageStorage.frame.origin.x - 16) / singleWidth;
                if (questionsModel.title.length > count) {
                    NSString *sub = [questionsModel.title substringToIndex:count];
                    titleTextStorage0.text = sub;
                    if (isChinese) {
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, xuanShangImageStorage.frame.origin.x - 16, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }else{
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, xuanShangImageStorage.frame.origin.x - 16, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }

                    
                    [container addStorage:titleTextStorage0];
                    
                    titleTextStorage1 = [[LWTextStorage alloc] init];
                    titleTextStorage1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                    titleTextStorage1.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                    titleTextStorage1.linespace = 1.0f;
                    NSString *remind = [questionsModel.title substringFromIndex:count];
                    titleTextStorage1.text = remind;
                    [titleTextStorage1 setFrame:CGRectMake(10, titleTextStorage0.bottom + 4, SCREEN_WIDTH - 20, [titleTextStorage1.text sizeWithAttributes:titleTextAttrs].height)];
                    [container addStorage:titleTextStorage1];
                }else{
                    titleTextStorage0.text = questionsModel.title;
                    if (isChinese) {
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, xuanShangImageStorage.frame.origin.x - 16, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }else{
                        [titleTextStorage0 setFrame:CGRectMake(10, 19, xuanShangImageStorage.frame.origin.x - 16, [titleTextStorage0.text sizeWithAttributes:titleTextAttrs].height)];
                    }
                    
                    [container addStorage:titleTextStorage0];
                }
            }
        }
        
        LWTextStorage *questionFromStorage = [[LWTextStorage alloc]init];
        questionFromStorage.font = [UIFont systemFontOfSize:14];
        questionFromStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"2197f4"];
        questionFromStorage.linespace = 1.0f;
        questionFromStorage.text = @"话题来自：";
        NSDictionary *quesAttr = @{NSFontAttributeName:questionFromStorage.font};
        if (titleTextStorage1) {
            questionFromStorage.frame = CGRectMake(titleTextStorage0.left, titleTextStorage1.bottom + 14, [questionFromStorage.text sizeWithAttributes:quesAttr].width, [questionFromStorage.text sizeWithAttributes:quesAttr].height);
        }else{
            questionFromStorage.frame = CGRectMake(titleTextStorage0.left, titleTextStorage0.bottom + 14, [questionFromStorage.text sizeWithAttributes:quesAttr].width, [questionFromStorage.text sizeWithAttributes:quesAttr].height);
        }
        [container addStorage:questionFromStorage];
        
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] init];
        avatarStorage.type = LWImageStorageWebImage;
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:questionsModel.user.avatar]]]];
        if (!image) {
            image = [UIImage imageNamed:@"bq_img_head"];
        }
        [avatarStorage setImage:image];
        avatarStorage.cornerRadius = 20.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.fadeShow = YES;
        avatarStorage.masksToBounds = NO;
        [avatarStorage setFrame:CGRectMake(questionFromStorage.right, questionFromStorage.top - 4, 25, 25)];
        self.avatarPosition1 = avatarStorage.frame;
        [container addStorage:avatarStorage];
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = questionsModel.user.nickname;
        nameTextStorage.font = [UIFont systemFontOfSize:14];
        nameTextStorage.textAlignment = NSTextAlignmentLeft;
        nameTextStorage.linespace = 2.0f;
        nameTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        NSDictionary *nameAttrs = @{NSFontAttributeName:nameTextStorage.font};
        [nameTextStorage setFrame:CGRectMake(avatarStorage.right + 8, questionFromStorage.top, [nameTextStorage.text sizeWithAttributes:nameAttrs].width + 2, [nameTextStorage.text sizeWithAttributes:nameAttrs].height)];
        [container addStorage:nameTextStorage];
        [nameTextStorage addLinkWithData:[NSString stringWithFormat:@"%@",nameTextStorage.text]
                                                 inRange:NSMakeRange(0,nameTextStorage.text.length)
                                               linkColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]
                                          highLightColor:RGB(0, 0, 0, 0.15)
                                          UnderLineStyle:NSUnderlineStyleNone];
        nameTextStorage.clink_type = Clink_Type_Four;

        LWTextStorage* intevalTextStorage0 = [[LWTextStorage alloc] init];
        intevalTextStorage0.font = [UIFont systemFontOfSize:14];
        intevalTextStorage0.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        intevalTextStorage0.linespace = 1.0f;
        intevalTextStorage0.textAlignment = NSTextAlignmentCenter;
        intevalTextStorage0.text = @"|";
        [intevalTextStorage0 setFrame:CGRectMake(nameTextStorage.right , questionFromStorage.top + 1, 20, [intevalTextStorage0.text sizeWithAttributes:nameAttrs].height)];
        
        
        LWTextStorage* companyTextStorage = [[LWTextStorage alloc] init];
        companyTextStorage.font = [UIFont systemFontOfSize:14];
        companyTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        companyTextStorage.linespace = 1.0f;
        companyTextStorage.textAlignment = NSTextAlignmentLeft;
        NSString *comStr;
        if (questionsModel.user.company) {
            if (questionsModel.user.company.length > 4) {
                comStr = [questionsModel.user.company substringToIndex:4];
            }else{
                comStr = questionsModel.user.company;
            }
        }
        if (questionsModel.user.job) {
            if (questionsModel.user.job.length > 10) {
                if (comStr) {
                    comStr = [comStr stringByAppendingString:[questionsModel.user.job substringToIndex:10]];
                }else{
                    comStr = [questionsModel.user.job substringToIndex:10];
                }
            }else{
                if (comStr) {
                    comStr = [comStr stringByAppendingString:questionsModel.user.job];
                }else{
                    comStr = questionsModel.user.job;
                }
            }
        }
        if (!comStr || comStr.length == 0 || [comStr isEqualToString:@""]) {
            
        }else{
            companyTextStorage.text = comStr;
            [companyTextStorage setFrame:CGRectMake(intevalTextStorage0.right , questionFromStorage.top, [companyTextStorage.text sizeWithAttributes:nameAttrs].width + 5, [companyTextStorage.text sizeWithAttributes:nameAttrs].height)];
            
            [container addStorage:intevalTextStorage0];
            [container addStorage:companyTextStorage];
        }
        
        
        
        //描述模型
        LWTextStorage* descriptionTextStorage;
        if (questionsModel.desc && questionsModel.desc.length > 0) {
            descriptionTextStorage = [[LWTextStorage alloc] init];
            descriptionTextStorage.font = [UIFont systemFontOfSize:15];
            NSString *desStr;
            NSDictionary *descriptionTextAttrs = @{NSFontAttributeName:descriptionTextStorage.font};
            NSString *singleStr = [questionsModel.desc substringToIndex:1];
            if (!isDetail) {
                BOOL isChinese = NO;
                int single = [singleStr characterAtIndex:0];
                if( single > 0x4e00 && single < 0x9fff)
                {
                    isChinese = YES;
                }
                int singleWidth = [singleStr sizeWithAttributes:descriptionTextAttrs].width;
                int count = (SCREEN_WIDTH - 20) / singleWidth;
                if (questionsModel.desc.length > count * 2) {
                    desStr = [[questionsModel.desc substringToIndex:count * 2 - 5] stringByAppendingString:@"..."];
                }else{
                    desStr = questionsModel.desc;
                }

            }else{
                desStr = questionsModel.content;
            }
            descriptionTextStorage.text = desStr;
            descriptionTextStorage.textAlignment = NSTextAlignmentLeft;
            descriptionTextStorage.linespace = 4.0f;
            descriptionTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
            [LWConstraintManager lw_makeConstraint:descriptionTextStorage.constraint.topMargin(questionFromStorage.bottom + 14).leftMargin(questionFromStorage.left).rightMargin(10)];
            [container addStorage:descriptionTextStorage];
        }
        
        NSMutableArray* imageStorageArray = [[NSMutableArray alloc] init];
        NSMutableArray* imagePositionArray = [[NSMutableArray alloc] init];
        if (isDetail) {
            int width = (SCREEN_WIDTH - 30) / 3;
            NSString *absolutePath = [ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort];
            for (NSInteger i = 0; i < questionsModel.images.count; i ++) {
                
                LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
                /***********************************/
                
                NSString* URLString = [absolutePath stringByAppendingPathComponent:[questionsModel.images objectAtIndex:i]];
                
                //imageStorage.URL = [NSURL URLWithString:URLString];
                //dispatch_async(dispatch_queue_create("", nil), ^{
                UIImage *image = [LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:URLString];
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                
                //});
                //});
                CGRect imageRect;
                if (questionsModel.images.count == 1) {
                    if (descriptionTextStorage) {
                        imageRect = CGRectMake(questionFromStorage.left, descriptionTextStorage.bottom + 15, width, width * image.size.height / image.size.width);
                    }else{
                        imageRect = CGRectMake(questionFromStorage.left, questionFromStorage.bottom + 15, width, width * image.size.height / image.size.width);
                    }
                    
                    imageStorage.frame = imageRect;
                }else{
                    if (descriptionTextStorage) {
                        imageRect = CGRectMake(questionFromStorage.left + i * (width + 5), descriptionTextStorage.bottom + 15, width, width);
                    }else{
                        imageRect = CGRectMake(questionFromStorage.left + i * (width + 5), questionFromStorage.bottom + 15, width, width);
                    }
                    
                    imageStorage.frame = imageRect;
                    image = [ZJBHelp handleImage:image withSize:imageStorage.frame.size withFromStudy:NO];
                }
                
                [imageStorage setImage:image];
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                /***************** 也可以不使用设置约束的方式来布局，而是直接设置frame属性的方式来布局*************************************/
                imageStorage.type = LWImageStorageLocalImage;
                imageStorage.fadeShow = YES;
                imageStorage.masksToBounds = YES;
                imageStorage.contentMode = kCAGravityResizeAspect;
                
                [imageStorageArray addObject:imageStorage];
            }
            if (imageStorageArray.count > 0) {
                self.imageAry = imageStorageArray;
                [container addStorages:imageStorageArray];
                self.imagePostionArray = imagePositionArray;
            }

        }
        
//        LWImageStorage *adressImageStorage;
//        if (questionsModel.address && questionsModel.address.length > 0) {
//            adressImageStorage = [[LWImageStorage alloc]init];
//            adressImageStorage.type = LWImageStorageLocalImage;
//            adressImageStorage.image = [UIImage imageNamed:@"WD_location"];
//            if (imageStorageArray.count > 0) {
//                LWImageStorage *first = [imageStorageArray objectAtIndex:0];
//                [adressImageStorage setFrame:CGRectMake(13, 15 + first.bottom, 14, 14)];
//            }else{
//                if (titleTextStorage1) {
//                    [adressImageStorage setFrame:CGRectMake(13, 14 + titleTextStorage1.bottom, 14, 14)];
//                }else{
//                    [adressImageStorage setFrame:CGRectMake(13, 14 + titleTextStorage0.bottom, 14, 14)];
//                }
//            }
//            
//            [container addStorage:adressImageStorage];
//            
//            LWTextStorage* adressTextStorage0 = [[LWTextStorage alloc] init];
//            adressTextStorage0.font = [UIFont systemFontOfSize:12];
//            adressTextStorage0.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
//            adressTextStorage0.linespace = 1.0f;
//            NSDictionary *adressTextAttrs = @{NSFontAttributeName:adressTextStorage0.font};
//            adressTextStorage0.text = questionsModel.address;
//            [adressTextStorage0 setFrame:CGRectMake(adressImageStorage.right + 8, adressImageStorage.top, [adressTextStorage0.text sizeWithAttributes:adressTextAttrs].width, [adressTextStorage0.text sizeWithAttributes:adressTextAttrs].width)];
//            [container addStorage:adressTextStorage0];
//            adressTextStorage0.clink_type = Clink_Type_Two;
//            [adressTextStorage0 addLinkWithData:[NSString stringWithFormat:@"%@",adressTextStorage0.text]
//                                        inRange:NSMakeRange(0,adressTextStorage0.text.length)
//                                      linkColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]
//                                 highLightColor:RGB(0, 0, 0, 0.15)
//                                 UnderLineStyle:NSUnderlineStyleNone];
//            
//            LWTextStorage* intevalTextStorage = [[LWTextStorage alloc] init];
//            intevalTextStorage.font = [UIFont systemFontOfSize:12];
//            intevalTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
//            intevalTextStorage.linespace = 1.0f;
//            intevalTextStorage.textAlignment = NSTextAlignmentCenter;
//            intevalTextStorage.text = @"|";
//            [intevalTextStorage setFrame:CGRectMake(adressTextStorage0.right , adressImageStorage.top + 1, 20, [adressTextStorage0.text sizeWithAttributes:adressTextAttrs].height)];
//            [container addStorage:intevalTextStorage];
//            
//            LWTextStorage* offlineTextStorage = [[LWTextStorage alloc] init];
//            offlineTextStorage.font = [UIFont systemFontOfSize:12];
//            offlineTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"fd7943"];
//            offlineTextStorage.linespace = 1.0f;
//            offlineTextStorage.textAlignment = NSTextAlignmentLeft;
//            offlineTextStorage.text = @"线下";
//            [offlineTextStorage setFrame:CGRectMake(intevalTextStorage.right , adressImageStorage.top, 60, [adressTextStorage0.text sizeWithAttributes:adressTextAttrs].width)];
//            [container addStorage:offlineTextStorage];
//            
//            offlineTextStorage.clink_type = Clink_Type_Two;
//            [offlineTextStorage addLinkWithData:[NSString stringWithFormat:@"%@",offlineTextStorage.text]
//                                      inRange:NSMakeRange(0,offlineTextStorage.text.length)
//                                    linkColor:[UIColor hx_colorWithHexRGBAString:@"fd7943"]
//                               highLightColor:RGB(0, 0, 0, 0.15)
//                               UnderLineStyle:NSUnderlineStyleNone];
//        }
        
        LWImageStorage *industryImageStorage = [[LWImageStorage alloc]init];
        industryImageStorage.type = LWImageStorageLocalImage;
        industryImageStorage.image = [UIImage imageNamed:@"WDXQ_BQ"];
        
        if (imageStorageArray.count > 0) {
            LWImageStorage *first = [imageStorageArray objectAtIndex:0];
            [industryImageStorage setFrame:CGRectMake(13, 15 + first.bottom, 14, 14)];
        }else{
            if (descriptionTextStorage) {
                [industryImageStorage setFrame:CGRectMake(13, 15 + descriptionTextStorage.bottom, 12, 12)];
            }else{
                [industryImageStorage setFrame:CGRectMake(13, 15 + questionFromStorage.bottom, 12, 12)];
            }
        }
        
        [container addStorage:industryImageStorage];
        
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        industryTextStorage.font = [UIFont systemFontOfSize:11];
        industryTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        industryTextStorage.linespace = 1.0f;
        NSDictionary *industryTextAttrs = @{NSFontAttributeName:industryTextStorage.font};
        if (!questionsModel.tag || questionsModel.tag.length == 0) {
            industryTextStorage.text = @"建材";
        }
        industryTextStorage.text = questionsModel.tag;
        [industryTextStorage setFrame:CGRectMake(industryImageStorage.right + 8, industryImageStorage.top - 1, [industryTextStorage.text sizeWithAttributes:industryTextAttrs].width, [industryTextStorage.text sizeWithAttributes:industryTextAttrs].width)];
        [container addStorage:industryTextStorage];
        
        LWTextStorage* intevalDateTextStorage = [[LWTextStorage alloc] init];
        intevalDateTextStorage.font = [UIFont systemFontOfSize:11];
        intevalDateTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"dddddd"];
        intevalDateTextStorage.linespace = 1.0f;
        intevalDateTextStorage.textAlignment = NSTextAlignmentCenter;
        intevalDateTextStorage.text = @"|";
        [intevalDateTextStorage setFrame:CGRectMake(industryTextStorage.right , industryTextStorage.top + 1, 20, [industryTextStorage.text sizeWithAttributes:industryTextAttrs].height)];
        [container addStorage:intevalDateTextStorage];
        
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.font = [UIFont systemFontOfSize:11];
        dateTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        dateTextStorage.linespace = 1.0f;
        long long int date1 = (long long int)[questionsModel.create_time intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        dateTextStorage.text = [[questionsModel class] compareCurrentTime:date2];
        [dateTextStorage setFrame:CGRectMake(intevalDateTextStorage.right , industryTextStorage.top, 160, [industryTextStorage.text sizeWithAttributes:industryTextAttrs].width)];
        [container addStorage:dateTextStorage];

        UIImage *intevalImage = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"] WithFrame:CGRectMake(0, 0, 10, 1)];
        UIImage *intevalImage1 = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"] WithFrame:CGRectMake(0, 0, 10, 1)];
        
        
        
        
        
        
//        LWImageStorage *intevalStorage0;
//        intevalStorage0 = [[LWImageStorage alloc]init];
//        intevalStorage0.type = LWImageStorageLocalImage;
//        intevalStorage0.image = intevalImage1;
//        intevalStorage0.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
//        [container addStorage:intevalStorage0];
        
        
        if (!isDetail) {
//            LWImageStorage *readedStorage = [[LWImageStorage alloc]init];
//            readedStorage.type = LWImageStorageLocalImage;
//            readedStorage.image = [UIImage imageNamed:@"BB_eye"];
//            readedStorage.frame = CGRectMake(10, industryImageStorage.bottom + (44 - 20) / 2, 20, 16);
//            [container addStorage:readedStorage];
//            
//            LWTextStorage* readedCountTextStorage = [[LWTextStorage alloc] init];
//            readedCountTextStorage.font = [UIFont systemFontOfSize:12];
//            readedCountTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//            readedCountTextStorage.linespace = 1.0f;
//            readedCountTextStorage.textAlignment = NSTextAlignmentCenter;
//            NSString *readedCount;
//            if (questionsModel.show_count) {
//                readedCount = questionsModel.show_count;
//            }else{
//                readedCount = @"0";
//            }
//            readedCountTextStorage.text = readedCount;
//            NSDictionary *readedCountAttrs = @{NSFontAttributeName:readedCountTextStorage.font};
//            [readedCountTextStorage setFrame:CGRectMake(readedStorage.right + 8, industryImageStorage.bottom + (44 - [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].height) / 2, [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].width, [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].height)];
//            [container addStorage:readedCountTextStorage];
//            
////            LWTextStorage* intevalReadTextStorage = [[LWTextStorage alloc] init];
////            intevalReadTextStorage.font = [UIFont systemFontOfSize:12];
////            intevalReadTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"dddddd"];
////            intevalReadTextStorage.linespace = 1.0f;
////            intevalReadTextStorage.textAlignment = NSTextAlignmentCenter;
////            intevalReadTextStorage.text = @"|";
////            [intevalReadTextStorage setFrame:CGRectMake(readedCountTextStorage.right, industryImageStorage.bottom + (44 - [intevalReadTextStorage.text sizeWithAttributes:industryTextAttrs].height) / 2, 30, [intevalReadTextStorage.text sizeWithAttributes:industryTextAttrs].height)];
////            [container addStorage:intevalReadTextStorage];
//            
//            
//            LWImageStorage *collectedStorage = [[LWImageStorage alloc]init];
//            collectedStorage.type = LWImageStorageLocalImage;
//            collectedStorage.image = [UIImage imageNamed:@"BB_star"];
//            collectedStorage.frame = CGRectMake(readedCountTextStorage.right + 16, industryImageStorage.bottom + (44 - 20) / 2, 20, 16);
//            [container addStorage:collectedStorage];
//            
//            LWTextStorage* collectedCountTextStorage = [[LWTextStorage alloc] init];
//            collectedCountTextStorage.font = [UIFont systemFontOfSize:12];
//            collectedCountTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//            collectedCountTextStorage.linespace = 1.0f;
//            collectedCountTextStorage.textAlignment = NSTextAlignmentCenter;
//            NSString *collectedCount;
//            if (questionsModel.evaluation_count) {
//                collectedCount = questionsModel.like_count;
//            }else{
//                collectedCount = @"0";
//            }
//            collectedCountTextStorage.text = collectedCount;
//            NSDictionary *collectCountAttrs = @{NSFontAttributeName:collectedCountTextStorage.font};
//            [collectedCountTextStorage setFrame:CGRectMake(collectedStorage.right + 8 , industryImageStorage.bottom + (44 - [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].height) / 2, [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].width, [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].height)];
//            [container addStorage:collectedCountTextStorage];
//            
////            LWTextStorage* intevalWriteTextStorage = [[LWTextStorage alloc] init];
////            intevalWriteTextStorage.font = [UIFont systemFontOfSize:12];
////            intevalWriteTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"dddddd"];
////            intevalWriteTextStorage.linespace = 1.0f;
////            intevalWriteTextStorage.textAlignment = NSTextAlignmentCenter;
////            intevalWriteTextStorage.text = @"|";
////            [intevalWriteTextStorage setFrame:CGRectMake(collectedCountTextStorage.right, industryImageStorage.bottom + (44 - [intevalReadTextStorage.text sizeWithAttributes:industryTextAttrs].height) / 2, 30, [intevalReadTextStorage.text sizeWithAttributes:industryTextAttrs].height)];
////            [container addStorage:intevalWriteTextStorage];
//            
//            LWImageStorage *commentStorage = [[LWImageStorage alloc]init];
//            commentStorage.type = LWImageStorageLocalImage;
//            commentStorage.image = [UIImage imageNamed:@"BR_PL"];
//            commentStorage.frame = CGRectMake(collectedCountTextStorage.right + 16, industryImageStorage.bottom + (44 - 20) / 2 + 2, 20, 16);
//            [container addStorage:commentStorage];
//            
//            LWTextStorage* commentCoutTextStorage = [[LWTextStorage alloc] init];
//            commentCoutTextStorage.font = [UIFont systemFontOfSize:12];
//            commentCoutTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//            commentCoutTextStorage.linespace = 1.0f;
//            commentCoutTextStorage.textAlignment = NSTextAlignmentCenter;
//            NSString *commentCount;
//            if (questionsModel.evaluation_count) {
//                commentCount = questionsModel.evaluation_count;
//            }else{
//                commentCount = @"0";
//            }
//            commentCoutTextStorage.text = commentCount;
//            NSDictionary *commentCoutAttrs = @{NSFontAttributeName:commentCoutTextStorage.font};
//            [commentCoutTextStorage setFrame:CGRectMake(commentStorage.right + 8, industryImageStorage.bottom + (44 - [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].height) / 2, [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].width, [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].height)];
//            [container addStorage:commentCoutTextStorage];
//            LWImageStorage *intevalStorage;
//            intevalStorage = [[LWImageStorage alloc]init];
//            intevalStorage.type = LWImageStorageLocalImage;
//            intevalStorage.image = intevalImage;
//            intevalStorage.frame = CGRectMake(0, readedStorage.bottom + 20, SCREEN_WIDTH, 1);
//            [container addStorage:intevalStorage];
//            self.cellHeight = intevalStorage.bottom;
            
            
            LWTextStorage* commentCoutTextStorage = [[LWTextStorage alloc] init];
            commentCoutTextStorage.font = [UIFont systemFontOfSize:12];
            commentCoutTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            commentCoutTextStorage.linespace = 1.0f;
            commentCoutTextStorage.textAlignment = NSTextAlignmentCenter;
            NSString *commentCount;
            if (questionsModel.evaluation_count) {
                commentCount = questionsModel.evaluation_count;
            }else{
                commentCount = @"0";
            }
            commentCoutTextStorage.text = commentCount;
            NSDictionary *commentCoutAttrs = @{NSFontAttributeName:commentCoutTextStorage.font};
            [commentCoutTextStorage setFrame:CGRectMake(SCREEN_WIDTH - 11 - [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].width , industryImageStorage.top , [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].width, [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].height)];
            [container addStorage:commentCoutTextStorage];
            
            LWImageStorage *commentStorage = [[LWImageStorage alloc]init];
            commentStorage.type = LWImageStorageLocalImage;
            commentStorage.image = [UIImage imageNamed:@"BB_PL"];
            
            commentStorage.frame = CGRectMake(commentCoutTextStorage.frame.origin.x - 5 - 20, industryImageStorage.top , 20, 16);
            [container addStorage:commentStorage];
            
            //        LWTextStorage* intevalWriteTextStorage = [[LWTextStorage alloc] init];
            //        intevalWriteTextStorage.font = [UIFont systemFontOfSize:12];
            //        intevalWriteTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"dddddd"];
            //        intevalWriteTextStorage.linespace = 1.0f;
            //        intevalWriteTextStorage.textAlignment = NSTextAlignmentCenter;
            //        intevalWriteTextStorage.text = @"|";
            //        [intevalWriteTextStorage setFrame:CGRectMake(commentStorage.left - 30, intevalStorage.bottom + (44 - [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height) / 2, 30, [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height)];
            //        [container addStorage:intevalWriteTextStorage];
            
            
            LWTextStorage* collectedCountTextStorage = [[LWTextStorage alloc] init];
            collectedCountTextStorage.font = [UIFont systemFontOfSize:12];
            collectedCountTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            collectedCountTextStorage.linespace = 1.0f;
            collectedCountTextStorage.textAlignment = NSTextAlignmentCenter;
            NSString *collectedCount;
            if (questionsModel.evaluation_count) {
                collectedCount = questionsModel.like_count;
            }else{
                collectedCount = @"0";
            }
            collectedCountTextStorage.text = collectedCount;
            NSDictionary *collectCountAttrs = @{NSFontAttributeName:collectedCountTextStorage.font};
            [collectedCountTextStorage setFrame:CGRectMake(commentStorage.left - 16 - [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].width , industryImageStorage.top , [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].width, [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].height)];
            [container addStorage:collectedCountTextStorage];
            
            
            LWImageStorage *collectedStorage = [[LWImageStorage alloc]init];
            collectedStorage.type = LWImageStorageLocalImage;
            collectedStorage.image = [UIImage imageNamed:@"BB_star"];
            collectedStorage.frame = CGRectMake(collectedCountTextStorage.left - 5 - 20, industryImageStorage.top , 20, 16);
            [container addStorage:collectedStorage];
            
            
            //        LWTextStorage* intevalReadTextStorage = [[LWTextStorage alloc] init];
            //        intevalReadTextStorage.font = [UIFont systemFontOfSize:12];
            //        intevalReadTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"dddddd"];
            //        intevalReadTextStorage.linespace = 1.0f;
            //        intevalReadTextStorage.textAlignment = NSTextAlignmentCenter;
            //        intevalReadTextStorage.text = @"|";
            //        [intevalReadTextStorage setFrame:CGRectMake(collectedStorage.left - 30, intevalStorage.bottom + (44 - [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height) / 2, 30, [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height)];
            //        [container addStorage:intevalReadTextStorage];
            
            
            LWTextStorage* readedCountTextStorage = [[LWTextStorage alloc] init];
            readedCountTextStorage.font = [UIFont systemFontOfSize:12];
            readedCountTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            readedCountTextStorage.linespace = 1.0f;
            readedCountTextStorage.textAlignment = NSTextAlignmentCenter;
            NSString *readedCount;
            if (questionsModel.show_count) {
                readedCount = questionsModel.show_count;
            }else{
                readedCount = @"0";
            }
            readedCountTextStorage.text = readedCount;
            NSDictionary *readedCountAttrs = @{NSFontAttributeName:collectedCountTextStorage.font};
            [readedCountTextStorage setFrame:CGRectMake(collectedStorage.left - 16 - [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].width , industryImageStorage.top , [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].width, [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].height)];
            [container addStorage:readedCountTextStorage];
            
            
            LWImageStorage *readedStorage = [[LWImageStorage alloc]init];
            readedStorage.type = LWImageStorageLocalImage;
            readedStorage.image = [UIImage imageNamed:@"BB_eye"];
            readedStorage.frame = CGRectMake(readedCountTextStorage.left - 5 - 20, industryImageStorage.top , 20, 16);
            [container addStorage:readedStorage];
            
//            if (!isLast) {
                LWImageStorage *intevalStorage1;
                intevalStorage1 = [[LWImageStorage alloc]init];
                intevalStorage1.type = LWImageStorageLocalImage;
                intevalStorage1.image = intevalImage1;
                
                intevalStorage1.frame = CGRectMake(0, industryImageStorage.bottom + 20, SCREEN_WIDTH, 1);
                [container addStorage:intevalStorage1];
                self.cellHeight = intevalStorage1.bottom;
//            }else{
//                self.cellHeight = industryImageStorage.bottom + 20;
//            }
            
        }else{
            LWImageStorage *intevalStorage;
            intevalStorage = [[LWImageStorage alloc]init];
            intevalStorage.type = LWImageStorageLocalImage;
            intevalStorage.image = intevalImage;
            intevalStorage.frame = CGRectMake(0, industryImageStorage.bottom + 16, SCREEN_WIDTH, 1);
            [container addStorage:intevalStorage];
            //if (isDetail) {
            LWImageStorage *focusedStorage;
            focusedStorage = [[LWImageStorage alloc]init];
            focusedStorage.type = LWImageStorageLocalImage;
            if (questionsModel.is_like && ([questionsModel.is_like integerValue] == 1)) {
                focusedStorage.image = [UIImage imageNamed:@"BB_YGZ"];
            }else{
                focusedStorage.image = [UIImage imageNamed:@"BB_follow"];
            }
            focusedStorage.frame = CGRectMake(20, intevalStorage.bottom + 9, 50, 25);
            self.focusPostion = focusedStorage.frame;
            [container addStorage:focusedStorage];
            
            // }
            
            
            LWTextStorage* commentCoutTextStorage = [[LWTextStorage alloc] init];
            commentCoutTextStorage.font = [UIFont systemFontOfSize:12];
            commentCoutTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            commentCoutTextStorage.linespace = 1.0f;
            commentCoutTextStorage.textAlignment = NSTextAlignmentCenter;
            NSString *commentCount;
            if (questionsModel.evaluation_count) {
                commentCount = questionsModel.evaluation_count;
            }else{
                commentCount = @"0";
            }
            commentCoutTextStorage.text = commentCount;
            NSDictionary *commentCoutAttrs = @{NSFontAttributeName:commentCoutTextStorage.font};
            [commentCoutTextStorage setFrame:CGRectMake(SCREEN_WIDTH - 11 - [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].width , intevalStorage.bottom + (44 - [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].height) / 2, [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].width, [commentCoutTextStorage.text sizeWithAttributes:commentCoutAttrs].height)];
            [container addStorage:commentCoutTextStorage];
            
            LWImageStorage *commentStorage = [[LWImageStorage alloc]init];
            commentStorage.type = LWImageStorageLocalImage;
            commentStorage.image = [UIImage imageNamed:@"BB_PL"];
            
            commentStorage.frame = CGRectMake(commentCoutTextStorage.frame.origin.x - 5 - 20, intevalStorage.bottom + (44 - 20) / 2 + 2, 20, 16);
            [container addStorage:commentStorage];
            
            //        LWTextStorage* intevalWriteTextStorage = [[LWTextStorage alloc] init];
            //        intevalWriteTextStorage.font = [UIFont systemFontOfSize:12];
            //        intevalWriteTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"dddddd"];
            //        intevalWriteTextStorage.linespace = 1.0f;
            //        intevalWriteTextStorage.textAlignment = NSTextAlignmentCenter;
            //        intevalWriteTextStorage.text = @"|";
            //        [intevalWriteTextStorage setFrame:CGRectMake(commentStorage.left - 30, intevalStorage.bottom + (44 - [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height) / 2, 30, [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height)];
            //        [container addStorage:intevalWriteTextStorage];
            
            
            LWTextStorage* collectedCountTextStorage = [[LWTextStorage alloc] init];
            collectedCountTextStorage.font = [UIFont systemFontOfSize:12];
            collectedCountTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            collectedCountTextStorage.linespace = 1.0f;
            collectedCountTextStorage.textAlignment = NSTextAlignmentCenter;
            NSString *collectedCount;
            if (questionsModel.evaluation_count) {
                collectedCount = questionsModel.like_count;
            }else{
                collectedCount = @"0";
            }
            collectedCountTextStorage.text = collectedCount;
            NSDictionary *collectCountAttrs = @{NSFontAttributeName:collectedCountTextStorage.font};
            [collectedCountTextStorage setFrame:CGRectMake(commentStorage.left - 16 - [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].width , intevalStorage.bottom + (44 - [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].height) / 2, [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].width, [collectedCountTextStorage.text sizeWithAttributes:collectCountAttrs].height)];
            [container addStorage:collectedCountTextStorage];
            
            
            LWImageStorage *collectedStorage = [[LWImageStorage alloc]init];
            collectedStorage.type = LWImageStorageLocalImage;
            collectedStorage.image = [UIImage imageNamed:@"BB_star"];
            collectedStorage.frame = CGRectMake(collectedCountTextStorage.left - 5 - 20, intevalStorage.bottom + (44 - 20) / 2, 20, 16);
            [container addStorage:collectedStorage];
            
            
            //        LWTextStorage* intevalReadTextStorage = [[LWTextStorage alloc] init];
            //        intevalReadTextStorage.font = [UIFont systemFontOfSize:12];
            //        intevalReadTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"dddddd"];
            //        intevalReadTextStorage.linespace = 1.0f;
            //        intevalReadTextStorage.textAlignment = NSTextAlignmentCenter;
            //        intevalReadTextStorage.text = @"|";
            //        [intevalReadTextStorage setFrame:CGRectMake(collectedStorage.left - 30, intevalStorage.bottom + (44 - [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height) / 2, 30, [commentCoutTextStorage.text sizeWithAttributes:industryTextAttrs].height)];
            //        [container addStorage:intevalReadTextStorage];
            
            
            LWTextStorage* readedCountTextStorage = [[LWTextStorage alloc] init];
            readedCountTextStorage.font = [UIFont systemFontOfSize:12];
            readedCountTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            readedCountTextStorage.linespace = 1.0f;
            readedCountTextStorage.textAlignment = NSTextAlignmentCenter;
            NSString *readedCount;
            if (questionsModel.show_count) {
                readedCount = questionsModel.show_count;
            }else{
                readedCount = @"0";
            }
            readedCountTextStorage.text = readedCount;
            NSDictionary *readedCountAttrs = @{NSFontAttributeName:collectedCountTextStorage.font};
            [readedCountTextStorage setFrame:CGRectMake(collectedStorage.left - 16 - [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].width , intevalStorage.bottom + (44 - [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].height) / 2, [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].width, [readedCountTextStorage.text sizeWithAttributes:readedCountAttrs].height)];
            [container addStorage:readedCountTextStorage];
            
            
            LWImageStorage *readedStorage = [[LWImageStorage alloc]init];
            readedStorage.type = LWImageStorageLocalImage;
            readedStorage.image = [UIImage imageNamed:@"BB_eye"];
            readedStorage.frame = CGRectMake(readedCountTextStorage.left - 5 - 20, intevalStorage.bottom + (44 - 15) / 2, 20, 16);
            [container addStorage:readedStorage];
            
//            LWImageStorage *intevalStorage1;
//            intevalStorage1 = [[LWImageStorage alloc]init];
//            intevalStorage1.type = LWImageStorageLocalImage;
//            intevalStorage1.image = intevalImage1;
//            
//            intevalStorage1.frame = CGRectMake(0, intevalStorage.bottom + 42, SCREEN_WIDTH, 1);
//            [container addStorage:intevalStorage1];
            self.cellHeight = intevalStorage.bottom + 42;
        }
        
        
        
        
        

    }
    return self;
    
}

@end
