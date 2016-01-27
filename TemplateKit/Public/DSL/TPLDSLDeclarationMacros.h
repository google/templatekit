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

#import "Public/DSL/TPLBuilder.h"
#import "Public/DSL/TPLBuilderFactoryExtension.h"
#import "Public/DSL/TPLViewTemplate.h"

#define TPL_DECLARE_VIEW_TEMPLATE(name__) \
  @interface TPLBuilderFactoryExtension (template_declaration_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end \
  TPLViewTemplateDefiner TPLDefineViewTemplate_##name__

#define TPL_DECLARE_SIMPLE_VIEW_ADAPTER(name__) \
  @interface TPLBuilderFactoryExtension (simple_adapter_declaration_##name__) \
  - (TPLBuilder *(^)())name__; \
  @end

#define TPL_DECLARE_DATA_VIEW_ADAPTER(name__) \
  @interface TPLBuilderFactoryExtension (data_adapter_declaration_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end

#define TPL_DECLARE_IMMUTABLE_DATA_VIEW_ADAPTER(name__) \
  @interface TPLBuilderFactoryExtension (immutable_data_adapter_declaration_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end

#define TPL_DECLARE_VIEW_MODIFIER(name__) \
  @interface TPLBuilder (modifier_declaration_##name__) \
  - (TPLBuilder *(^)(id))name__; \
  @end
