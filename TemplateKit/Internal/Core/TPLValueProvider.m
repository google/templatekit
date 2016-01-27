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

#import "Internal/Core/TPLValueProvider.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLViewModel+Internal.h"

@implementation TPLValueProvider {
  id _constant;
  SEL _selector;
}

- (instancetype)initWithConstant:(id)constant
                        selector:(SEL)selector {
  self = [super init];
  if (self) {
    _constant = constant;
    _selector = selector;
  }
  return self;
}

+ (instancetype)providerWithConstant:(id)constant {
  return [[self alloc] initWithConstant:constant
                               selector:NULL];
}

+ (instancetype)providerWithSelector:(SEL)selector {
  return [[self alloc] initWithConstant:nil
                               selector:selector];
}

- (id)objectWithViewModel:(TPLViewModel *)viewModel {
  if (_selector) {
    if (viewModel) {
      IMP imp = [viewModel methodForSelector:_selector];
      id (*func)(TPLViewModel *, SEL) = (void *)imp;
      return func(viewModel, _selector);
    } else {
      return nil;
    }
  } else {
    return _constant;
  }
}

#define POD_VALUE_WITH_OBJECT(value_type__, zero_value__, wrapper_type__, selector__) \
  if (_selector) { \
    if (viewModel) { \
      IMP imp = [viewModel methodForSelector:_selector]; \
      value_type__ (*func)(TPLViewModel *, SEL) = (void *)imp; \
      return func(viewModel, _selector); \
    } else { \
      return zero_value__; \
    } \
  } else if ([_constant isKindOfClass:[wrapper_type__ class]]) { \
    return [DOWNCAST(_constant, wrapper_type__) selector__]; \
  } else { \
    return zero_value__; \
  }

- (BOOL)boolValueWithViewModel:(TPLViewModel *)viewModel {
  POD_VALUE_WITH_OBJECT(BOOL, NO, NSNumber, boolValue);
}

- (NSInteger)integerValueWithViewModel:(TPLViewModel *)viewModel {
  POD_VALUE_WITH_OBJECT(NSInteger, 0, NSNumber, integerValue);
}

- (CGFloat)CGFloatValueWithViewModel:(TPLViewModel *)viewModel {
#if CGFLOAT_IS_DOUBLE
  POD_VALUE_WITH_OBJECT(CGFloat, 0.f, NSNumber, doubleValue);
#else
  POD_VALUE_WITH_OBJECT(CGFloat, 0.f, NSNumber, floatValue);
#endif
}

- (CGSize)CGSizeValueWithViewModel:(TPLViewModel *)viewModel {
  POD_VALUE_WITH_OBJECT(CGSize, CGSizeZero, NSValue, CGSizeValue)
}

- (UIEdgeInsets)UIEdgeInsetsValueWithViewModel:(TPLViewModel *)viewModel {
  POD_VALUE_WITH_OBJECT(UIEdgeInsets, UIEdgeInsetsZero, NSValue, UIEdgeInsetsValue)
}

#undef POD_VALUE_WITH_OBJECT

@end
