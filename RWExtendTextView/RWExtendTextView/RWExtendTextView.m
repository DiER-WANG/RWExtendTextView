//
//  RWExtendTextView.m
//  RWExtendTextView
//
//  Created by wangchangyang on 2017/6/27.
//  Copyright © 2017年 wangchangyang. All rights reserved.
//

#import "RWExtendTextView.h"

@interface RWExtendTextView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) BOOL isExtending;

@end

@implementation RWExtendTextView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _placeholder = @"我要发弹幕...";
        _inputTextFont = [UIFont systemFontOfSize:14];
        _placeholderColor = [UIColor lightGrayColor];
        _inputTextColor = [UIColor blackColor];
        _maxLines = 3;
        _sendBtnBgColor = [UIColor blackColor];
        _sendBtnTitleColor = [UIColor whiteColor];
        _sendBtnFont = [UIFont systemFontOfSize:14];
        _sendBtnTitle = @"发送";
        [self setUp];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        self.frame = newSuperview.bounds;
    }
    
    [self calculateTextViewFrame];
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - Calculate
- (void)setUp {
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1)];
    [self addSubview:sepLine];
    sepLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.isExtending = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self addObservers];
}

- (void)calculateTextViewFrame {
    if (self.textView.contentSize.height < self.maxHeight) {
        CGRect rect = self.bounds;
        rect.origin.y = 0;
        rect.size.height = self.textView.contentSize.height;
        self.textView.frame = CGRectMake(10, 10.5, rect.size.width - 10 * 3 - 72, rect.size.height);
        self.sendBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, CGRectGetMaxY(self.textView.frame) - 28, 72, 28);
        [self adjusSelfFrame:rect.size.height + 10 * 2];
    } else {
        self.textView.frame = CGRectMake(10, 10, self.bounds.size.width - 10 * 3 - 72, self.bounds.size.height - 10 * 2);
        self.sendBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, CGRectGetMaxY(self.textView.frame) - 28, 72, 28);
        self.isExtending = NO;
    }
    CGRect textBounds = self.textView.bounds;
    textBounds.origin.x += 10.f;
    self.placeholderLabel.frame = textBounds;
}

- (void)addObservers {
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self calculateTextViewFrame];
    }
}


#pragma mark - Lazy Load
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [self addSubview:_textView];
        _textView.delegate = self;
        _textView.font = _inputTextFont;
        _textView.layer.cornerRadius = 14.f;
        _textView.backgroundColor = [UIColor colorWithRed:237/255.f green:238/255.f blue:244/255.f alpha:1];
        _textView.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        [self.textView addSubview:_placeholderLabel];
        _placeholderLabel.font = _inputTextFont;
        _placeholderLabel.text = _placeholder;
        _placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    return _placeholderLabel;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [self addSubview:_sendBtn];
        [_sendBtn setBackgroundColor:_sendBtnBgColor];
        [_sendBtn setTitle:_sendBtnTitle
                  forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = _sendBtnFont;
        [_sendBtn setTitleColor:_sendBtnTitleColor
                       forState:UIControlStateNormal];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 14;
        [_sendBtn addTarget:self
                     action:@selector(sendBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length <= 0 && self.placeholder.length > 0) {
        self.placeholderLabel.text = self.placeholder;
    } else {
        self.placeholderLabel.text = @"";
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isExtending) {
        // 防止换行时抖动
        scrollView.contentOffset = CGPointZero;
    }
}

- (CGFloat)maxHeight {
    return self.inputTextFont.lineHeight * _maxLines;
}

#pragma mark - Custom Property Setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setInputTextFont:(UIFont *)inputTextFont {
    _inputTextFont = inputTextFont;
    self.placeholderLabel.font = inputTextFont;
    self.textView.font = inputTextFont;
}

- (void)setSendBtnFont:(UIFont *)sendBtnFont {
    _sendBtnFont = sendBtnFont;
    self.sendBtn.titleLabel.font = sendBtnFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderColor = placeholderColor;
}

- (void)setInputTextColor:(UIColor *)inputTextColor {
    _inputTextColor = inputTextColor;
    self.textView.textColor = inputTextColor;
}

- (void)setInputBackColor:(UIColor *)inputBackColor {
    _inputBackColor = inputBackColor;
    self.textView.backgroundColor = inputBackColor;
}

- (void)setSendBtnBgColor:(UIColor *)sendBtnBgColor {
    _sendBtnBgColor = sendBtnBgColor;
    [self.sendBtn setBackgroundColor:sendBtnBgColor];
}

- (void)setSendBtnTitleColor:(UIColor *)sendBtnTitleColor {
    _sendBtnTitleColor = sendBtnTitleColor;
    [self.sendBtn setTitleColor:sendBtnTitleColor
                       forState:UIControlStateNormal];
}

- (void)setSendBtnTitle:(NSString *)sendBtnTitle {
    _sendBtnTitle = sendBtnTitle;
    [self.sendBtn setTitle:sendBtnTitle forState:UIControlStateNormal];
}

- (void)setMaxLines:(NSUInteger)maxLines {
    _maxLines = maxLines;
}

#pragma mark - Delegate Method
- (void)adjusSelfFrame:(CGFloat)height {
    if ([_delegate respondsToSelector:@selector(rw_textViewHeightChanged:)]) {
        [_delegate rw_textViewHeightChanged:height];
    }
}

- (void)sendBtnClicked:(UIButton *)btn {
    if (!self.textView.hasText) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(rw_textViewSendBtnClicked:)]) {
        [_delegate rw_textViewSendBtnClicked:self.textView.text];
    }
    self.textView.text = nil;
}


@end
