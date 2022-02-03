//
//  HasherPerformanceTests.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

import FowlerNollVo
import XCTest

/// This test case measures the time required to hash a fixed size input with each hasher.
class HasherPerformanceTests: XCTestCase {
    /// A random integer to use for each test run.
    let input: Int = .random(in: .min ... .max)
    
    func testFNV32() {
        var hasher = FNV32()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV32a() {
        var hasher = FNV32a()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV64() {
        var hasher = FNV64()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV64a() {
        var hasher = FNV64a()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV128() {
        var hasher = FNV128()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV128a() {
        var hasher = FNV128a()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV256() {
        var hasher = FNV256()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV256a() {
        var hasher = FNV256a()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV512() {
        var hasher = FNV512()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV512a() {
        var hasher = FNV512a()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV1024() {
        var hasher = FNV1024()
        measure {
            hasher.combine(input)
        }
    }
    
    func testFNV1024a() {
        var hasher = FNV1024a()
        measure {
            hasher.combine(input)
        }
    }
}
