

#import "UIView+BCHAlert.h"
#import <objc/runtime.h>
#import "NSArray+BCHHelperKit.h"
static const void *s_bch_alertBlockKey = "s_bch_alertBlockKey"; 

@interface UIApplication (BCHAlert) <UIAlertViewDelegate>
@end
@implementation UIApplication (BCHAlert)
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.bch_alertBlock) {
        alertView.bch_alertBlock(alertView, buttonIndex);
    }
} 
@end

@implementation UIView (BCHAlert)
#pragma mark - setter / getter
-(BCHAlertBlock)bch_alertBlock{
    return objc_getAssociatedObject(self, s_bch_alertBlockKey);
}
-(void)setBch_alertBlock:(BCHAlertBlock)bch_alertBlock{
    objc_setAssociatedObject(self, s_bch_alertBlockKey, bch_alertBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void)bch_showWithTitle:(NSString *)title
                 message:(NSString *)message
            buttonTitles:(NSArray *)buttonTitles
                   callback:(BCHAlertBlock)callback{
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion < 8.0f){
        NSString *ok = nil;
        if (nil != buttonTitles && buttonTitles.count > 0) {
            ok = [buttonTitles bch_objectAtIndex:0];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:[UIApplication sharedApplication]
                                                  cancelButtonTitle:ok
                                                  otherButtonTitles:
                                  [buttonTitles bch_objectAtIndex:1],
                                  [buttonTitles bch_objectAtIndex:2],
                                  [buttonTitles bch_objectAtIndex:3],
                                  [buttonTitles bch_objectAtIndex:4],
                                  [buttonTitles bch_objectAtIndex:5],
                                  [buttonTitles bch_objectAtIndex:6],
                                  [buttonTitles bch_objectAtIndex:7],
                                  [buttonTitles bch_objectAtIndex:8],
                                  [buttonTitles bch_objectAtIndex:9],
                                  [buttonTitles bch_objectAtIndex:10],
                                  [buttonTitles bch_objectAtIndex:11],
                                  [buttonTitles bch_objectAtIndex:12],
                                  [buttonTitles bch_objectAtIndex:13],
                                  [buttonTitles bch_objectAtIndex:14],
                                  nil];
        alertView.bch_alertBlock = callback;
        [alertView show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        for (int i = 0; i < buttonTitles.count; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (callback) {
                    callback(action,i);
                }
            }];
            [alert addAction:action];
        }
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alert animated:YES completion:nil];
    }
}
@end
