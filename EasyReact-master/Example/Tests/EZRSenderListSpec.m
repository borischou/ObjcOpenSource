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

QuickSpecBegin(EZRSenderListSpec)

describe(@"EZRSenderList", ^{
    it(@"has description contains sender", ^{
        EZRNode *nodeA = [[EZRNode value:@1] named:@"nodeA"];
        EZRNode *nodeB = [[EZRNode value:@2] named:@"nodeB"];
        EZRSenderList *senderList = [EZRSenderList senderListWithArray:@[nodeA, nodeB]];
        NSMutableString *description = [NSMutableString stringWithFormat:@"<EZRSenderList: %p>{\nEZRNode(named:nodeB value:2)->\nEZRNode(named:nodeA value:1)->\nnil\n}", senderList];
        expect(senderList.description).to(equal(description));
    });
});

QuickSpecEnd
