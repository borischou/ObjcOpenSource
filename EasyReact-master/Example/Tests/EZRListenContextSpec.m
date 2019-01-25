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

QuickSpecBegin(EZRListenContextSpec)

describe(@"Listener", ^{
    context(@"- withSelector:", ^{
        it(@"can invoke method which is given selector", ^{
            EZRMutableNode<NSNumber *> *testNode = [EZRMutableNode new];
            TestListener *listener = [TestListener new];
            listener = OCMPartialMock(listener);
            [[testNode listenedBy:listener] withSelector:@selector(testReceive)];
            [[testNode listenedBy:listener] withSelector:@selector(testReceive:)];
            [[testNode listenedBy:listener] withSelector:@selector(testReceive:context:)];
            
            [testNode setValue:@1 context:@"hello"];
            
            OCMVerify([listener testReceive]);
            OCMVerify([listener testReceive:@1]);
            OCMVerify([listener testReceive:@1 context:@"hello"]);
        });
        
        it(@"should raise an assert if given selector parameters is not id type", ^{
            EZRMutableNode<NSNumber *> *testNode = [EZRMutableNode new];
            TestListener *listener = [TestListener new];
            {
                id<EZRCancelable> cancelable = [[testNode listenedBy:listener] withSelector:@selector(testReceiveInt:)];
            
                assertExpect(^{
                    [testNode setValue:@1 context:@"hello"];
                }).to(hasAssert());
            
                [cancelable cancel];
            }
            {
                [testNode clean];
                id<EZRCancelable> cancelable = [[testNode listenedBy:listener] withSelector:@selector(testReceiveInt:context:)];
                
                assertExpect(^{
                    [testNode setValue:@1 context:@"hello"];
                }).to(hasAssert());
                
                [cancelable cancel];
            }
            {
                [testNode clean];
                id<EZRCancelable> cancelable = [[testNode listenedBy:listener] withSelector:@selector(testReceive:intContext:)];
                
                assertExpect(^{
                    [testNode setValue:@1 context:@"hello"];
                }).to(hasAssert());
                
                [cancelable cancel];
            }
        });
        
        it(@"should raise an assert if given selector parameters is greater than 2", ^{
            EZRMutableNode<NSNumber *> *testNode = [EZRMutableNode new];
            TestListener *listener = [TestListener new];
            [[testNode listenedBy:listener] withSelector:@selector(testReceive:context:other:)];
                
            assertExpect(^{
                [testNode setValue:@1 context:@"hello"];
            }).to(hasAssert());
        });
        
        it(@"should raise an assert if given selector doesn't exists", ^{
            EZRMutableNode<NSNumber *> *testNode = [EZRMutableNode new];
            TestListener *listener = [TestListener new];
            [[testNode listenedBy:listener] withSelector:@selector(addObject:)];
            
            assertExpect(^{
                [testNode setValue:@1 context:@"hello"];
            }).to(hasAssert());
        });
        
        it(@"should raise an assert without given selector", ^{
            EZRMutableNode<NSNumber *> *testNode = [EZRMutableNode new];
            TestListener *listener = [TestListener new];
            
            SEL sel = NULL;
            assertExpect(^{
                [[testNode listenedBy:listener] withSelector:sel];
            }).to(hasParameterAssert());
        });
    });
    
    it(@"can receive value and context from sender", ^{
        EZRMutableNode<NSNumber *> *testNode = [EZRMutableNode new];
        NSObject *listener = [NSObject new];
        __block NSNumber *value;
        __block id receiveContext;
        [[testNode listenedBy:listener] withContextBlock:^(NSNumber * _Nullable next, id _Nullable context) {
            value = next;
            receiveContext = context;
        }];
        [testNode setValue:@1 context:@"1"];
        expect(value).to(equal(@1));
        expect(receiveContext).to(equal(@"1"));
    });
    
    it(@"can only receive the last sender's context when zipping multi nodes", ^{
        EZRMutableNode<NSNumber *> *testNode1 = [EZRMutableNode new];
        EZRMutableNode<NSNumber *> *testNode2 = [EZRMutableNode new];
        EZRNode<EZTuple2<NSNumber *, NSNumber *> *> *node = [EZRNode zip:@[testNode1, testNode2]];
        NSObject *listener = [NSObject new];
        __block EZTuple2<NSNumber *, NSNumber *> *value;
        __block id receiveContext;
        [[node listenedBy:listener] withContextBlock:^(EZTuple2<NSNumber *,NSNumber *> * _Nullable next, id  _Nullable context) {
            value = next;
            receiveContext = context;
        }];
        [testNode1 setValue:@1 context:@"1"];
        [testNode2 setValue:@2 context:@"2"];
        expect(value).to(equal(EZTuple(@1, @2)));
        expect(receiveContext).to(equal(@"2"));
    });
    
    it(@"can only receive the last sender's context when combining multi nodes", ^{
        EZRMutableNode<NSNumber *> *testNode1 = [EZRMutableNode new];
        EZRMutableNode<NSNumber *> *testNode2 = [EZRMutableNode new];
        EZRNode<EZTuple2<NSNumber *, NSNumber *> *> *node = [EZRNode combine:@[testNode1, testNode2]];
        NSObject *listener = [NSObject new];
        __block EZTuple2<NSNumber *, NSNumber *> *value;
        __block id receiveContext;
        [[node listenedBy:listener] withContextBlock:^(EZTuple2<NSNumber *,NSNumber *> * _Nullable next, id  _Nullable context) {
            value = next;
            receiveContext = context;
        }];
        [testNode1 setValue:@1 context:@"1"];
        [testNode2 setValue:@2 context:@"2"];
        expect(value).to(equal(EZTuple(@1, @2)));
        expect(receiveContext).to(equal(@"2"));
    });
    
    it(@"can receive on a given queue", ^{
        EZRMutableNode<NSNumber *> *testNode = [EZRMutableNode new];
        NSObject *listener = [NSObject new];
        __block NSNumber *value;
        __block id receiveContext;
        __block BOOL onMainQueue = NO;
        waitUntil(^(void (^done)(void)) {
            [[testNode listenedBy:listener] withContextBlockOnMainQueue:^(NSNumber * _Nullable next, id _Nullable context) {
                value = next;
                receiveContext = context;
                onMainQueue = [[NSThread currentThread] isMainThread];
                done();
            }];
            [testNode setValue:@1 context:@"1"];
        });
        
        expect(value).to(equal(@1));
        expect(receiveContext).to(equal(@"1"));
        expect(onMainQueue).to(beTrue());
    });
});

QuickSpecEnd
