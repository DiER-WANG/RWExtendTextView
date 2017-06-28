//
//  RWExtendTextView.h
//  RWExtendTextView
//
//  Created by wangchangyang on 2017/6/27.
//  Copyright © 2017年 wangchangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RWExtendTextViewDelegate <NSObject>

@optional
- (void)rw_textViewHeightChanged:(CGFloat)height;
- (void)rw_textViewSendBtnClicked:(NSString *)text;

@end

@interface RWExtendTextView : UIView

#pragma mark Custom Property
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *sendBtnTitle;

@property (nonatomic, strong) UIFont *inputTextFont;
@property (nonatomic, strong) UIFont *sendBtnFont;

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *inputTextColor;
@property (nonatomic, strong) UIColor *inputBackColor;

@property (nonatomic, strong) UIColor  *sendBtnBgColor;
@property (nonatomic, strong) UIColor  *sendBtnTitleColor;

@property (nonatomic, assign) NSUInteger maxLines;

@property (nonatomic, weak) id<RWExtendTextViewDelegate> delegate;

@end
