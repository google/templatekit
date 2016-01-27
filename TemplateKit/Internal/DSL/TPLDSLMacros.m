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

#import "Public/DSL/TPLDSLMacros.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLRootViewDescriptor.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/DSL/TPLBuilder+Internal.h"
#import "Internal/DSL/TPLBuilderUtil.h"
#import "Internal/DSL/TPLViewTemplate+Internal.h"
#import "Internal/DescriptorImpls/TPLClientDataViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLClientImmutableDataViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLClientSimpleViewDescriptor.h"
#import "Public/Core/TPLViewModifier.h"

TPLBuilderFactoryTemplateBlock
TPLBuilderFactoryTemplateBlockCreate(NSString *name,
                                     Class viewClass,
                                     TPLViewTemplateDefinerPointer definer) {
  return ^(id arg) {
    TPLViewTemplate *template = TPLInstantiateViewTemplate(name, definer);
    TPLRootViewDescriptor *rootDescriptor = template.rootDescriptor;
    rootDescriptor.name = name;
    if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
      rootDescriptor.submodel =
          [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector];
    } else {
      rootDescriptor.submodel = [TPLValueProvider providerWithConstant:arg];
    }
    rootDescriptor.viewClass = viewClass;
    return [TPLBuilder builderWithDescriptor:rootDescriptor];
  };
}

TPLBuilderSimpleViewBlock TPLBuilderSimpleViewBlockCreate(NSString *name, Class adapterClass) {
  return ^{
    TPLClientSimpleViewDescriptor *descriptor = [TPLClientSimpleViewDescriptor descriptor];
    descriptor.name = name;
    descriptor.adapter = [[adapterClass alloc] init];
    return [TPLBuilder builderWithDescriptor:descriptor];
  };
}

TPLBuilderDataViewBlock TPLBuilderDataViewBlockCreate(NSString *name, Class adapterClass) {
  return ^(id arg) {
    TPLClientDataViewDescriptor *descriptor = [TPLClientDataViewDescriptor descriptor];
    descriptor.name = name;
    descriptor.adapter = [[adapterClass alloc] init];
    if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
      descriptor.data =
          [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector];
    } else {
      descriptor.data = [TPLValueProvider providerWithConstant:arg];
    }
    return [TPLBuilder builderWithDescriptor:descriptor];
  };
}

TPLBuilderDataViewBlock TPLBuilderImmutableDataViewBlockCreate(NSString *name, Class adapterClass) {
  return ^(id arg) {
    TPLClientImmutableDataViewDescriptor *descriptor =
        [TPLClientImmutableDataViewDescriptor descriptor];
    descriptor.name = name;
    descriptor.adapter = [[adapterClass alloc] init];
    if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
      descriptor.data =
          [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector];
    } else {
      descriptor.data = [TPLValueProvider providerWithConstant:arg];
    }
    return [TPLBuilder builderWithDescriptor:descriptor];
  };
}

TPLBuilderModifierBlock TPLBuilderModifierBlockCreate(TPLBuilder *builder, Class modifierClass) {
  return ^(id arg) {
    id<TPLViewModifier> modifier = [[modifierClass alloc] init];
    TPLValueProvider *value;
    if ([arg isKindOfClass:[TPLSelectorWrapper class]]) {
      value = [TPLValueProvider providerWithSelector:DOWNCAST(arg, TPLSelectorWrapper).selector];
    } else {
      value = [TPLValueProvider providerWithConstant:arg];
    }
    TPLViewModifierAndValue *pair =
        [[TPLViewModifierAndValue alloc] initWithModifier:modifier value:value];
    [builder.descriptor.modifiers addObject:pair];
    return builder;
  };
}
