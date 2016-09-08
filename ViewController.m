//
//  ViewController.m
//  LD高仿动态登录页
//
//  Created by 李洞洞 on 8/9/16.
//  Copyright © 2016年 Minte. All rights reserved.
//

#import "ViewController.h"

#import <IJKMediaFramework/IJKMediaFramework.h> //请看 README.md
#import "LDThirdLoginView.h"
#import "UIButton+Extension.h"
#import "Masonry.h"
@interface ViewController ()

@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverView;

/** 快速登录 */
@property (nonatomic, weak) UIButton *loginBtn;

/** 第三方登录 */
@property (nonatomic, weak) LDThirdLoginView *thirdView;

@end

#define XLColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define XLBasicColor XLColor(214, 41, 117)

@implementation ViewController

#pragma mark---懒加载
- (LDThirdLoginView *)thirdView
{
    if (_thirdView == nil){
        
        LDThirdLoginView *thirdView = [[LDThirdLoginView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        [thirdView setSelectedBlock:^(Type type) {
            
        weakSelf.coverView.hidden = YES;
            
        [self.coverView removeFromSuperview];
            
            weakSelf.coverView = nil;
            
            switch (type) {
                case sina:
                    
                   // [weakSelf sinaMethod];
                    break;
                    
                case qq:
                    
                  //  [weakSelf qq];
                    break;
                    
                case weixin:
                    
                    //[weakSelf weixin];
                    break;
                default:
                    break;
            }
            
        }];
        
        [self.view addSubview:thirdView];
        
        
        [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(@0);
            make.height.equalTo(@60);
            make.bottom.equalTo(self.loginBtn.mas_top).offset(-40);
            
        }];
        
        _thirdView = thirdView;
    }
    return _thirdView;
}

- (UIButton *)loginBtn
{
    if (_loginBtn == nil){
        
        UIButton *loginBtn = [[UIButton alloc] init];
        
        loginBtn.backgroundColor = [UIColor clearColor];
        loginBtn.titleColor = XLBasicColor;
        loginBtn.title = @"快速登录";
        loginBtn.layer.borderWidth = 1;
        loginBtn.layer.borderColor = XLBasicColor.CGColor;
        loginBtn.highlightedTitleColor = [UIColor redColor];
        
        
        [loginBtn addTarget:self action:@selector(loginClick)];
        
        [self.view addSubview:loginBtn];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@40);
            make.right.equalTo(@-40);
            make.bottom.equalTo(@-60);
            make.height.equalTo(@40);
        }];
        
        _loginBtn = loginBtn;
    }
    return _loginBtn;
}
- (UIImageView *)coverView
{
    if (_coverView == nil) {
        UIImageView *cover = [[UIImageView alloc] initWithFrame:self.view.bounds];
        cover.image = [UIImage imageNamed:@"LaunchImage"];
        [self.player.view addSubview:cover];
        _coverView = cover;
    }
    return _coverView;
}

- (IJKFFMoviePlayerController *)player
{
    if (_player == nil){
        
        NSString *path = arc4random_uniform(2) ? @"login_video" : @"loginmovie";
        
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@"mp4"] withOptions:[IJKFFOptions optionsByDefault]];
        
        _player.view.frame = self.view.bounds;
        _player.scalingMode = IJKMPMovieScalingModeAspectFill;
        _player.shouldAutoplay = NO;
        [_player prepareToPlay];
        
        [self.view addSubview:_player.view];
        
    }
    
    return _player;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.player  play];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self notificationOfPlayer];
    
}
- (void)loginClick
{
//    [MBProgressHUD showMessage:@"登录中..."];
//    
//    
//    [self jump];
    
}
- (void)notificationOfPlayer
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)stateDidChange
{
    __weak typeof(self) weakSelf = self;
                                 //   // 状态为缓冲几乎完成，可以连续播放
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        
        if (!self.player.isPlaying) {
            //把播放的View插在背景View之前
            [self.view insertSubview:self.coverView atIndex:0];
            
            [self.player play];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                weakSelf.thirdView.hidden = NO;
                weakSelf.loginBtn.hidden = NO;
                
            });
        }
    }
}

- (void)didFinish
{
    // 播放完之后, 继续重播
    [self.player play];
}

@end
