//
//  HashStabilityTests.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

import FowlerNollVo
import XCTest

/// This test case ensures each hasher consistently returns the same digest
/// when given the same inputs.
class HashStabilityTests: XCTestCase {
    /// Returns the hash of the provided value using the specified hasher type.
    ///
    /// - Parameters:
    ///     - input: a `FNVHashable` value to hash
    ///     - hasher: the hasher type to initialize and hash with
    ///
    /// - Returns:
    /// The digest of the specified hasher after hashing the provided value.
    func hash<Hasher>(_ input: FNVHashable, with hasher: Hasher.Type) -> Hasher.Digest
    where Hasher: FNVHasher {
        var hasher = Hasher()
        input.hash(into: &hasher)
        return hasher.digest
    }
    
    /// Hashes the same input 10 times using the specified hasher type,
    /// and fails if the resulting digest changed at any point.
    ///
    /// On failure, a descriptive message is logged that identifes the input value,
    /// the type of the input value, and the hasher type used.
    func checkStability<Hasher>(of input: FNVHashable, withHasher hasher: Hasher.Type)
    where Hasher : FNVHasher, Hasher.Digest : Equatable {
        let output = hash(input, with: hasher)
        for _ in 1 ... 9 {
            XCTAssertEqual(
                output,
                hash(input, with: hasher),
                "hash of value \(input) of type \(type(of: input)) with hasher \(hasher) unstable"
            )
        }
    }
    
    /// An array of randomly generated `FNVHashable` values.
    let inputs: [FNVHashable] = [
        "this is a test \u{10424}", String?.none,
        Bool.random(), Bool?.none,
        Int.random(in: .min ... .max), Int?.none,
        Int8.random(in: .min ... .max), Int8?.none,
        Int16.random(in: .min ... .max), Int16?.none,
        Int32.random(in: .min ... .max), Int32?.none,
        Int64.random(in: .min ... .max), Int64?.none,
        UInt.random(in: .min ... .max), UInt?.none,
        UInt8.random(in: .min ... .max), UInt8?.none,
        UInt16.random(in: .min ... .max), UInt16?.none,
        UInt32.random(in: .min ... .max), UInt32?.none,
        UInt64.random(in: .min ... .max), UInt64?.none,
        Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude), Double?.none,
        Float.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude), Float?.none,
    ]
    
    /// Calls `checkStability(of:withHasher:)` for each input in `inputs` and every hasher type.
    ///
    /// This test fails if any input/hasher combination fails.
    /// Check console messages for the specific pair that failed.
    func testAll() {
        for input in inputs {
            checkStability(of: input, withHasher: FNV32a.self)
            checkStability(of: input, withHasher: FNV64.self)
            checkStability(of: input, withHasher: FNV64a.self)
            checkStability(of: input, withHasher: FNV128.self)
            checkStability(of: input, withHasher: FNV128a.self)
            checkStability(of: input, withHasher: FNV256.self)
            checkStability(of: input, withHasher: FNV256a.self)
            checkStability(of: input, withHasher: FNV512.self)
            checkStability(of: input, withHasher: FNV512a.self)
            checkStability(of: input, withHasher: FNV1024.self)
            checkStability(of: input, withHasher: FNV1024a.self)
        }
    }
}
