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

#import "Public/Core/TPLRootView.h"
#import "Public/DSL/TPLBuilder.h"

@class TPLViewModel;

#ifdef __cplusplus
extern "C" {
#endif

@interface TPLViewTemplate : NSObject

- (CGSize)viewSizeThatFits:(CGSize)size withViewModel:(TPLViewModel *)viewModel;

@end

typedef TPLBuilder *(TPLViewTemplateDefiner)(const TPLBuilderBlock1 activity_indicator,
                                             const TPLSelectorWrapperBlock bind,
                                             NSNumber *const bottom,
                                             NSNumber *const bottom_left,
                                             NSNumber *const bottom_right,
                                             NSNumber *const center,
                                             const TPLBuilderBlockVariadic column,
                                             const TPLBuilderCondBlock cond,
                                             TPLBuilderFactoryExtension *const ext,
                                             const TPLBuilderGridBlock grid,
                                             const TPLBuilderBlock1 image,
                                             NSNumber *const justify,
                                             const TPLBuilderBlock1 label,
                                             const TPLBuilderBlockVariadic layer,
                                             NSNumber *const left,
                                             const TPLBuilderBlock1 margin,
                                             TPLBuilderOptions *const options,
                                             const TPLBuilderBlock1 repeated,
                                             NSNumber *const right,
                                             const TPLBuilderBlockVariadic row,
                                             const TPLBuilderBlock1 space,
                                             NSNumber *const top,
                                             NSNumber *const top_left,
                                             NSNumber *const top_right);

typedef TPLViewTemplateDefiner *TPLViewTemplateDefinerPointer;

TPLViewTemplate *TPLInstantiateViewTemplate(NSString *name, TPLViewTemplateDefinerPointer definer);

#ifdef __cplusplus
}
#endif
