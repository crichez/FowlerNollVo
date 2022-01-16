//
//  FNVHashableTests.swift
//  FNVHashableTests
//
//  Created by Christopher Richez on January 15 2022
//

import FowlerNollVo
import XCTest

class FNVHashableTests: XCTestCase {
    /// Asserts `nil` values affect the hash value of their parent optional sequence
    /// when using the `FNV-1a` hash function.
    ///
    /// See issue #21 for details.
    func testOptionalSequenceHash1a() {
        // Hash a sequence of four elements including one nil
        var hasher1 = FNV1aHasher<UInt64>()
        let sequence1 = [nil, 1, 2, 3]
        sequence1.hash(into: &hasher1)

        // Hash a sequence of three elements
        var hasher2 = FNV1aHasher<UInt64>()
        let sequence2 = [1, 2, 3]
        sequence2.hash(into: &hasher2)

        // Assert the hash values are not equal
        XCTAssertNotEqual(hasher1.digest, hasher2.digest, "nil element didn't affect hash")
    }

    /// Asserts `nil` values affect the hash value of their parent optional sequence
    /// when using the `FNV-1` hash function.
    ///
    /// See issue #21 for details.
    func testOptionalSequenceHash1() {
        // Hash a sequence of four elements including one nil
        var hasher1 = FNV1Hasher<UInt64>()
        let sequence1 = [nil, 1, 2, 3]
        sequence1.hash(into: &hasher1)

        // Hash a sequence of three elements
        var hasher2 = FNV1Hasher<UInt64>()
        let sequence2 = [1, 2, 3]
        sequence2.hash(into: &hasher2)

        // Assert the hash values are not equal
        XCTAssertNotEqual(hasher1.digest, hasher2.digest, "nil element didn't affect hash")
    }

    /// Asserts two sequences that contain different number of nil elements have different
    /// hash values using the FNV-1a hash function.
    func testNilSequenceHash1a() {
        // Hash a sequence of four nils
        var hasher1 = FNV1aHasher<UInt64>()
        let sequence1: [Float?] = [nil, nil, nil, nil]
        sequence1.hash(into: &hasher1)

        // Hash a sequence of three nils
        var hasher2 = FNV1aHasher<UInt64>()
        let sequence2: [Float?] = [nil, nil, nil]
        sequence2.hash(into: &hasher2)

        // Assert the hash values are not equal
        XCTAssertNotEqual(hasher1.digest, hasher2.digest, "nil sequences with different counts are equal")
    }
    /// Asserts two sequences that contain different number of nil elements have different
    /// hash values using the FNV-1 hash function.
    func testNilSequenceHash1() {
        // Hash a sequence of four nils
        var hasher1 = FNV1Hasher<UInt64>()
        let sequence1: [Float?] = [nil, nil, nil, nil]
        sequence1.hash(into: &hasher1)

        // Hash a sequence of three nils
        var hasher2 = FNV1Hasher<UInt64>()
        let sequence2: [Float?] = [nil, nil, nil]
        sequence2.hash(into: &hasher2)

        // Assert the hash values are not equal
        XCTAssertNotEqual(hasher1.digest, hasher2.digest, "nil sequences with different counts are equal")
    }

    /// Asserts an empty sequence and a sequence with a single nil element have different hash values
    /// using the FNV-1a hash function.
    func testEmptySequenceDifferentFromNil1a() throws {
        // Hash an empty sequence
        var hasher1 = FNV1aHasher<UInt64>()
        let sequence1: [String?] = []
        sequence1.hash(into: &hasher1)

        // Hash a sequence with a single nil element
        var hasher2 = FNV1aHasher<UInt64>()
        let sequence2: [String?] = [nil]
        sequence2.hash(into: &hasher2)

        // Assert the hash values for these sequences are different
        XCTAssertNotEqual(hasher1.digest, hasher2.digest, "sequences unexpectedly match")
    }

    /// Asserts an empty sequence and a sequence with a single nil element have different hash values
    /// using the FNV-1 hash function.
    func testEmptySequenceDifferentFromNil1() throws {
        // Hash an empty sequence
        var hasher1 = FNV1Hasher<UInt64>()
        let sequence1: [String?] = []
        sequence1.hash(into: &hasher1)

        // Hash a sequence with a single nil element
        var hasher2 = FNV1Hasher<UInt64>()
        let sequence2: [String?] = [nil]
        sequence2.hash(into: &hasher2)

        // Assert the hash values for these sequences are different
        XCTAssertNotEqual(hasher1.digest, hasher2.digest, "sequences unexpectedly match")
    }
}