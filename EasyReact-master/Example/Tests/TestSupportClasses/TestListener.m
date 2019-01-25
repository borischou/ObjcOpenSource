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

#import "TestListener.h"

@implementation TestListener

- (void)testReceive {}

- (void)testReceive:(id)value {}

- (void)testReceive:(id)value context:(id)context {}

- (void)testReceiveInt:(int)value {}

- (void)testReceiveInt:(int)value context:(id)context {}

- (void)testReceive:(id)value intContext:(int)intContext {}

- (void)testReceive:(id)value context:(id)context other:(id)other {}

@end
