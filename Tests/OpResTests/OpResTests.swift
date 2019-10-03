//
//  OpResTests.swift
//  OpResTests
//
// This software licensed under the MIT LICENSE.
// See LICENSE file in the project root for full license information.
//

import XCTest
@testable import OpRes

struct TestError: Error, Hashable {}

extension TestError: Equatable {
    static func ==(lhs: TestError, rhs: TestError) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class OpResOptionalExtensionsTests: XCTestCase {
    func testIsSome() {
        let x: Int? = 10
        XCTAssertTrue(x.isSome)
    }
    
    func testIsNone() {
        let x: Int? = nil
        XCTAssertTrue(x.isNone)
    }
    
    func testExpect() {
        let x: Int? = 10
        XCTAssertEqual(x.expect("value must be 10"), 10)
    }
    
    /*
     func testExpectShouldFail() {
     let x: Int? = nil
     XCTAssertEqual(x.expect("value must be 10"), 10)
     }
     */
    
    func testUnwrap() {
        let x: Int? = 10
        XCTAssertEqual(x.unwrap(), 10)
    }
    
    /*
     func testUnwrapShouldFail() {
     let x: Int? = nil
     XCTAssertEqual(x.unwrap(), 10)
     }
     */
    
    func testUnwrapOr() {
        let a: Int? = 10
        let b: Int = 20
        XCTAssertEqual(a.unwrap(or: b), 10)
        
        let c: Int? = nil
        let d: Int = 20
        XCTAssertEqual(c.unwrap(or: d), 20)
    }
    
    func testUnwrapOrElse() {
        let a: Int? = 10
        let b: () -> Int = { 20 }
        XCTAssertEqual(a.unwrap(or: b), 10)
        
        let c: Int? = nil
        let d: () -> Int = { 20 }
        XCTAssertEqual(c.unwrap(or: d), 20)
    }
    
    func testMapOr() {
        let a: Int? = 10
        let b: Int = 20
        let map: (Int) -> Int = { $0 * 10 }
        XCTAssertEqual(a.map(or: b, transform: map), 100)
        
        let c: Int? = nil
        let d: Int = 20
        XCTAssertEqual(c.map(or: d, transform: map), 20)
    }
    
    func testMapOrElse() {
        let a: Int? = 10
        let b: () -> Int = { 20 }
        let map: (Int) -> Int = { $0 * 10 }
        XCTAssertEqual(a.map(or: b, transform: map), 100)
        
        let c: Int? = nil
        let d: () -> Int = { 20 }
        XCTAssertEqual(c.map(or: d, transform: map), 20)
    }
    
    func testOkOr() {
        let a: Int? = 10
        
        let b: Result<Int, TestError> = a.ok(or: TestError())
        
        switch b {
        case .success(let v):
            XCTAssertEqual(v, 10)
        case .failure(let e):
            XCTFail(e.localizedDescription)
        }
        
        let c: Int? = nil
        
        let d: Result<Int, TestError> = c.ok(or: TestError())
        
        switch d {
        case .success(_):
            XCTFail("must not be some.")
        case .failure(_):
            // success
            break
        }
        
        let e: Int? = 10
        let f = e.ok(or: TestError())
        XCTAssert(type(of: f) == Result<Int, TestError>.self)
    }
    
    func testOkOrElse() {
        let a: Int? = 10
        let b: () -> TestError = { TestError() }
        
        let c: Result<Int, TestError> = a.ok(or: b)
        
        switch c {
        case .success(let v):
            XCTAssertEqual(v, 10)
        case .failure(let e):
            XCTFail(e.localizedDescription)
        }
        
        let d: Int? = nil
        
        let e: Result<Int, TestError> = d.ok(or: b)
        
        switch e {
        case .success(_):
            XCTFail("must not be some.")
        case .failure(_):
            // success
            break
        }
    }
    
    func testAnd() {
        let a: Int? = 10
        let b: Int? = nil
        XCTAssertNil(a.and(b))
        
        let c: Int? = nil
        let d: Int? = 20
        XCTAssertNil(c.and(d))
        
        let e: Int? = 10
        let f: Int? = 20
        XCTAssertEqual(e.and(f), 20)
        
        let g: Int? = nil
        let h: Int? = nil
        XCTAssertNil(g.and(h))
    }
    
    func testAndThen() {
        let sq: (Int) -> Int? = { $0 * $0 }
        let nope: (Int) -> Int? = { _ in nil }
        
        let a: Int? = 10
        XCTAssertEqual(a.and(sq).and(sq), 10_000)
        XCTAssertNil(a.and(nope).and(sq))
        
        let b: Int? = nil
        XCTAssertNil(b.and(sq).and(sq))
    }
    
    func testFilter() {
        let isEven: (Int) -> Bool = { n in n % 2 == 0 }
        
        let a: Int? = 10
        XCTAssertEqual(a.filter(isEven), 10)
        
        let b: Int? = 11
        XCTAssertNil(b.filter(isEven))
        
        let c: Int? = nil
        XCTAssertNil(c.filter(isEven))
    }
    
    func testOr() {
        let a: Int? = 10
        let b: Int? = nil
        XCTAssertEqual(a.or(b), 10)
        
        let c: Int? = nil
        let d: Int? = 20
        XCTAssertEqual(c.or(d), 20)
        
        let e: Int? = 10
        let f: Int? = 20
        XCTAssertEqual(e.or(f), 10)
        
        let g: Int? = nil
        let h: Int? = nil
        XCTAssertNil(g.or(h))
    }
    
    func testOrElse() {
        let nobody: () -> String? = { nil }
        let vikings: () -> String? = { "vikings" }
        
        let a: String? = "barbarians"
        XCTAssertEqual(a.or(vikings), "barbarians")
        
        let b: String? = nil
        XCTAssertEqual(b.or(vikings), "vikings")
        XCTAssertNil(b.or(nobody))
    }
    
    func testXor() {
        let a: Int? = 10
        let b: Int? = nil
        XCTAssertEqual(a.xor(b), 10)
        
        let c: Int? = nil
        let d: Int? = 20
        XCTAssertEqual(c.xor(d), 20)
        
        let e: Int? = 10
        let f: Int? = 20
        XCTAssertNil(e.xor(f))
        
        let g: Int? = nil
        let h: Int? = nil
        XCTAssertNil(g.xor(h))
    }
    
    func testGetOrInsert() {
        var x: Int? = nil
        
        do {
            let y: UnsafeMutablePointer<Int> = x.getOrInsert(10)
            XCTAssertEqual(y.pointee, 10)
            
            y.pointee = 20
        }
        
        XCTAssertEqual(x, 20)
        
        var y: Int? = 20
        
        do {
            let z: UnsafeMutablePointer<Int> = y.getOrInsert(200)
            XCTAssertEqual(z.pointee, 20)
            
            z.pointee = 200
        }
        
        XCTAssertEqual(y, 200)
    }
    
    func testGetOrInsertWith() {
        var x: Int? = nil
        
        do {
            let y: UnsafeMutablePointer<Int> = x.getOrInsert { 10 }
            XCTAssertEqual(y.pointee, 10)
            
            y.pointee = 20
        }
        
        XCTAssertEqual(x, 20)
        
        var y: Int? = 20
        
        do {
            let z: UnsafeMutablePointer<Int> = y.getOrInsert { 200 }
            XCTAssertEqual(z.pointee, 20)
            
            z.pointee = 200
        }
        
        XCTAssertEqual(y, 200)
    }
    
    func testTake() {
        var a: Int? = 10
        let b: Int? = a.take()
        XCTAssertNil(a)
        XCTAssertEqual(b, 10)
        
        var c: Int? = nil
        let d: Int? = c.take()
        XCTAssertNil(c)
        XCTAssertNil(d)
    }
    
    func testReplace() {
        var a: Int? = 10
        let b: Int? = a.replace(20)
        
        XCTAssertEqual(a, 20)
        XCTAssertEqual(b, 10)
        
        var c: Int? = nil
        let d: Int? = c.replace(20)
        
        XCTAssertEqual(c, 20)
        XCTAssertNil(d)
    }
    
    func testTranspose() {
        let a: Result<Int, TestError>? = .success(10)
        XCTAssertEqual(a.transpose(), .success(10))
        
        let b: Result<Int, TestError>? = .failure(TestError())
        XCTAssertEqual(b.transpose(), .failure(TestError()))
        
        let c: Result<Int, TestError>? = nil
        XCTAssertEqual(c.transpose(), .success(nil))
    }
    
    func testFlattened() {
        let a: Int?? = .some(.some(10))
        let b = a.flattened()
        XCTAssert(type(of: b) == Int?.self)
        XCTAssertEqual(b, 10)
        
        let c: Int?? = .some(nil)
        let d = c.flattened()
        XCTAssert(type(of: d) == Int?.self)
        XCTAssertNil(d)
        
        let e: Int?? = nil
        let f = e.flattened()
        XCTAssert(type(of: f) == Int?.self)
        XCTAssertNil(f)
    }
}

class OpResResultExtensionsTests: XCTestCase {
    func testIsSuccess() {
        let result: Result<Int, TestError> = .success(10)
        XCTAssert(result.isSuccess)
    }
    
