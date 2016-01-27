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

#import "Internal/DSL/TPLBuilderUtil.h"

#import "Internal/Core/TPLViewDescriptor.h"


@implementation TPLBuilderUtil

+ (void)propagatePropertiesToDescriptor:(TPLViewDescriptor *)descriptor
                     fromSubdescriptors:(NSArray *)subdescriptors {
  BOOL horizontalShrinkEnabled = NO;
  BOOL horizontalStretchEnabled = NO;
  BOOL verticalStrechEnabled = NO;
  for (TPLViewDescriptor *subdescriptor in subdescriptors) {
    if (subdescriptor.horizontalShrinkEnabled) {
      // TODO: Row, column and repeated may want different behaviors. AND or OR?
      horizontalShrinkEnabled = YES;
    }
    if (subdescriptor.horizontalStretchEnabled) {
      // TODO: Row, column and repeated may want different behaviors. AND or OR?
      horizontalStretchEnabled = YES;
    }
    if (subdescriptor.verticalStretchEnabled) {
      verticalStrechEnabled = YES;
    }
  }
  descriptor.horizontalShrinkEnabled = horizontalShrinkEnabled;
  descriptor.horizontalStretchEnabled = horizontalStretchEnabled;
  descriptor.verticalStretchEnabled = verticalStrechEnabled;
}

@end
