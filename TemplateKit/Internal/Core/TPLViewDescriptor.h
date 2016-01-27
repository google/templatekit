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

#import <UIKit/UIKit.h>

#import "Public/Core/TPLConstants.h"
#import "Public/Core/TPLViewModifier.h"

@class TPLAccessibility;
@class TPLValueProvider;
@class TPLViewDescriptorFormatter;
@class TPLViewModel;
@class TPLViewModifierAndValue;


@interface TPLViewDescriptor : NSObject

// public, final.
+ (instancetype)descriptor;

// public, final.
- (UIView *)view;

// private, pure virtual.
- (UIView *)uninitializedView;

// public, virtual. Overrides must call super's implementation.
- (void)populateView:(UIView *)view withViewModel:(TPLViewModel *)viewModel;

// public, final.
- (CGSize)viewSizeThatFits:(CGSize)size
             withViewModel:(TPLViewModel *)viewModel;

// private, pure virtual.
- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel;

// public, virtual. Overrides must respect super's decision to hide the view.
- (BOOL)isViewHiddenWithViewModel:(TPLViewModel *)viewModel;

// public, final.
@property(nonatomic, copy) NSString *name;

@property(nonatomic) UIControlEvents activatedControlEvents;

@property(nonatomic, readonly) NSMutableArray<TPLViewModifierAndValue *> *modifiers;

// private, virtual. overrides must call super's implementation.
- (void)addDescriptionToFormatter:(TPLViewDescriptorFormatter *)formatter;

@property(nonatomic) TPLValueProvider *accessibility;  // of TPLAccessibility.
@property(nonatomic) TPLValueProvider *backgroundColor;  // of UIColor.
@property(nonatomic) TPLValueProvider *cornerRadius;  // of NSNumber.
@property(nonatomic) TPLValueProvider *height;  // of NSNumber of CGFloat.
@property(nonatomic) TPLValueProvider *hidden;  // of NSNumber of BOOL.
@property(nonatomic) TPLValueProvider *position;  // of NSNumber of TPLAlignment.
@property(nonatomic) TPLValueProvider *size;  // of NSValue of CGSize.
@property(nonatomic) TPLValueProvider *tag;  // of NSNumber of NSInteger.
@property(nonatomic) TPLValueProvider *width;  // of NSNumber of CGFloat.

@property(nonatomic, getter=isRTLEnabled) BOOL RTLEnabled;
@property(nonatomic, getter=isTapEnabled) BOOL tapEnabled;
@property(nonatomic, getter=isHorizontalShrinkEnabled) BOOL horizontalShrinkEnabled;
@property(nonatomic, getter=isHorizontalStretchEnabled) BOOL horizontalStretchEnabled;
@property(nonatomic, getter=isVerticalShrinkEnabled) BOOL verticalShrinkEnabled;
@property(nonatomic, getter=isVerticalStretchEnabled) BOOL verticalStretchEnabled;

@end


@interface TPLViewModifierAndValue : NSObject

@property(nonatomic) id<TPLViewModifier> modifier;
@property(nonatomic) TPLValueProvider *value;

- (instancetype)initWithModifier:(id<TPLViewModifier>)modifier value:(TPLValueProvider *)value;

@end


@interface TPLViewDescriptorFormatter : NSObject

- (void)indent;
- (void)unindent;
- (void)wrap;
- (void)appendString:(NSString *)string;
- (void)appendSubdescriptorDescriptionWithBlock:(void(^)())block;
- (NSString *)string;

@end


@interface UIView (TPLViewDescriptor)

@property(nonatomic, strong) TPLViewDescriptor *tpl_descriptor;

@end
