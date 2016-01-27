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

#import "Internal/Core/TPLCoreMacros.h"

#import "Internal/Core/TPLRootViewDescriptor.h"
#import "Internal/Core/TPLViewDescriptor.h"
#import "Internal/Core/TPLViewModel+Internal.h"


id CheckInheritance(id obj, Class aClass) {
  if (obj && ![obj isKindOfClass:aClass]) {
    NSString *reason =
        [NSString stringWithFormat:@"Expected %@ but actually is %@",
         NSStringFromClass(aClass), NSStringFromClass([obj class])];
    NSException* exception =
        [NSException exceptionWithName:@"TPLDowncastFailureException"
                                reason:reason
                              userInfo:nil];
    @throw exception;
  }
  return obj;
}

id CheckProtocolConformance(id obj, Protocol *proto) {
  if (obj && ![obj conformsToProtocol:proto]) {
    NSString *reason =
        [NSString stringWithFormat:@"Expected id<%@> but actually is not",
         NSStringFromProtocol(proto)];
    NSException* exception =
        [NSException exceptionWithName:@"TPLDowncastFailureException"
                                reason:reason
                              userInfo:nil];
    @throw exception;
  }
  return obj;
}

void CheckNonnull(id obj) {
  if (!obj) {
    NSException* exception = [NSException exceptionWithName:@"TPLNullPointerException"
                                                     reason:@"Unexpected null pointer"
                                                   userInfo:nil];
    @throw exception;
  }
}
