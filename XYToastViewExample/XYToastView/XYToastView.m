//
//  BYToastView.m
//
//  Created by xiaoyu on 15/3/6.
//  Copyright (c) 2015年  All rights reserved.
//

#import "XYToastView.h"
#import <UIKit/UIKit.h>


@implementation XYToastView

static UIView *toastView;

static UIButton *messageButton;

static CAAnimationGroup *opacityLayerAnimationGroup;

static bool isShowing;

static NSTimer *timer;

#define toastViewMarginHeight [UIScreen mainScreen].bounds.size.height -85

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
            [messageButton setTitleColor:[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1] forState:UIControlStateNormal];
            [toastView addSubview:messageButton];
            isShowing = NO;
        }
        
        CGSize size = [XYToastView sizeWithString:messageString andLabelSize:CGSizeMake(HUGE_VAL, 25) andFont:messageButton.titleLabel.font];
        if (size.width >= [UIScreen mainScreen].bounds.size.width - 50*2) {
            size.width = [UIScreen mainScreen].bounds.size.width - 50*2;
        }
        toastView.frame = (CGRect){([UIScreen mainScreen].bounds.size.width-(size.width+20*2))/2,toastViewMarginHeight,size.width+20*2,25};
        messageButton.frame = (CGRect){20,0,size.width,25};
        [messageButton setTitle:messageString forState:UIControlStateNormal];
        
        if (!isShowing) {
            [[UIApplication sharedApplication].keyWindow addSubview:toastView];
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

+(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        NSString *animationType = [anim valueForKey:@"animationValue"];
        if ([animationType isEqualToString:@"toastViewOpacity"]) {
            [toastView removeFromSuperview];
            isShowing = NO;
        }
    }
}

+(CGSize)sizeWithString:(NSString *)string andLabelSize:(CGSize)size andFont:(UIFont *)font{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize size1 =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return size1;
    }else{
        return [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
}

@end
