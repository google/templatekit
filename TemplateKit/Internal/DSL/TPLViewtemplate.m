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

#import "Internal/DSL/TPLViewTemplate+Internal.h"

#import "Internal/Core/TPLBenchmark.h"
#import "Internal/Core/TPLRootViewDescriptor.h"
#import "Internal/Core/TPLViewDescriptor.h"
#import "Internal/DSL/TPLBuilder+Internal.h"
#import "Internal/DSL/TPLBuilderUtil.h"
#import "Public/DSL/TPLBuilderFactoryExtension.h"


@implementation TPLViewTemplate

- (CGSize)viewSizeThatFits:(CGSize)size withViewModel:(TPLViewModel *)viewModel {
  return [_rootDescriptor viewSizeThatFits:size
                             withViewModel:viewModel];
}

- (NSString *)description {
  return [_rootDescriptor description];
}

@end

TPLViewTemplate *TPLInstantiateViewTemplate(NSString *name, TPLViewTemplateDefinerPointer definer) {
  TPLBuilderFactory *builderFactory = [[TPLBuilderFactory alloc] init];
  TPLBuilderFactoryExtension *extension = [[TPLBuilderFactoryExtension alloc] init];
  TPLBuilderOptions *options = [[TPLBuilderOptions alloc] init];
  TPLBuilder *builder = definer(builderFactory.activity_indicator,
                                builderFactory.bind,
                                @(TPLAlignmentBottom),
                                @(TPLAlignmentBottomLeft),
                                @(TPLAlignmentBottomRight),
                                @(TPLAlignmentCenter),
                                builderFactory.column,
                                builderFactory.cond,
                                extension,
                                builderFactory.grid,
                                builderFactory.image,
                                @(TPLAlignmentJustify),
                                builderFactory.label,
                                builderFactory.layer,
                                @(TPLAlignmentLeft),
                                builderFactory.margin,
                                options,
                                builderFactory.repeated,
                                @(TPLAlignmentRight),
                                builderFactory.row,
                                builderFactory.space,
                                @(TPLAlignmentTop),
                                @(TPLAlignmentTopLeft),
                                @(TPLAlignmentTopRight));
  TPLViewDescriptor *descriptor = builder.descriptor;
  TPLRootViewDescriptor *rootDescriptor = [[TPLRootViewDescriptor alloc] init];
  rootDescriptor.subdescriptor = descriptor;
  rootDescriptor.posteditEnabled = options.posteditEnabled;
  [TPLBuilderUtil propagatePropertiesToDescriptor:rootDescriptor
                              fromSubdescriptors:@[ descriptor ]];
  
  TPLViewTemplate *template = [[TPLViewTemplate alloc] init];
  template.rootDescriptor = rootDescriptor;
  return template;
}
