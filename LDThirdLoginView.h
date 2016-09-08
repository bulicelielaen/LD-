//
//  LDThirdLoginView.h
//  LD高仿动态登录页
//
//  Created by 李洞洞 on 8/9/16.
//  Copyright © 2016年 Minte. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger ,Type){
    sina,
    qq,
    weixin
};

@interface LDThirdLoginView : UIView

@property(nonatomic,copy) void(^selectedBlock)(Type type);


@end
