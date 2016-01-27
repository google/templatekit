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

#include <mach/mach_time.h>

#import <UIKit/UIKit.h>

#ifndef TPL_BENCHMARK_LEVEL
#define TPL_BENCHMARK_LEVEL 0
#endif

#if TPL_BENCHMARK_LEVEL > 0
BOOL TPLLogBenchmark(int level, uint64_t start, uint64_t end, Class aClass, NSString *message);
#define TPL_BENCHMARK_TIME(l____) (TPL_BENCHMARK_LEVEL >= l____ ? mach_absolute_time() : 1)
#define TPL_BENCHMARK(l__, m__, o__) for (uint64_t c__ = 0, e__ = 0, s__ = TPL_BENCHMARK_TIME(l__); c__ < 1; ++c__ && (e__ = TPL_BENCHMARK_TIME(l__)) && (TPL_BENCHMARK_LEVEL >= l__) && TPLLogBenchmark(l__, s__, e__, [o__ class], @#m__))
#else
#define TPL_BENCHMARK(...)
#endif
