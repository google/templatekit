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

#import "Public/DSL/TPLView.h"

#import "Internal/Core/TPLBenchmark.h"
#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLRootViewDescriptor.h"
#import "Internal/Core/TPLViewDescriptor.h"
#import "Internal/DSL/TPLViewtemplate+Internal.h"


@implementation TPLView

- (instancetype)init {
  return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
  return [self initWithFrame:frame viewTemplate:[[self class] viewTemplate]];
}

- (instancetype)initWithFrame:(CGRect)frame viewTemplate:(TPLViewTemplate *)viewTemplate {
  self = [super initWithFrame:frame];
  if (self) {
    self.tpl_descriptor = viewTemplate.rootDescriptor;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  TPLRootViewDescriptor *rootDescriptor = DOWNCAST(self.tpl_descriptor, TPLRootViewDescriptor);
  if (rootDescriptor.posteditEnabled) {
    [self didLayoutSubviews];
  }
}

- (void)didLayoutSubviews {
  // no-op.
}

+ (CGSize)sizeThatFits:(CGSize)size withViewModel:(TPLViewModel *)viewModel {
  CGSize result = CGSizeZero;
  TPLViewTemplate *viewTemplate = [[self class] viewTemplate];
  TPL_BENCHMARK(1, static_size_calculation, self) {
    result = [viewTemplate viewSizeThatFits:size withViewModel:viewModel];
  }
  return result;
}

- (void)reloadViewModel {
  [self.tpl_descriptor populateView:self
                      withViewModel:self.viewModel];
  [self setNeedsLayout];
}

+ (Class)viewTemplateClass {
  [self doesNotRecognizeSelector:_cmd];
  return [NSObject class];
}

+ (TPLViewTemplateDefinerPointer)viewTemplateDefiner {
  [self doesNotRecognizeSelector:_cmd];
  return NULL;
}

+ (TPLViewTemplate *)viewTemplate {
  TPLViewTemplate *viewTemplate;
  TPL_BENCHMARK(1, template_evaluation, self) {
    TPLViewTemplateDefinerPointer definer  = [self viewTemplateDefiner];
    assert(definer);
    // FIXME: Pass name text.
    viewTemplate = TPLInstantiateViewTemplate(@"", definer);
    assert([viewTemplate isKindOfClass:[TPLViewTemplate class]]);
  }
  return viewTemplate;
}

@end
