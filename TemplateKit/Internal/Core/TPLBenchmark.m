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

#import "Internal/Core/TPLBenchmark.h"

#if TPL_BENCHMARK_LEVEL > 0
BOOL TPLLogBenchmark(int level, uint64_t start, uint64_t end, Class aClass, NSString *message) {
  uint64_t elapsed = end - start;
  mach_timebase_info_data_t timeBaseInfo;
  mach_timebase_info(&timeBaseInfo);
  uint64_t elapsedNanoSeconds = elapsed * timeBaseInfo.numer / timeBaseInfo.denom;
  NSLog(@"TemplateKit benchmark: %@ %@ took %0.3f ms",
        aClass, message, elapsedNanoSeconds / 1000000.0);
  return YES;
}
#endif
