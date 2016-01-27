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

#import "Internal/Core/TPLContentViewDescriptor.h"
#import "Internal/Core/TPLViewDescriptor.h"

@class TPLValueProvider;

// An abstract superclass of describers for views that takes
// one data object to display.
@interface TPLDataViewDescriptor : TPLViewDescriptor <TPLContentViewDescriptor>

@property(nonatomic, strong) TPLValueProvider *data;

// pure virtual.
- (void)setData:(id)data toView:(UIView *)view;

// pure virtual.
- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data;

// virtual.
// The default implementation returns NO.
- (BOOL)isViewHiddenWithData:(id)data;

- (id)dataWithViewModel:(TPLViewModel *)viewModel;

@end