    func testIsFailure() {
        let result: Result<Int, TestError> = .failure(TestError())
        XCTAssert(result.isFailure)
    }
    
    func testSuccess() {
        let a: Result<Int, TestError> = .success(10)
        XCTAssertEqual(a.success, 10)
        
        let b: Result<Int, TestError> = .failure(TestError())
        XCTAssertNil(b.success)
    }
    
    func testFailure() {
        let a: Result<Int, TestError> = .failure(TestError())
        XCTAssertEqual(a.failure, TestError())
        
        let b: Result<Int, TestError> = .success(10)
        XCTAssertNil(b.failure)
    }
    
    func testUnwrap() {
        let a: Result<Int, TestError> = .success(10)
        XCTAssertEqual(a.unwrap(), 10)
        
        // should panic
        // let b: Result<Int, TestError> = .failure(TestError())
        // let c = b.unwrap()
    }
    
    func testExpect() {
        let a: Result<Int, TestError> = .success(10)
        XCTAssertEqual(a.expect("returns value"), 10)
        
        // should panic
        // let b: Result<Int, TestError> = .failure(TestError())
        // let c = b.expect()
    }
    
    func testAnd() {
        let a: Result<Int, TestError> = .success(10)
        let b: Result<Int, TestError> = .success(20)
        let c = a.and(b)
        
        XCTAssertEqual(c.success, 20)
        
        let d: Result<Int, TestError> = .failure(TestError())
        let e: Result<Int, TestError> = .success(20)
        let f = d.and(e)
        
        XCTAssertNil(f.success)
        
        let g: Result<Int, TestError> = .success(10)
        let h: Result<Int, TestError> = .failure(TestError())
        let i = g.and(h)
        
        XCTAssertNil(i.success)
    }
    
