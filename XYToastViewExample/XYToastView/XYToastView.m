//
//  BYToastView.m
//  ByidsMIOAS
//
//  Created by 肖宇 on 15/3/6.
//  Copyright (c) 2015年  All rights reserved.
//

#import "BYToastView.h"
#import "Macros.h"
#import <UIKit/UIKit.h>

@implementation BYToastView

static UIView *toastView;

static UIButton *messageButton;

static CAAnimationGroup *opacityLayerAnimationGroup;

static bool isShowing;

static NSTimer *timer;

#define toastViewMarginHeight [UIScreen mainScreen].bounds.size.height - 120

+(void)initialize{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

+(void)showToastWithMessage:(NSString *)messageString{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!toastView) {
            toastView = [UIView new];
            toastView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
            toastView.layer.cornerRadius = 2.f;
            toastView.layer.masksToBounds = YES;
            
            messageButton = [[UIButton alloc]init];
            messageButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            messageButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [messageButton setTitleColor:RGBAColor(220, 220, 220, 1) forState:UIControlStateNormal];
            [toastView addSubview:messageButton];
            isShowing = NO;
        }
        
        CGSize size = [BYToastView sizeWithString:messageString andLabelSize:CGSizeMake(HUGE_VAL, 25) andFont:messageButton.titleLabel.font];
        if (size.width >= GLOBALWIDTH - 50*2) {
            size.width = GLOBALWIDTH - 50*2;
        }
        if (XYToastView_KeyboardIsShowingHieght == 0) {
            toastView.frame = (CGRect){(GLOBALWIDTH-(size.width+20*2))/2,toastViewMarginHeight,size.width+20*2,25};
        }else{
            toastView.frame = (CGRect){
                (GLOBALWIDTH-(size.width+20*2))/2,
                [UIScreen mainScreen].bounds.size.height -fabs(XYToastView_KeyboardIsShowingHieght) - 60,
                size.width+20*2,
                25
            };
        }
        NSLog(@"%@",NSStringFromCGRect(toastView.frame));
        
        
        messageButton.frame = (CGRect){20,0,size.width,25};
        [messageButton setTitle:messageString forState:UIControlStateNormal];
        
        if (!isShowing) {
            [MainWindow addSubview:toastView];
            isShowing = YES;
        }
        
        CABasicAnimation *opacityLayerAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityLayerAnimation1.duration = 0.5;
        opacityLayerAnimation1.fromValue = [NSNumber numberWithFloat:toastView.alpha];
        opacityLayerAnimation1.toValue = [NSNumber numberWithFloat:1];
        opacityLayerAnimation1.removedOnCompletion = NO;
        opacityLayerAnimation1.fillMode = kCAFillModeForwards;
        opacityLayerAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *opacityLayerAnimation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityLayerAnimation3.beginTime = 2.5f;
        opacityLayerAnimation3.duration = 0.5;
        opacityLayerAnimation3.fromValue = [NSNumber numberWithFloat:1];
        opacityLayerAnimation3.toValue = [NSNumber numberWithFloat:0];
        opacityLayerAnimation3.removedOnCompletion = NO;
        opacityLayerAnimation3.fillMode = kCAFillModeForwards;
        opacityLayerAnimation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        opacityLayerAnimationGroup = [CAAnimationGroup animation];
        opacityLayerAnimationGroup.animations = [NSArray arrayWithObjects:opacityLayerAnimation1,opacityLayerAnimation3, nil];
        opacityLayerAnimationGroup.duration = 3;
        opacityLayerAnimationGroup.delegate = self;
        opacityLayerAnimationGroup.removedOnCompletion = NO;
        opacityLayerAnimationGroup.fillMode = kCAFillModeForwards;
        opacityLayerAnimationGroup.repeatCount = 1;
        
        [opacityLayerAnimationGroup setValue:@"toastViewOpacity" forKey:@"animationValue"];
        
        [toastView.layer addAnimation:opacityLayerAnimationGroup forKey:@"toastViewOpacity"];
    });
}

static float XYToastView_KeyboardIsShowingHieght = 0;
+(void)keyboardDidHide:(NSNotification *)notification{
    XYToastView_KeyboardIsShowingHieght = 0;
}

+(void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    if (yOffset < -120) {
        XYToastView_KeyboardIsShowingHieght = yOffset;
    }
    NSLog(@"XYToastView_KeyboardIsShowingHieght  %f",XYToastView_KeyboardIsShowingHieght);
    
    if (toastView) {
        CGRect rect = toastView.frame;
        
        toastView.frame = (CGRect){
            rect.origin.x,
            [UIScreen mainScreen].bounds.size.height + yOffset - 60,
            rect.size.width,
            rect.size.height
        };
    }
}

+(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString *animationType = [anim valueForKey:@"animationValue"];
    if ([animationType isEqualToString:@"toastViewOpacity"]) {
        [toastView removeFromSuperview];
        isShowing = NO;
    }
}

+(CGSize)sizeWithString:(NSString *)string andLabelSize:(CGSize)size andFont:(UIFont *)font{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize sizeTmp =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return sizeTmp;
    }else{
        return [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
}

@end


@implementation UIApplication (KeyBoardNotification)

+(void)initialize{
    [super initialize];
    [BYToastView initialize];
}

@end
