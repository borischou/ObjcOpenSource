/**
 * Beijing Sankuai Online Technology Co.,Ltd (Meituan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#import "EZRJSVM.h"
#import <EasySequence/EasySequence.h>

@implementation EZRJSVM {
    JSContext *_context;
}

- (instancetype)init {
    if (self = [super init]) {
        _context = [JSContext new];
    }
    return self;
}

- (JSValue *)eval:(NSString *)evalString params:(NSDictionary *)params {
    NSArray *paramNames = params.allKeys;
    NSArray *paramValues = [[EZS_Sequence(paramNames) map:^id _Nonnull(NSString * _Nonnull item) {
        return params[item];
    }] as:NSArray.class];
    NSString *jsscript = [NSString stringWithFormat:@"evalTemp = function (%@){ return %@; }", [paramNames componentsJoinedByString:@", "], evalString];
    JSValue *func = [_context evaluateScript:jsscript];
    return [func callWithArguments:paramValues];
}

@end
