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

#import "Internal/DSL/TPLBuilder+Internal.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewDescriptor.h"
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Internal/DescriptorImpls/TPLActivityIndicatorDescriptor.h"
#import "Internal/DescriptorImpls/TPLColumnLayout.h"
#import "Internal/DescriptorImpls/TPLSelectViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLGridDescriptor.h"
#import "Internal/DescriptorImpls/TPLImageDescriptor.h"
#import "Internal/DescriptorImpls/TPLLabelDescriptor.h"
#import "Internal/DescriptorImpls/TPLRepeatedDescriptor.h"
#import "Internal/DescriptorImpls/TPLRowLayout.h"
#import "Internal/DescriptorImpls/TPLSpaceDescriptor.h"
#import "Internal/DSL/TPLBuilderUtil.h"
#import "Internal/DSL/TPLViewTemplate+Internal.h"
#import "Public/Core/TPLAccessibility.h"
#import "Public/Core/TPLConstants.h"
#import "Public/DescriptorImpls/TPLGridConfig.h"
#import "Public/DescriptorImpls/TPLLayoutConfig.h"

#if DEBUG
void ThrowUnrecognizedTypeException(id object) {
  NSString *reason = [NSString stringWithFormat:@"Type %@ is not recognized", [object class]];
  NSException *exeption =
      [NSException exceptionWithName:@"TPLUnrecognizedTypeException"
                              reason:reason
                            userInfo:nil];
  @throw exeption;
}
#define TYPE_ERROR(__obj) ThrowUnrecognizedTypeException(__obj)
#else
#define TYPE_ERROR(__obj)
#endif

@implementation TPLBuilderOptions {
  BOOL _posteditEnabled;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    __weak TPLBuilderOptions *weakSelf = self;

    _posteditEnabled = NO;

    _postedit = [^(BOOL enabled) {
      weakSelf.posteditEnabled = enabled;
    } copy];
  }
  return self;
}

@end

@implementation TPLBuilderFactory

