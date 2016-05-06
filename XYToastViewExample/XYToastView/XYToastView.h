//
//  BYToastView.h
//  ByidsMIOAS
//
//  Created by 肖宇 on 15/3/6.
//  Copyright (c) 2015年  All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  该类实现了ios版本类似安卓上的toast的提示功能
 *  
 *  已知问题:在键盘弹出的时候 view会被键盘挡住 而看不见
 *  
 *  该view默认是在keywindow中显示
 */
@interface BYToastView : NSObject

+(void)showToastWithMessage:(NSString *)messageString;

@end

@interface UIApplication (KeyBoardNotification)


@end