    func testAndThen() {
        let sq: (Int) -> Result<Int, TestError> = { .success($0 * $0) }
        let nope: (Int) -> Result<Int, TestError> = { _ in .failure(TestError()) }
        
        let a: Result<Int, TestError> = .success(10)
        XCTAssertEqual(a.and(sq).and(sq), .success(10_000))
        XCTAssertEqual(a.and(nope).and(sq), .failure(TestError()))
        
        let b: Result<Int, TestError> = .failure(TestError())
        XCTAssertEqual(b.and(sq).and(sq), .failure(TestError()))
    }
    
    func testOr() {
        let a: Result<Int, TestError> = .success(10)
        let b: Result<Int, TestError> = .failure(TestError())
        XCTAssertEqual(a.or(b), .success(10))
        
        let c: Result<Int, TestError> = .failure(TestError())
        let d: Result<Int, TestError> = .success(20)
        XCTAssertEqual(c.or(d), .success(20))
        
        let e: Result<Int, TestError> = .success(10)
        let f: Result<Int, TestError> = .success(20)
        XCTAssertEqual(e.or(f), .success(10))
        
        let g: Result<Int, TestError> = .failure(TestError())
        let h: Result<Int, TestError> = .failure(TestError())
        XCTAssertEqual(g.or(h), g)
    }
    
    func testOrElse() {
        let nobody: (TestError) -> Result<String, TestError> = { _ in .failure(TestError()) }
        let vikings: (TestError) -> Result<String, TestError> = { _ in .success("vikings") }
        
        let a: Result<String, TestError> = .success("barbarians")
        XCTAssertEqual(a.or(vikings), .success("barbarians"))
        
        let b: Result<String, TestError> = .failure(TestError())
        XCTAssertEqual(b.or(vikings), .success("vikings"))
        XCTAssertEqual(b.or(nobody), b)
    }
    
