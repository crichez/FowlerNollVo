//
//  FNV32aTests.swift
//  FNV32aTests
//
//  Created by Christopher Richez on 8/30/21.
//

import FowlerNollVo
import FNV32a
import XCTest

#if canImport(Foundation)
import Foundation
#endif

class FNV32aTests: XCTestCase {
    func hash<T: FNVHashable>(_ data: T) -> UInt32 {
        var hasher = FNV32a()
        hasher.combine(data)
        return hasher.digest
    }
    
    func testDoubleHashStability() {
        let value: Double = .random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testFloatHashStability() {
        let value: Float = .random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    #if arch(arm)
    @available(macOS 11, *)
    @available(macCatalyst 14, *)
    @available(macOSApplicationExtension 11, *)
    @available(macCatalystApplicationExtension 14, *)
    @available(iOS 14, *)
    @available(watchOS 7, *)
    @available(tvOS 14, *)
    func testFloat16HashStability() {
        let value: Float16 = .random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    #endif
    
    func testBoolHashStability() {
        let value: Bool = .random()
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testStringHashStability() {
        let value: String = "this is a test string"
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testUIntHashStability() {
        let value: UInt = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testUInt8HashStability() {
        let value: UInt8 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testUInt16HashStability() {
        let value: UInt16 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testUInt32HashStability() {
        let value: UInt32 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testUInt64HashStability() {
        let value: UInt64 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testIntHashStability() {
        let value: Int = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testInt8HashStability() {
        let value: Int8 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testInt16HashStability() {
        let value: Int16 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testInt32HashStability() {
        let value: Int32 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testInt64HashStability() {
        let value: Int64 = .random(in: .min ... .max)
        let hashedValue = hash(value)
        print(hashedValue)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testArrayHashStability() {
        let value = (0 ... 128).map { _ in
            Int32.random(in: .min ... .max)
        }
        let hashedValue = hash(value)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testNilOptionalHashStability() {
        let value: Double? = nil
        let hashedValue = hash(value)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    func testNonNilOptionalHashStability() {
        let value: Double? = .random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let hashedValue = hash(value)
        for _ in 1 ... 10 {
            XCTAssertEqual(hashedValue, hash(value))
        }
    }
    
    #if canImport(Foundation)
    /// Asserts that the collision rate for random 128-bit values should be 0.0013% or less.
    func testCollisionRate128() {
        var values: Set<UUID> = []
        var hashedValues: Set<UInt32> = []
        for _ in 1 ... 1_000_000 {
            // Initialize our own hasher here since we are going to use a custom type
            var hasher = FNV32a()
            // Make sure all values are unique before hashing
            var value = UUID()
            while values.contains(value) { value = UUID() }
            values.insert(value)
            // Hash the value and store it to check for collisions
            let hashedValue: UInt32 = withUnsafeBytes(of: value) { valueBytes in
                hasher.combine(valueBytes)
                return hasher.digest
            }
            hashedValues.insert(hashedValue)
        }
        let collisions = 1_000_000 - hashedValues.count
        print("\(collisions) collisions out of 1,000,000 unique 128-bit values.")
        XCTAssertLessThanOrEqual(collisions, 130)
    }
    #endif
    
    /// Asserts that the collision rate for random 64-bit values should be 0.0013% or less.
    func testCollisionRate64() {
        var values: Set<UInt64> = []
        var hashedValues: Set<UInt32> = []
        for _ in 1 ... 1_000_000 {
            // Make sure all values are unique before hashing
            var value: UInt64 = .random(in: .min ... .max)
            while values.contains(value) { value = .random(in: .min ... .max) }
            values.insert(value)
            // Hash the value and store it to check for collisions
            let hashedValue = hash(value)
            hashedValues.insert(hashedValue)
        }
        let collisions = 1_000_000 - hashedValues.count
        print("\(collisions) collisions out of 1,000,000 unique 64-bit values.")
        XCTAssertLessThanOrEqual(collisions, 130)
    }
    
    /// Asserts that the collision rate for random 32-bit values should be 0.0022% or less.
    func testCollisionRate32() {
        var values: Set<UInt32> = []
        var hashedValues: Set<UInt32> = []
        for _ in 1 ... 1_000_000 {
            // Make sure all values are unique before hashing
            var value: UInt32 = .random(in: .min ... .max)
            while values.contains(value) { value = .random(in: .min ... .max) }
            values.insert(value)
            // Hash the value and store it to check for collisions
            let hashedValue = hash(value)
            hashedValues.insert(hashedValue)
        }
        let collisions = 1_000_000 - hashedValues.count
        print("\(collisions) collisions out of 1,000,000 unique 32-bit values.")
        XCTAssertLessThanOrEqual(collisions, 220)
    }
}
