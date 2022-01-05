//
//  FNV1aHasherTests.swift
//
//
//  Created by Christopher Richez on 1/5/22.
//

import FowlerNollVo
import XCTest

/// This test case hashes values of different types into digests of different sizes
/// to exercise all parts of the API.
class FNV1aHasherTests: XCTestCase {
    /// Hashes a single optional pritive value, then ensures hashing that value always results
    /// in the same digest.
    func testOptionalPrimitive() {
        let input = 1.295
        var hasher = FNV1aHasher<UInt32>()
        input.hash(into: &hasher)
        let output = hasher.digest
        for _ in 1 ... 10 {
            var hasher = FNV1aHasher<UInt32>()
            input.hash(into: &hasher)
            XCTAssertEqual(hasher.digest, output)
        }
    }
    
    /// Hashes a single nil value, then ensures hashing that value always results in the same
    /// digest.
    func testNilPrimitive() {
        let input: Int? = nil
        var hasher = FNV1aHasher<UInt64>()
        input.hash(into: &hasher)
        let output = hasher.digest
        for _ in 1 ... 10 {
            var hasher = FNV1aHasher<UInt64>()
            input.hash(into: &hasher)
            XCTAssertEqual(hasher.digest, output)
        }
    }
    
    struct Object: FNVHashable {
        let text: String
        let number: Int
        
        func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
            text.hash(into: &hasher)
            number.hash(into: &hasher)
        }
    }
    
    /// Hashes a complex structure composed of multiple `FNVHashable` values.
    func testOptionalObject() {
        let input = Object(text: "test", number: -12)
        var hasher = FNV1aHasher<UInt32>()
        input.hash(into: &hasher)
        let output = hasher.digest
        for _ in 1 ... 10 {
            var hasher = FNV1aHasher<UInt32>()
            input.hash(into: &hasher)
            XCTAssertEqual(hasher.digest, output)
        }
    }
    
    /// Hashes a sequence of `FNVHashable` values.
    func testSequence() {
        let input = ["this", "is", "a", "test"]
        var hasher = FNV1aHasher<UInt64>()
        input.hash(into: &hasher)
        let output = hasher.digest
        for _ in 1 ... 10 {
            var hasher = FNV1aHasher<UInt64>()
            input.hash(into: &hasher)
            XCTAssertEqual(hasher.digest, output)
        }
    }
}
