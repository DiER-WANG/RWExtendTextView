//
//  ViewController.m
//  RWExtendTextView
//
//  Created by wangchangyang on 2017/6/27.
//  Copyright © 2017年 wangchangyang. All rights reserved.
//

#import "ViewController.h"
#import "RWExtendTextView.h"


@interface ViewController ()<RWExtendTextViewDelegate>

@property(nonatomic, weak) RWExtendTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
    
    RWExtendTextView *textView = [[RWExtendTextView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(view.frame) - 10 * 2, 49)];
    [view addSubview:textView];
    _textView = textView;
    textView.backgroundColor = [UIColor blueColor];
    textView.delegate = self;
}

- (void)rw_textViewHeightChanged:(CGFloat)height {
    CGRect rect = self.textView.frame;
    rect.origin.y = CGRectGetMaxY(rect) - height;
    rect.size.height = height;
    
    self.textView.frame = rect;

}

- (void)rw_textViewSendBtnClicked:(NSString *)text {
    
}


- (void)textViewHeightChanged:(CGFloat)height {
    CGRect rect = _textView.frame;
    rect.size.height = height;
    _textView.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
