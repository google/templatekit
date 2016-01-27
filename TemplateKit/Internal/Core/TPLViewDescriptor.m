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

#import "Internal/Core/TPLViewDescriptor.h"

#import <objc/runtime.h>

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Public/Core/TPLAccessibility.h"
#import "Public/Core/TPLDebugger.h"
#import "Public/Core/TPLSettings.h"
#import "Public/Core/TPLViewModifier.h"


@implementation TPLViewDescriptor

- (instancetype)init {
  self = [super init];
  if (self) {
    _name = NSStringFromClass([self class]);
    _modifiers = [[NSMutableArray alloc] init];
    _RTLEnabled = YES;
  }
  return self;
}

+ (instancetype)descriptor {
  return [[self alloc] init];
}

- (UIView *)view {
  UIView *view = [self uninitializedView];
  view.tpl_descriptor = self;

  if ([TPLDebugger isBorderingEnabled]) {
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.f;
  }

  return view;
}

- (UIView *)uninitializedView {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void)populateView:(UIView *)view withViewModel:(TPLViewModel *)viewModel {
  view.hidden = [self isViewHiddenWithViewModel:viewModel];

  if (_accessibility) {
    TPLAccessibility *accessibility = [_accessibility objectWithViewModel:viewModel];
    view.isAccessibilityElement = accessibility.accessible;
    view.accessibilityLabel = accessibility.label;
    view.accessibilityHint = accessibility.hint;
  }

  if (_activatedControlEvents) {
    if (UIControlEventValueChanged & _activatedControlEvents) {
      [DOWNCAST(view, UIControl) addTarget:viewModel
                                    action:@selector(__didFireValueChanged:)
                          forControlEvents:UIControlEventValueChanged];
    }
    if (UIControlEventTouchUpInside & _activatedControlEvents) {
      [DOWNCAST(view, UIControl) addTarget:viewModel
                                    action:@selector(__didFireTouchUpInside:)
                          forControlEvents:UIControlEventTouchUpInside];
    }
  }

  if (_backgroundColor) {
    view.backgroundColor = [_backgroundColor objectWithViewModel:viewModel];
  }

  if (_cornerRadius) {
    view.layer.cornerRadius = [_cornerRadius CGFloatValueWithViewModel:viewModel];
  }

  if (_tag) {
    view.tag = [_tag integerValueWithViewModel:viewModel];
  }

  if (_tapEnabled) {
    if ([view isKindOfClass:[UIControl class]]) {
      [DOWNCAST(view, UIControl) addTarget:viewModel
                                    action:@selector(__didFireTouchUpInside:)
                          forControlEvents:UIControlEventTouchUpInside];
    } else {
      UITapGestureRecognizer *tapRecognizer =
          [[UITapGestureRecognizer alloc] initWithTarget:viewModel
                                                  action:@selector(__didRecognizeTapGesture:)];
      [view addGestureRecognizer:tapRecognizer];
      view.userInteractionEnabled = YES;
    }
  }

  for (TPLViewModifierAndValue *pair in _modifiers) {
    if ([pair.modifier respondsToSelector:@selector(modifyView:withValue:)]) {
      id value = [pair.value objectWithViewModel:viewModel];
      [pair.modifier modifyView:view withValue:value];
    }
  }

  [view setNeedsLayout];
}

- (CGSize)viewSizeThatFits:(CGSize)size withViewModel:(TPLViewModel *)viewModel {
  CGSize result = [self intrinsicViewSizeThatFits:size withViewModel:viewModel];
  if (_size) {
    result = [_size CGSizeValueWithViewModel:viewModel];
  }
  if (_height) {
    result.height = [_height CGFloatValueWithViewModel:viewModel];
  }
  if (_width) {
    result.width = [_width CGFloatValueWithViewModel:viewModel];
  }
  return result;
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel {
  [self doesNotRecognizeSelector:_cmd];
  return CGSizeZero;
}

- (BOOL)isViewHiddenWithViewModel:(TPLViewModel *)viewModel {
  if (_hidden) {
    return [_hidden boolValueWithViewModel:viewModel];
  } else {
    return NO;
  }
}

- (void)addDescriptionToFormatter:(TPLViewDescriptorFormatter *)formatter {
  [formatter appendString:[NSString stringWithFormat:@"%@ [%p]", self.name, self]];
}

- (NSString *)description {
  TPLViewDescriptorFormatter *formatter = [[TPLViewDescriptorFormatter alloc] init];
  [self addDescriptionToFormatter:formatter];
  return [formatter string];
}

@end


@implementation TPLViewModifierAndValue

- (instancetype)initWithModifier:(id<TPLViewModifier>)modifier value:(TPLValueProvider *)value {
  self = [super init];
  if (self) {
    _modifier = modifier;
    _value = value;
  }
  return self;
}

@end


@implementation TPLViewDescriptorFormatter {
  NSMutableArray *_buffer;
  NSInteger _indentLevel;
  BOOL _isNewLine;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _buffer = [[NSMutableArray alloc] init];
    _indentLevel = 0;
    _isNewLine = YES;
  }
  return self;
}

- (void)indent {
  _indentLevel++;
}

- (void)unindent {
  _indentLevel--;
}

- (void)wrap {
  [_buffer addObject:@"\n"];
  _isNewLine = YES;
}

- (void)appendString:(NSString *)string {
  if (_isNewLine) {
    [_buffer addObject:[[self class] spaceWithLength:_indentLevel * 4]];
    _isNewLine = NO;
  }
  [_buffer addObject:string];
}

- (void)appendSubdescriptorDescriptionWithBlock:(void(^)())block {
  [self indent];
  [self wrap];
  block();
  [self unindent];
}

- (NSString *)string {
  return[_buffer componentsJoinedByString:@""];
}

+ (NSString *)spaceWithLength:(NSInteger)length {
  NSMutableArray *components = [[NSMutableArray alloc] init];
  for (NSInteger i = 0; i < length; ++i) {
    [components addObject:@" "];
  }
  return [components componentsJoinedByString:@""];
}

@end


static const void *kTPLDescriptorKey;

@implementation UIView (TPLViewDescriptor)

- (TPLViewDescriptor *)tpl_descriptor {
  return objc_getAssociatedObject(self, &kTPLDescriptorKey);
}

- (void)setTpl_descriptor:(TPLViewDescriptor *)descriptor {
  objc_setAssociatedObject(self,
                           &kTPLDescriptorKey,
                           descriptor,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
