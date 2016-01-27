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


#if DEBUG
id CheckInheritance(id obj, Class aClass);
#define DOWNCAST(obj__, class__) ((class__ *)CheckInheritance(obj__, [class__ class]))
#else
#define DOWNCAST(obj__, class__) ((class__ *)obj__)
#endif

#if DEBUG
id CheckProtocolConformance(id obj, Protocol *proto);
#define DOWNCAST_P(obj__, proto__) ((id)CheckProtocolConformance(obj__, @protocol(proto__)))
#else
#define DOWNCAST_P(obj__, proto__) ((id)obj__)
#endif


#if DEBUG
void CheckNonnull(id obj);
#define CHECK_NONNULL(obj__) CheckNonnull(obj__)
#else
#define CHECK_NONNULL(obj__)
#endif
