//
//  ViewController.m
//  CrazyDrag
//
//  Created by 123456 on 15-4-15.
//  Copyright (c) 2015年 123456. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"
#include <AVFoundation/AVFoundation.h>

@interface ViewController ()
{
    int currentValue;
    int targetValue;
    int score;
    int round;
}

- (IBAction)showAlert:(id)sender;

- (IBAction)sliderMoved:(id)sender;

- (IBAction)resetAll:(id)sender;

- (IBAction)showInfo:(id)sender;

- (IBAction)musicBtnClick;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@end


@implementation ViewController

@synthesize slider;
@synthesize targetLabel;
@synthesize scoreLabel;
@synthesize roundLabel;
@synthesize audioPlayer;

//背景音乐
-(void)playBackgroundMusic{
    
    NSString *musicPath = [[NSBundle mainBundle]pathForResource:@"Sky" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicPath];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = -1;
    
    if (self.audioPlayer == nil) {
        NSString *errorInfo = [NSString stringWithString:[error description]];
        NSLog(@"the error is: %@",errorInfo);
    } else {
        [self.audioPlayer play];
    }

}

//播放和静音按钮
- (IBAction)musicBtnClick {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        self.musicBtn.selected = YES;
    } else {
        [self.audioPlayer play];
        self.musicBtn.selected = NO;
    }
}


//加载视图，开始游戏
- (void)viewDidLoad {
    [super viewDidLoad];
    [self playBackgroundMusic];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    
    UIImage *thumbImageHighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    [self.slider setThumbImage:thumbImageHighted forState:UIControlStateHighlighted];
    
    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
  
    
    [self startNewRound];
    [self updateLabels];
}

//开始新一轮游戏，给出随机数，计算回合数，将滑块归1
-(void)startNewRound
{
//    targetValue = 1 + arc4random() % 100;
    targetValue = arc4random()%60 +20;  //给出20-80之间的随机数，这样比较公平
    round += 1;
    currentValue = 1;
    self.slider.value = currentValue;
}

//每轮游戏开始后，显示随机数，并更新分数，回合数
-(void)updateLabels
{
    self.targetLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    self.roundLabel.text = [NSString stringWithFormat:@"%d",round];
}


- (IBAction)sliderMoved:(UISlider *)sender {
    
    currentValue = (int)lroundf(sender.value);
    NSLog(@"滑动条当前数值为：%f",sender.value);
}


- (IBAction)showAlert:(id)sender {

//计算差距方法2
    /*
    int diference;
    if (currentValue > targetValue) {
        diference = currentValue - targetValue;
    } else if(currentValue < targetValue){
        diference = targetValue -currentValue;
    } else{
        diference = 0;
    }
    */
//计算差距方法2
    /*
    int difference = currentValue - targetValue;
    if (difference < 0) {
        difference = -difference; //difference *= -1;
    }
    */
    
//计算差距方法3
    int difference = abs(currentValue - targetValue);
//计算每一轮用户拖动滑块的得分
    int points = 100 -difference;
    //score += points;被移动到后面if..else循环中

    NSString *message = [NSString stringWithFormat:@"当前数值:%d，目标数值:%d，得分:%d",currentValue,targetValue,points];
    
    NSString *titleMessage;
    //100，90，80以上，80以下不同提示语
    
    //app1教程中的写法
    /*
     if (difference == 0) {
     titleMessage = @"完美表现";
     } else if(difference <= 10){
     titleMessage = @"太棒啦";
     } else if (difference <= 20){
     titleMessage = @"还不错";
     } else{
     titleMessage = @"差远啦";
     }
    */
    
    //我自己的写法，if...else嵌套，自动排除上一种情况
    if (points == 100) {
        titleMessage = @"百步穿杨,奖励100分";
        points += 100; //额外奖励100
    } else if(points == 99){
        titleMessage = @"九九女儿红,奖励50分";
        points += 50; //额外奖励50
    } else if (points >= 90){
        titleMessage = @"太棒啦";
    } else if (points >= 80){
        titleMessage = @"还不错";
    } else{
        titleMessage = @"差远啦";
    }
    //在奖励points加分后，再加总游戏之前所有回合的总成绩
    score += points;
    
//调用代理，延迟分数更新，延迟下一轮开始时间
    [[[UIAlertView alloc]initWithTitle:titleMessage message:message delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles:nil, nil] show];
}


//使用代理delegate:self和如下方法，使弹出的对话框消失后再更新分数，开始下一轮
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self startNewRound];
    [self updateLabels];
}

//再来一回，重置所有参数
- (IBAction)resetAll:(id)sender {
    
    //添加过渡效果
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    score = 0;
    round = 0;
    [self startNewRound];
    [self updateLabels];
    
    [self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)showInfo:(id)sender {
    
    AboutViewController *aboutcontroller = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    aboutcontroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:aboutcontroller animated:YES completion:nil];
}


//内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    BOOL res = (toInterfaceOrientation == UIDeviceOrientationLandscapeRight | toInterfaceOrientation == UIDeviceOrientationLandscapeRight);
//
    return res;
}

@end
