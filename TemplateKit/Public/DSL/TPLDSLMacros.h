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
#import "Public/DSL/TPLBuilder.h"
#import "Public/DSL/TPLBuilderFactoryExtension.h"
#import "Public/DSL/TPLViewTemplate.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - View Template

typedef TPLBuilder *(^TPLBuilderFactoryTemplateBlock)(id);
TPLBuilderFactoryTemplateBlock
TPLBuilderFactoryTemplateBlockCreate(NSString *name,
                                     Class viewClass,
                                     TPLViewTemplateDefinerPointer definer);

#define TPL_INTERNAL_DEFINE_VIEW_TEMPLATE_COMMON(name__, view_class__) \
  @interface TPLBuilderFactoryExtension (template_definition_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end \
  \
  @implementation TPLBuilderFactoryExtension (template_definition_##name__) \
  - (TPLBuilder *(^)(id))name__ { \
    return TPLBuilderFactoryTemplateBlockCreate(@#name__, \
                                                [view_class__ class], \
                                                TPLDefineViewTemplate_##name__); \
  } \
  @end \
  \
  TPLBuilder *TPLDefineViewTemplate_##name__(const TPLBuilderBlock1 activity_indicator, \
                                             const TPLSelectorWrapperBlock bind, \
                                             NSNumber *const bottom, \
                                             NSNumber *const bottom_left, \
                                             NSNumber *const bottom_right, \
                                             NSNumber *const center, \
                                             const TPLBuilderBlockVariadic column, \
                                             const TPLBuilderCondBlock cond, \
                                             TPLBuilderFactoryExtension *const ext, \
                                             const TPLBuilderGridBlock grid, \
                                             const TPLBuilderBlock1 image, \
                                             NSNumber *const justify, \
                                             const TPLBuilderBlock1 label, \
                                             const TPLBuilderBlockVariadic layer, \
                                             NSNumber *const left, \
                                             const TPLBuilderBlock1 margin, \
                                             TPLBuilderOptions *const options, \
                                             const TPLBuilderBlock1 repeated, \
                                             NSNumber *const right, \
                                             const TPLBuilderBlockVariadic row, \
                                             const TPLBuilderBlock1 space, \
                                             NSNumber *const top, \
                                             NSNumber *const top_left, \
                                             NSNumber *const top_right)

#define TPL_INTERNAL_DEFINE_VIEW_TEMPLATE_1(name__) \
  TPLViewTemplateDefiner TPLDefineViewTemplate_##name__; \
  TPL_INTERNAL_DEFINE_VIEW_TEMPLATE_COMMON(name__, TPLRootView)

#define TPL_INTERNAL_DEFINE_VIEW_TEMPLATE_2(name__, view_class__) \
  TPLViewTemplateDefiner TPLDefineViewTemplate_##name__; \
  \
  @implementation view_class__ (template_association_##name__) \
  + (TPLViewTemplateDefinerPointer)viewTemplateDefiner { \
    return TPLDefineViewTemplate_##name__; \
  } \
  @end \
  \
  TPL_INTERNAL_DEFINE_VIEW_TEMPLATE_COMMON(name__, view_class__)

#define TPL_INTERNAL_RESOLVE_DEFINE_VIEW_TEMPLATE(unused1__, unused2__, func__, ...) func__

#define TPL_DEFINE_VIEW_TEMPLATE(...) \
  TPL_INTERNAL_RESOLVE_DEFINE_VIEW_TEMPLATE(__VA_ARGS__, TPL_INTERNAL_DEFINE_VIEW_TEMPLATE_2, TPL_INTERNAL_DEFINE_VIEW_TEMPLATE_1)(__VA_ARGS__)

#define TPL_INSTANTIATE_VIEW_TEMPLATE(name__) \
  TPLInstantiateViewTemplate(@#name__, TPLDefineViewTemplate_##name__)

#pragma mark - Adapters

typedef TPLBuilder *(^TPLBuilderSimpleViewBlock)();
TPLBuilderSimpleViewBlock TPLBuilderSimpleViewBlockCreate(NSString *name, Class adapterClass);

typedef TPLBuilder *(^TPLBuilderDataViewBlock)(id);
TPLBuilderDataViewBlock TPLBuilderDataViewBlockCreate(NSString *name, Class adapterClass);

typedef TPLBuilder *(^TPLBuilderImmutableDataViewBlock)(id);
TPLBuilderImmutableDataViewBlock TPLBuilderImmutableDataViewBlockCreate(NSString *name,
                                                                        Class adapterClass);

#define TPL_DEFINE_SIMPLE_VIEW_ADAPTER(name__, adapter_class__) \
  @interface TPLBuilderFactoryExtension (simple_adapter_definition_##name__) \
  - (TPLBuilder *(^)())name__; \
  @end \
  \
  @implementation TPLBuilderFactoryExtension (simple_adapter_definition_##name__) \
  - (TPLBuilder *(^)())name__ { \
    return TPLBuilderSimpleViewBlockCreate(@#name__, [adapter_class__ class]); \
  } \
  @end

#define TPL_DEFINE_DATA_VIEW_ADAPTER(name__, adapter_class__) \
  @interface TPLBuilderFactoryExtension (data_adapter_definition_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end \
  \
  @implementation TPLBuilderFactoryExtension (data_adapter_definition_##name__) \
  - (TPLBuilder *(^)(id))name__ { \
    return TPLBuilderDataViewBlockCreate(@#name__, [adapter_class__ class]); \
  } \
  @end

#define TPL_DEFINE_IMMUTABLE_DATA_VIEW_ADAPTER(name__, adapter_class__) \
  @interface TPLBuilderFactoryExtension (immutable_data_adapter_definition_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end \
  \
  @implementation TPLBuilderFactoryExtension (immutable_data_adapter_definition_##name__) \
  - (TPLBuilder *(^)(id))name__ { \
  return TPLBuilderImmutableDataViewBlockCreate(@#name__, [adapter_class__ class]); \
  } \
  @end

#pragma mark - Modifiers

typedef TPLBuilder *(^TPLBuilderModifierBlock)(id);
TPLBuilderModifierBlock TPLBuilderModifierBlockCreate(TPLBuilder *builder, Class modifierClass);

#define TPL_DEFINE_VIEW_MODIFIER(name__, modifler_class__) \
  @interface TPLBuilder (modifier_definition_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end \
  \
  @implementation TPLBuilder (modifier_definition_##name__) \
  - (TPLBuilder *(^)(id))name__ { \
    return TPLBuilderModifierBlockCreate(self, [modifler_class__ class]); \
  } \
  @end

#pragma mark - Utilities

#ifndef TPL_ENABLE_DOLLER_SIGN_AS_SELECTOR_BINDER
#define TPL_ENABLE_DOLLER_SIGN_AS_SELECTOR_BINDER 0
#endif

#if TPL_ENABLE_DOLLER_SIGN_AS_SELECTOR_BINDER
#define $(__) bind(@selector(__))
#endif

#ifdef __cplusplus
}
#endif
