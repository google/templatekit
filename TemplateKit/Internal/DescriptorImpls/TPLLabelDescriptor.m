/*
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "Internal/DescriptorImpls/TPLLabelDescriptor.h"

#import "Internal/Core/TPLBenchmark.h"
#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/DescriptorImpls/TPLDescriptorImplsMacros.h"
#import "Public/Core/TPLSettings.h"

static UIColor *g_defaultTextColor;
static UIFont *g_defaultFont;
static NSLineBreakMode g_defaultLineBreakMode;
static NSInteger g_defaultNumberOfLines;
static NSTextAlignment g_defaultTextAlignment;

static NSTextAlignment RTLTextAlignment(NSTextAlignment alignment) {
  switch (alignment) {
    case NSTextAlignmentLeft:
      return NSTextAlignmentRight;
    case NSTextAlignmentRight:
      return NSTextAlignmentLeft;
    default:
      return alignment;
  }
}


@implementation TPLLabelData

- (instancetype)init {
  static dispatch_once_t defaultInitializationOnce;
  dispatch_once(&defaultInitializationOnce, ^{
    UILabel *label = [[UILabel alloc] init];
    g_defaultTextColor = label.textColor;
    g_defaultFont = label.font;
    g_defaultLineBreakMode = label.lineBreakMode;
    g_defaultNumberOfLines = label.numberOfLines;
    g_defaultTextAlignment = label.textAlignment;
  });

  self = [super init];
  if (self) {
    _textColor = g_defaultTextColor;
    _font = g_defaultFont;
    _lineBreakMode = g_defaultLineBreakMode;
    _numberOfLines = g_defaultNumberOfLines;
    _textAlignment = g_defaultTextAlignment;
  }
  return self;
}

- (void)setText:(NSString *)text {
  _text = text;
  _attributedText = nil;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
  _attributedText = attributedText;
  _text = nil;
}

@end


@implementation TPLLabelDescriptor

- (UIView *)uninitializedView {
  return [[UILabel alloc] init];
}

- (void)setData:(id)data toView:(UIView *)view {
  UILabel *label = DOWNCAST(view, UILabel);
  if (!data) {
    label.text = nil;
  } else if ([data isKindOfClass:[NSString class]]) {
    label.text = DOWNCAST(data, NSString);
  } else if ([data isKindOfClass:[NSAttributedString class]]) {
    label.attributedText = DOWNCAST(data, NSAttributedString);
  } else if ([data isKindOfClass:[TPLLabelData class]]) {
    TPLLabelData *labelData = DOWNCAST(data, TPLLabelData);
    label.text = nil;
    label.attributedText = nil;
    if (labelData.text) {
      label.text = labelData.text;
    } else if (labelData.attributedText) {
      label.attributedText = labelData.attributedText;
    }
    label.textColor = labelData.textColor;
    label.font = labelData.font;
    label.lineBreakMode = labelData.lineBreakMode;
    label.numberOfLines = labelData.numberOfLines;
    label.textAlignment = labelData.textAlignment;
  } else {
    assert(0);
  }
  if ([TPLSettings isRTL]) {
    label.textAlignment = RTLTextAlignment(label.textAlignment);
  }
}

- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data {
  CGSize sizeThatFits = CGSizeZero;
  TPL_BENCHMARK(2, string_sizing, self) {
    // TODO: reimplement this method without creating a label instance.
    UILabel *label = [[UILabel alloc] init];
    [self setData:data toView:label];
    sizeThatFits = [label sizeThatFits:size];
  }
  return sizeThatFits;

  //  if ([data isKindOfClass:[TPLLabelData class]]) {
  //    TPLLabelData *labelData = DOWNCAST(data, TPLLabelData);
  //    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
  //    paragraph.lineBreakMode = labelData.lineBreakMode;
  //    NSDictionary *attributes = @{
  //        NSFontAttributeName : labelData.font,
  //        NSParagraphStyleAttributeName : paragraph
  //    };
  //    CGRect boundingRect =
  //        [labelData.text boundingRectWithSize:size
  //                                     options:NSStringDrawingUsesLineFragmentOrigin
  //                                  attributes:attributes
  //                                     context:0];
  //    CGSize viewSize = CGSizeMake(ceil(CGRectGetWidth(boundingRect)),
  //                                 ceil(CGRectGetHeight(boundingRect)));
  //    return viewSize;
  //  } else if ([data isKindOfClass:[NSString class]]) {
  //    NSString *text = DOWNCAST(data, NSString);
  //    UIFont *font = [[UILabel alloc] init].font;
  //    NSDictionary *attributes = @{NSFontAttributeName:font};
  //    // TODO: Implement line break mode
  //    CGRect boundingRect = [text boundingRectWithSize:size
  //                                             options:NSStringDrawingUsesLineFragmentOrigin
  //                                          attributes:attributes
  //                                             context:0];
  //    CGSize viewSize = CGSizeMake(ceil(CGRectGetWidth(boundingRect)),
  //                                 ceil(CGRectGetHeight(boundingRect)));
  //    return viewSize;
  //  } else if ([data isKindOfClass:[NSAttributedString class]]) {
  //    NSAttributedString *text = DOWNCAST(data, NSAttributedString);
  //    // TODO: Implement line break mode
  //    // TODO: This code is still buggy.
  //    CGRect boundingRect = [text boundingRectWithSize:size
  //                                             options:NSStringDrawingUsesLineFragmentOrigin
  //                                             context:0];
  //    CGSize viewSize = CGSizeMake(ceil(CGRectGetWidth(boundingRect)),
  //                                 ceil(CGRectGetHeight(boundingRect)));
  //    return viewSize;
  //  } else {
  //    // assert
  //    return CGSizeZero;
  //  }
}

- (BOOL)isViewHiddenWithData:(id)data {
  if ([data isKindOfClass:[NSString class]]) {
    return DOWNCAST(data, NSString).length == 0;
  } else if ([data isKindOfClass:[NSAttributedString class]]) {
    return DOWNCAST(data, NSAttributedString).length == 0;
  } else if ([data isKindOfClass:[TPLLabelData class]]) {
    TPLLabelData *labelData = (TPLLabelData *)data;
    if (labelData.text) {
      return labelData.text.length == 0;
    } else if (labelData.attributedText) {
      return labelData.attributedText.length == 0;
    } else {
      return YES;
    }
  } else {
    assert(0);
    return YES;
  }
}

@end
