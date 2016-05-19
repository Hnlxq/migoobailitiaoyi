//
//  AboutViewController.m
//  CrazyDrag
//
//  Created by wujia121 on 15/4/19.
//  Copyright (c) 2015年 123456. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

- (IBAction)close:(id)sender;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

//    NSString *htmlFile = [[NSBundle mainBundle]pathForResource:@"CrazyDrag" ofType:@"html"];
//    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
//    NSURL * baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]];
//    [self.webWiew loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
    
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/cn/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webWiew loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)close:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
