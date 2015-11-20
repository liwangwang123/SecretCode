//
//  SecretCodeController.m
//  Block
//
//  Created by 王力 on 15/11/19.
//  Copyright (c) 2015年 王力. All rights reserved.
//

#import "SecretCodeController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "JTSlideShadowAnimation.h"

@interface SecretCodeController () <UIScrollViewDelegate>
{
    BOOL isRight;
    UIColor *_startColor;
    BOOL isAnimated;
}
@property (weak, nonatomic) IBOutlet UIView *secretCodeView1;
@property (weak, nonatomic) IBOutlet UIView *secretCodeView2;
@property (weak, nonatomic) IBOutlet UIView *secretCodeView3;
@property (weak, nonatomic) IBOutlet UIView *secretCodeView4;
@property (weak, nonatomic) IBOutlet UIView *secretCodeBackgroundView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBackgroudView;
@property (weak, nonatomic) IBOutlet UIView *twoBackgroundView;

//<#name#>
@property (nonatomic, strong) NSArray *startCode;
//<#name#>
@property (nonatomic, strong) NSMutableArray *changeCode;
//<#name#>
@property (nonatomic, strong) NSArray *changeView;


//TWO Page
//<#name#>

@property (weak, nonatomic) IBOutlet UIButton *animatedView;

@property (nonatomic, strong) JTSlideShadowAnimation *shadowAnimation;
@end

@implementation SecretCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    isRight = 1;
    // Do any additional setup after loading the view.
    [self addShadowAnimation];
    [self fingerprintVerification];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isAnimated = YES;
    [self.shadowAnimation start];
}

- (void)didButtonClick:(UIButton *)sender
{
    if(isAnimated){
        [self.shadowAnimation stop];
    }
    else{
        [self.shadowAnimation start];
    }
    
    isAnimated = !isAnimated;
}
- (void)addShadowAnimation {
    //isAnimated = YES;

    
//    self.animatedView = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 120, 150, 120)];
//    [self.animatedView setTitle: @"> 滑动解锁" forState:UIControlStateNormal];
    self.animatedView.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.animatedView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.twoBackgroundView addSubview:self.animatedView];
    
    self.shadowAnimation = [JTSlideShadowAnimation new];
    self.shadowAnimation.animatedView = self.animatedView;
    self.shadowAnimation.shadowWidth = 40.0;
    [self.shadowAnimation start];
}
- (void)fingerprintVerification {
    CGPoint startPoint = CGPointMake(self.view.frame.size.width, 0);
    [self.scrollViewBackgroudView setContentSize:CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height)];
    [self.scrollViewBackgroudView setContentOffset:startPoint animated:YES];
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    NSString *myLocalizedReasonString = @"请输入指纹";
    //Touch ID是否可用
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError *error) {
            NSLog(@"Touch ID 可以使用");
            
            if (success) {
                //身份验证成功
                NSLog(@"身份验证成功,跳转进去APP");
                
            } else {
                //身份验证失败
                NSLog(@"身份验证失败");
                
                CGRect frame = self.animatedView.frame;
                CGRect startFrame = frame;
                CGFloat X = frame.origin.x;
                frame.origin.x = X + 10;
                CGRect frame1 = frame;
                frame.origin.x = X - 20;
                CGRect frame2 = frame;
                
                [UIView animateWithDuration:0.1 animations:^{
                    self.animatedView.frame = frame1;
                }];
                
                [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
                    self.animatedView.frame = frame2;
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
                        self.animatedView.frame = frame2;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.animatedView.frame = startFrame;
                            
                        }];
                    }];
                }];
                
            }
        }];
        
    } else {
        //无法使用Touch ID
        NSLog(@"Touch ID 不可以使用");
        
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inPutSecretCode:(UIButton *)sender {
    if (![sender.titleLabel.text isEqualToString:@"删除"]) {
        [self.changeCode addObject:sender.titleLabel.text];
        NSInteger number = self.changeCode.count - 1;
        UIView *changeColorView = self.changeView[number];
        
        changeColorView.backgroundColor = [UIColor lightGrayColor];
        if ([[self.changeCode lastObject] isEqualToString:self.startCode[self.changeCode.count - 1]]) {
            
        } else {
            isRight = 0;
        }
    } else {
        //
        if (self.changeCode.count > 0) {
            [self.changeCode removeLastObject];
            NSInteger number = self.changeCode.count;
            UIView *changeColorView = self.changeView[number];
            changeColorView.backgroundColor = _startColor;
        }
    }
    if (self.changeCode.count == 4) {
        
        if (isRight) {
            NSLog(@"跳转");
        } else {
            
            CGRect frame = self.secretCodeBackgroundView.frame;
            CGRect startFrame = frame;
            CGFloat X = frame.origin.x;
            frame.origin.x = X + 10;
            CGRect frame1 = frame;
            frame.origin.x = X - 20;
            CGRect frame2 = frame;
            
            [UIView animateWithDuration:0.1 animations:^{
                self.secretCodeBackgroundView.frame = frame1;
            }];

            [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
                self.secretCodeBackgroundView.frame = frame2;
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
                    self.secretCodeBackgroundView.frame = frame2;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.secretCodeBackgroundView.frame = startFrame;
                        for (UIView *view in self.changeView) {
                            view.backgroundColor = _startColor;
                        }
                    }];
                }];
            }];

        }
        [self.changeCode removeAllObjects];
        isRight = 1;
    }
    NSLog(@"%@", sender.titleLabel.text);
}

- (NSArray *)changeView {
    if (!_changeView) {
        self.changeView = [NSArray arrayWithObjects:self.secretCodeView1, self.secretCodeView2, self.secretCodeView3, self.secretCodeView4, nil];
        _startColor = self.secretCodeView1.backgroundColor;
    }
    return _changeView;
}

- (NSArray *)startCode {
    if (!_startCode) {
        self.startCode = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    }
    return _startCode;
}
- (NSMutableArray *)changeCode {
    if (!_changeCode) {
        self.changeCode = [NSMutableArray arrayWithCapacity:1];
    }
    return _changeCode;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
