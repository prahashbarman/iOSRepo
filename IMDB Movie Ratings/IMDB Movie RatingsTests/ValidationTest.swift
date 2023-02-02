//
//  ValidationTest.swift
//  IMDB Movie RatingsTests
//
//  Created by Himangshu Barman on 02/02/23.
//

import XCTest
@testable import IMDB_Movie_Ratings


final class ValidationTest: XCTestCase {

    func test_Validation_With_MinimumLength_Returns_Validation_Pass() {
        
        let searchValidator = SearchEntryValidator()
        let result = searchValidator.validate(query: "32nd:")
        
        XCTAssertTrue(result)
    }
    
    func test_Validation_With_MaximumLength_Returns_Validation_Failure() {
        
        let searchValidator = SearchEntryValidator()
        let result = searchValidator.validate(query: "dsan")
        
        XCTAssertFalse(result)
    }
}
