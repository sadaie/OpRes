//
//  RustyOptionalTypeTests.swift
//  RustyOptionalTypeTests
//
//  Created by Sadaie Matsudaira on 2019/01/11.
//  Copyright © 2019 Sadaie Matsudaira. All rights reserved.
//

import XCTest
@testable import RustyOptionalType

struct TestError: Error {}

class RustyOptionalTypeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
        let x: Int? = 10
        let y: Int = 20
        XCTAssertEqual(x.unwrap(or: y), 10)
    }
    
    func testUnwrapOrSelfIsNone() {
        let x: Int? = nil
        let y: Int = 20
        XCTAssertEqual(x.unwrap(or: y), 20)
    }
    
    func testUnwrapOrElse() {
        let x: Int? = 10
        let y: () -> Int = { 20 }
        XCTAssertEqual(x.unwrap(or: y), 10)
    }
    
    func testUnwrapOrElseSelfIsNone() {
        let x: Int? = nil
        let y: () -> Int = { 20 }
        XCTAssertEqual(x.unwrap(or: y), 20)
    }
    
    func testMapOr() {
        let x: Int? = 10
        let y: Int = 20
        let map: (Int) -> Int = { $0 * 10 }
        XCTAssertEqual(x.map(or: y, map), 100)
    }
    
    func testMapOrSelfIsNone() {
        let x: Int? = nil
        let y: Int = 20
        let map: (Int) -> Int = { $0 * 10 }
        XCTAssertEqual(x.map(or: y, map), 20)
    }
    
    func testMapOrElse() {
        let x: Int? = 10
        let y: () -> Int = { 20 }
        let map: (Int) -> Int = { $0 * 10 }
        XCTAssertEqual(x.map(or: y, map), 100)
    }
    
    func testMapOrElseSelfIsNone() {
        let x: Int? = nil
        let y: () -> Int = { 20 }
        let map: (Int) -> Int = { $0 * 10 }
        XCTAssertEqual(x.map(or: y, map), 20)
    }
    
    
    
    func testOkOr() {
        let x: Int? = 10
        
        do {
            let result = try x.ok(or: TestError())
            XCTAssertEqual(result, 10)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testOkOrSelfIsNone() {
        let x: Int? = nil
        
        do {
            let result = try x.ok(or: TestError())
            XCTAssertNotEqual(result, 10)
        } catch {
            // success
        }
    }
    
    func testOkOrElse() {
        let x: Int? = 10
        let y: () -> TestError = { TestError() }
        do {
            let result = try x.ok(or: y)
            XCTAssertEqual(result, 10)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testOkOrElseSelfIsNone() {
        let x: Int? = nil
        let y: () -> TestError = { TestError() }
        do {
            let result = try x.ok(or: y)
            XCTAssertNotEqual(result, 10)
        } catch {
            // success
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
        XCTAssertEqual(a.and(then: sq).and(then: sq), 10_000)
        XCTAssertNil(a.and(then: nope).and(then: sq))
        
        let b: Int? = nil
        XCTAssertNil(b.and(then: sq).and(then: sq))
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
        var a: Int? = nil
        let b: Int? = a.getOrInsert(10)
        XCTAssertEqual(a, b)
        
        var c: Int? = 10
        let d: Int? = c.getOrInsert(20)
        XCTAssertEqual(c, d)
    }
    
    func testGetOrInsertWith() {
        var a: Int? = nil
        let b: Int? = a.getOrInsert { 10 }
        XCTAssertEqual(a, b)
        
        var c: Int? = 10
        let d: Int? = c.getOrInsert { 20 }
        XCTAssertEqual(c, d)
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
    }
}