    func testUnwrapOr() {
        let a: Result<Int, TestError> = .success(10)
        let b = 20
        XCTAssertEqual(a.unwrap(or: b), 10)
        
        let c: Result<Int, TestError> = .failure(TestError())
        let d = 20
        XCTAssertEqual(c.unwrap(or: d), 20)
    }
    
    func testUnwrapOrElse() {
        let a: Result<Int, TestError> = .success(10)
        let b: (TestError) -> Int = { _ in 20 }
        XCTAssertEqual(a.unwrap(or: b), 10)
        
        let c: Result<Int, TestError> = .failure(TestError())
        let d: (TestError) -> Int = { _ in 20 }
        XCTAssertEqual(c.unwrap(or: d), 20)
    }
    
    func testTranspose() {
        let a: Result<Int?, TestError> = .success(10)
        let b: Result<Int, TestError>? = .success(10)
        XCTAssertEqual(a.transpose(), b)
        
        let c: Result<Int?, TestError> = .success(nil)
        XCTAssertNil(c.transpose())
        
        let d: Result<Int?, TestError> = .failure(TestError())
        let e: Result<Int, TestError>? = .failure(TestError())
        XCTAssertEqual(d.transpose(), e)
        
        // compilation error
        // let f: Result<Int, TestError> = .success(10)
        // let g = f.transpose()
    }
    
    func testUnwrapError() {
        let a: Result<Int, TestError> = .failure(TestError())
        XCTAssertEqual(a.unwrapError(), TestError())
        
        // should panic
        // let b: Result<Int, TestError> = .success(10)
        // let c = b.unwrapError()
    }
    
    func testExpectError() {
        let a: Result<Int, TestError> = .failure(TestError())
        XCTAssertEqual(a.expectError("returns error"), TestError())
        
        // should panic
        // let b: Result<Int, TestError> = .success(10)
        // let c = b.expectError()
    }
    
    func testFlattened() {
        let a: Result<Result<Int, TestError>, TestError> = .success(.success(10))
        let b = a.flattened()
        XCTAssert(type(of: b) == Result<Int, TestError>.self)
        XCTAssertEqual(b, .success(10))
        
        let c: Result<Result<Int, TestError>, TestError> = .success(.failure(TestError()))
        let d = c.flattened()
        XCTAssert(type(of: d) == Result<Int, TestError>.self)
        XCTAssertEqual(d, .failure(TestError()))
        
        let e: Result<Result<Int, TestError>, TestError> = .failure(TestError())
        let f = e.flattened()
        XCTAssert(type(of: f) == Result<Int, TestError>.self)
        XCTAssertEqual(f, .failure(TestError()))
    }
    
    class BoolExtensionTests: XCTestCase {
        func testMap() {
            func mapper(v: Bool) -> Int {
                if v {
                    return 10
                } else {
                    return 20
                }
            }
            
            let a: Bool = true
            let b = a.map(mapper)
            XCTAssert(type(of: b) == Int.self)
            XCTAssertEqual(b, 10)
            
            let c: Bool = false
            let d = c.map(mapper)
            XCTAssert(type(of: d) == Int.self)
            XCTAssertEqual(d, 20)
        }
        
        func testThen() {
            let a: Bool = true
            let b = a.then { 10 }
            XCTAssert(type(of: b) == Int?.self)
            XCTAssertEqual(b, 10)
            
            let c: Bool = false
            let d = c.then { 10 }
            XCTAssert(type(of: d) == Int?.self)
            XCTAssertNil(d)
        }
        
        func testElse() {
            let a: Bool = true
            let b = a.otherwise { 10 }
            XCTAssert(type(of: b) == Int?.self)
            XCTAssertNil(b)
            
            let c: Bool = false
            let d = c.otherwise { 10 }
            XCTAssert(type(of: d) == Int?.self)
            XCTAssertEqual(d, 10)
        }
        
        func testIf() {
            let a: Bool = true
            let b = a.if(then: { 10 }, else: { 20 })
            XCTAssert(type(of: b) == Int.self)
            XCTAssertEqual(b, 10)
            
            let c: Bool = false
            let d = c.if(then: { 10 }, else: { 20 })
            XCTAssert(type(of: d) == Int.self)
            XCTAssertEqual(d, 20)
        }
    }
}
