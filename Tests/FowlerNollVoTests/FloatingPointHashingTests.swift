//
//  FloatingPointHashingTests.swift
//  
//
//  Created by Christopher Richez on 2/3/22.
//

import FowlerNollVo
import XCTest

/// This test case asserts different representations of zero still return the same hash value.
class FloatingPointHashingTests: XCTestCase {
    func test<T, Hasher>(type: T.Type, hasher: Hasher.Type)
    where T : BinaryFloatingPoint & FNVHashable, Hasher : FNVHasher, Hasher.Digest : Equatable {
        // Get both representations of zero
        let plusZero = T(sign: .plus, exponent: 1, significand: 0.0)
        let minusZero = T(sign: .minus, exponent: 1, significand: 0.0)
        
        // Hash both values
        var plusHasher = Hasher()
        plusZero.hash(into: &plusHasher)
        var minusHasher = Hasher()
        minusZero.hash(into: &minusHasher)
        
        // Compare their digests
        XCTAssertEqual(plusHasher.digest, minusHasher.digest)
    }
    
    func testFloat() {
        let type = Float.self
        test(type: type, hasher: FNV32.self)
        test(type: type, hasher: FNV32a.self)
        test(type: type, hasher: FNV64.self)
        test(type: type, hasher: FNV64a.self)
        test(type: type, hasher: FNV128.self)
        test(type: type, hasher: FNV128a.self)
        test(type: type, hasher: FNV256.self)
        test(type: type, hasher: FNV256a.self)
        test(type: type, hasher: FNV512.self)
        test(type: type, hasher: FNV512a.self)
        test(type: type, hasher: FNV1024.self)
        test(type: type, hasher: FNV1024a.self)
    }
    
    func testDouble() {
        let type = Double.self
        test(type: type, hasher: FNV32.self)
        test(type: type, hasher: FNV32a.self)
        test(type: type, hasher: FNV64.self)
        test(type: type, hasher: FNV64a.self)
        test(type: type, hasher: FNV128.self)
        test(type: type, hasher: FNV128a.self)
        test(type: type, hasher: FNV256.self)
        test(type: type, hasher: FNV256a.self)
        test(type: type, hasher: FNV512.self)
        test(type: type, hasher: FNV512a.self)
        test(type: type, hasher: FNV1024.self)
        test(type: type, hasher: FNV1024a.self)
    }
    
#if swift(>=5.4) && !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    @available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
    func testFloat16() {
        let type = Float16.self
        test(type: type, hasher: FNV32.self)
        test(type: type, hasher: FNV32a.self)
        test(type: type, hasher: FNV64.self)
        test(type: type, hasher: FNV64a.self)
        test(type: type, hasher: FNV128.self)
        test(type: type, hasher: FNV128a.self)
        test(type: type, hasher: FNV256.self)
        test(type: type, hasher: FNV256a.self)
        test(type: type, hasher: FNV512.self)
        test(type: type, hasher: FNV512a.self)
        test(type: type, hasher: FNV1024.self)
        test(type: type, hasher: FNV1024a.self)
    }
#endif
}