- (instancetype)init {
  self = [super init];
  if (self) {
    _activity_indicator = [^(id arg) {
      TPLActivityIndicatorDescriptor *descriptor = [TPLActivityIndicatorDescriptor descriptor];
      descriptor.name = @"activity_indicator";
      if ([arg isKindOfClass:[TPLActivityIndicatorDescriptor class]]) {
        descriptor.data = [TPLValueProvider providerWithConstant:arg];
      } else if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
        descriptor.data =
            [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector];
      } else {
        TYPE_ERROR(arg);
      }
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];

    _bind = [^(SEL selector) {
      return [[TPLSelectorWrapper alloc] initWithSelector:selector];
    } copy];

    _column = [^(id firstChild, ...) {
      va_list args;
      va_start(args, firstChild);
      NSMutableArray *subbuilders = [[NSMutableArray alloc] init];
      for (TPLBuilder *builder = firstChild; builder != nil; builder = va_arg(args, TPLBuilder *)) {
        [subbuilders addObject:builder];
      }
      TPLValueProvider *layoutConfigProvider =
          [TPLValueProvider providerWithConstant:[TPLLayoutConfig defaultColumnLayoutConfig]];
      TPLBuilder *builder =
          [TPLBuilderFactory compositeBuilderWithSubbuilders:subbuilders
                                        layoutConfigProvider:layoutConfigProvider
                                                        name:@"column"
                                                   direction:TPLDirectionVertical];
      return builder;
    } copy];

    _cond = [^(TPLSelectorWrapper *conditionSelector,
                TPLBuilder *thenBuilder,
                TPLBuilder *elseBuilder) {
      TPLBinarySelectViewDescriptor *descriptor = [TPLBinarySelectViewDescriptor descriptor];
      descriptor.name = @"cond";
      descriptor.condition = [TPLValueProvider providerWithSelector:conditionSelector.selector];
      descriptor.thenDescriptor = thenBuilder.descriptor;
      descriptor.elseDescriptor = elseBuilder.descriptor;
      [TPLBuilderUtil propagatePropertiesToDescriptor:descriptor
                                  fromSubdescriptors:@[ descriptor.thenDescriptor,
                                                        descriptor.elseDescriptor ]];
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];

    _grid = [^(TPLBuilder *child) {
      TPLGridDescriptor *descriptor = [TPLGridDescriptor descriptor];
      TPLViewDescriptor<TPLContentViewDescriptor> *subdescriptor =
          DOWNCAST_P(child.descriptor, TPLContentViewDescriptor);
      descriptor.name = @"grid";
      descriptor.subdescriptor = subdescriptor;
      // TODO: Uncomment this.
//      [TPLBuilderUtil propagatePropertiesToDescriptor:descriptor
//                                  fromSubdescriptors:@[ subdescriptor ]];
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];

    _image = [^(id arg) {
      TPLImageDescriptor *descriptor = [TPLImageDescriptor descriptor];
      descriptor.name = @"image";
      if ([arg isKindOfClass:[UIImage class]]) {
        descriptor.data = [TPLValueProvider providerWithConstant:arg];
      } else if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
        descriptor.data =
            [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector];
      } else {
        TYPE_ERROR(arg);
      }
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];

    _label = [^(id arg){
      TPLLabelDescriptor *descriptor = [TPLLabelDescriptor descriptor];
      descriptor.name = @"label";
      if ([arg isKindOfClass:[NSString class]] ||
          [arg isKindOfClass:[NSAttributedString class]] ||
          [arg isKindOfClass:[TPLLabelData class]]) {
        descriptor.data = [TPLValueProvider providerWithConstant:arg];
      } else if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
        descriptor.data =
            [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector];
      } else {
        TYPE_ERROR(arg);
      }
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];

    _layer = [^(id firstChild, ...) {
      va_list args;
      va_start(args, firstChild);
      NSMutableArray *subbuilders = [[NSMutableArray alloc] init];
      for (TPLBuilder *builder = firstChild; builder != nil; builder = va_arg(args, TPLBuilder *)) {
        [subbuilders addObject:builder];
      }
      subbuilders = [[[subbuilders reverseObjectEnumerator] allObjects] mutableCopy];
      TPLValueProvider *layoutConfigProvider =
          [TPLValueProvider providerWithConstant:[TPLLayoutConfig defaultLayerLayoutConfig]];
      return [TPLBuilderFactory compositeBuilderWithSubbuilders:subbuilders
                                           layoutConfigProvider:layoutConfigProvider
                                                           name:@"layer"
                                                      direction:TPLDirectionHorizontal];
    } copy];

    _margin = [^(id arg) {
      TPLSpaceDescriptor *descriptor = [TPLSpaceDescriptor descriptor];
      descriptor.name = @"margin";
      descriptor.shouldAlwaysShow = NO;
      if ([arg isKindOfClass:[NSNumber class]]) {
        descriptor.length = DOWNCAST(arg, NSNumber);
      } else if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
        descriptor.lengthSelector = DOWNCAST(arg, TPLSelectorWrapper).selector;
      } else {
        TYPE_ERROR(arg);
      }
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];

    _repeated = [^(id arg) {
      TPLRepeatedDescriptor *descriptor = [TPLRepeatedDescriptor descriptor];
      descriptor.name = @"repeated";
      TPLBuilder *subbuilder = DOWNCAST(arg, TPLBuilder);
      TPLViewDescriptor<TPLContentViewDescriptor> *subdescriptor =
          DOWNCAST_P(subbuilder.descriptor, TPLContentViewDescriptor);
      descriptor.subdescriptor = subdescriptor;
      [TPLBuilderUtil propagatePropertiesToDescriptor:descriptor
                                  fromSubdescriptors:@[ subdescriptor ]];
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];

    _row = [^(id firstChild, ...) {
      va_list args;
      va_start(args, firstChild);
      NSMutableArray *subbuilders = [[NSMutableArray alloc] init];
      for (TPLBuilder *builder = firstChild; builder != nil; builder = va_arg(args, TPLBuilder *)) {
        [subbuilders addObject:builder];
      }
      TPLValueProvider *layoutConfigProvider =
          [TPLValueProvider providerWithConstant:[TPLLayoutConfig defaultRowLayoutConfig]];
      return [TPLBuilderFactory compositeBuilderWithSubbuilders:subbuilders
                                           layoutConfigProvider:layoutConfigProvider
                                                           name:@"row"
                                                      direction:TPLDirectionHorizontal];
    } copy];

    _space = [^(id arg) {
      TPLSpaceDescriptor *descriptor = [TPLSpaceDescriptor descriptor];
      descriptor.name = @"space";
      descriptor.shouldAlwaysShow = YES;
      if ([arg isKindOfClass:[NSNumber class]]) {
        descriptor.length = DOWNCAST(arg, NSNumber);
      } else if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
        descriptor.lengthSelector = DOWNCAST(arg, TPLSelectorWrapper).selector;
      } else {
        TYPE_ERROR(arg);
      }
      return [TPLBuilder builderWithDescriptor:descriptor];
    } copy];
  }
  return self;
}

+ (TPLBuilder *)compositeBuilderWithSubbuilders:(NSArray *)subbuilders
                           layoutConfigProvider:(TPLValueProvider *)layoutConfigProvider
                                           name:(NSString *)name
                                      direction:(TPLDirection)direction {
  NSMutableArray *subdescriptors = [[NSMutableArray alloc] init];
  for (TPLBuilder *builder in subbuilders) {
    if ([builder.descriptor isKindOfClass:[TPLRepeatedDescriptor class]]) {
      DOWNCAST(builder.descriptor, TPLRepeatedDescriptor).direction = direction;
    } else if ([builder.descriptor isKindOfClass:[TPLSpaceDescriptor class]]) {
      DOWNCAST(builder.descriptor, TPLSpaceDescriptor).direction = direction;
    }
    [subdescriptors addObject:builder.descriptor];
  }
  TPLCompositeViewDescriptor *descriptor = [TPLCompositeViewDescriptor descriptor];
  descriptor.name = name;
  descriptor.layoutConfig = layoutConfigProvider;
  [TPLBuilderUtil propagatePropertiesToDescriptor:descriptor fromSubdescriptors:subdescriptors];
  descriptor.subdescriptors = subdescriptors;
  return [TPLBuilder builderWithDescriptor:descriptor];
}

@end


@implementation TPLBuilder

- (instancetype)initWithDescriptor:(TPLViewDescriptor *)descriptor {
  self = [super init];
  if (self) {
    _descriptor = descriptor;
    __weak TPLBuilder *weakSelf = self;

#define DEFINE_VIEW_ATTRIBUTE0(name__, descriptor_property__, value__) \
  do { \
    _##name__ = [^() { \
      weakSelf.descriptor.descriptor_property__ = value__; \
      return weakSelf; \
    } copy]; \
  } while (0)

    DEFINE_VIEW_ATTRIBUTE0(h_shrinkable, horizontalShrinkEnabled, YES);
    DEFINE_VIEW_ATTRIBUTE0(h_stretchable, horizontalStretchEnabled, YES);
    DEFINE_VIEW_ATTRIBUTE0(no_rtl, RTLEnabled, NO);
    TPLValueProvider *notAccessibleProvider =
        [TPLValueProvider providerWithConstant:[TPLAccessibility notAccessible]];
    DEFINE_VIEW_ATTRIBUTE0(not_accessible, accessibility, notAccessibleProvider);
    DEFINE_VIEW_ATTRIBUTE0(tappable, tapEnabled, YES);
    DEFINE_VIEW_ATTRIBUTE0(v_stretchable, verticalStretchEnabled, YES);

#undef DEFINE_VIEW_ATTRIBUTE0

#define DEFINE_VIEW_ATTRIBUTE1(name__, value_type__, descriptor_type__, descriptor_property__) \
  do { \
    _##name__ = [^(id arg) { \
      descriptor_type__ *desc = DOWNCAST(weakSelf.descriptor, descriptor_type__); \
      if ([arg isKindOfClass:[value_type__ class]]) { \
        desc.descriptor_property__ = [TPLValueProvider providerWithConstant:arg]; \
      } else if ([arg isKindOfClass:[TPLSelectorWrapper class]]) { \
        desc.descriptor_property__ = \
            [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector]; \
      } \
      return weakSelf; \
    } copy]; \
  } while (0)

    DEFINE_VIEW_ATTRIBUTE1(align, NSNumber, TPLCompositeViewDescriptor, subviewAlignment);
    DEFINE_VIEW_ATTRIBUTE1(accessible, NSNumber, TPLViewDescriptor, accessibility);
    DEFINE_VIEW_ATTRIBUTE1(background_color, UIColor, TPLViewDescriptor, backgroundColor);
    DEFINE_VIEW_ATTRIBUTE1(corner_radius, NSNumber, TPLViewDescriptor, cornerRadius);
    DEFINE_VIEW_ATTRIBUTE1(grid_config, TPLGridConfig, TPLGridDescriptor, config);
    DEFINE_VIEW_ATTRIBUTE1(height, NSNumber, TPLViewDescriptor, height);
    DEFINE_VIEW_ATTRIBUTE1(hidden, NSNumber, TPLViewDescriptor, hidden);
    DEFINE_VIEW_ATTRIBUTE1(interval, NSNumber, TPLRepeatedDescriptor, interval);
    DEFINE_VIEW_ATTRIBUTE1(layout_config, TPLLayoutConfig, TPLCompositeViewDescriptor, layoutConfig);
    DEFINE_VIEW_ATTRIBUTE1(padding, NSValue, TPLCompositeViewDescriptor, padding);
    DEFINE_VIEW_ATTRIBUTE1(position, NSNumber, TPLViewDescriptor, position);
    DEFINE_VIEW_ATTRIBUTE1(size, NSValue, TPLViewDescriptor, size);
    DEFINE_VIEW_ATTRIBUTE1(tag, NSNumber, TPLViewDescriptor, tag);
    DEFINE_VIEW_ATTRIBUTE1(width, NSNumber, TPLViewDescriptor, width);

#undef DEFINE_VIEW_ATTRIBUTE1
  }
  return self;
}

+ (instancetype)builderWithDescriptor:(TPLViewDescriptor *)descriptor {
  return [[self alloc] initWithDescriptor:descriptor];
}

@end

@implementation TPLSelectorWrapper

- (instancetype)initWithSelector:(SEL)selector {
  self = [super init];
  if (self) {
    _selector = selector;
  }
  return self;
}

@end
