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

import Foundation
import Nimble
import XCTest
import Quick
import EasyReact

@objc public class AssertBlockContainer: NSObject {
    @objc public var action: (() -> Void)?
}

public func assertPredicateDebug(_ isParamAssert: Bool) -> Predicate<AssertBlockContainer> {
    return Predicate.define("") { (actualExpress, msg) -> PredicateResult in
        let actual = try actualExpress.evaluate()
        guard let container = actual, let closure = container.action else {
            return PredicateResult(bool:false, message:msg.appended(message: "the expected block is not given"))
        }
        
        let assertHandler = AssertionHandler()
        Thread.current.threadDictionary.setValue(assertHandler, forKey: NSAssertionHandlerKey)
        closure()
        Thread.current.threadDictionary.removeObject(forKey: NSAssertionHandlerKey)
        
        if isParamAssert {
            return PredicateResult(bool: assertHandler.parameterAssertExecption != nil,
                                   message:.fail("the target does not contain NSParameterAssert or NSCParameterAssert."));
        } else {
            return  PredicateResult(bool: assertHandler.assertExecption != nil,
                                    message:.fail("the target does not contain NSAssert or NSCAssert."));
        }
    }
}

public func assertPredicateRelease(_ isParamAssert: Bool) -> Predicate<AssertBlockContainer> {
    return Predicate.define("") { (actualExpress, msg) -> PredicateResult in
        let actual = try actualExpress.evaluate()
        guard let container = actual, let closure = container.action else {
            return PredicateResult(bool:false, message:msg.appended(message: "the expected block is not given"))
        }
        
        closure()
 
        return PredicateResult(bool: true, message: msg)
    }
}

@objc extension NMBObjCMatcher {
    
    public class func hasParameterAssertMatcherDebug() -> NMBObjCMatcher {
        return NMBObjCMatcher(canMatchNil: false) {  (actualExpression, failureMessage) -> Bool in
            let expr = actualExpression.cast {
                $0 as? AssertBlockContainer
            }
            return try! assertPredicateDebug(true).matches(expr, failureMessage:  failureMessage)
        }
    }
    
    public class func hasParameterAssertMatcherRelease() -> NMBObjCMatcher {
        return NMBObjCMatcher(canMatchNil: false) {  (actualExpression, failureMessage) -> Bool in
            let expr = actualExpression.cast {
                $0 as? AssertBlockContainer
            }
            return try! assertPredicateRelease(true).matches(expr, failureMessage:  failureMessage)
        }
    }
    
    public class func hasAssertMatcherDebug() -> NMBObjCMatcher {
        return NMBObjCMatcher(canMatchNil: false) {  (actualExpression, failureMessage) -> Bool in
            let expr = actualExpression.cast {
                $0 as? AssertBlockContainer
            }
            return try! assertPredicateDebug(false).matches(expr, failureMessage:  failureMessage)
        }
    }
    
    public class func hasAssertMatcherRelease() -> NMBObjCMatcher {
        return NMBObjCMatcher(canMatchNil: false) {  (actualExpression, failureMessage) -> Bool in
            let expr = actualExpression.cast {
                $0 as? AssertBlockContainer
            }
            return try! assertPredicateRelease(false).matches(expr, failureMessage:  failureMessage)
        }
    }
}
