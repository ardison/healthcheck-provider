import XCTest
@testable import Vapor
import Testing
@testable import HealthcheckProvider

final class HealthcheckProviderTests: XCTestCase {
    
    override func setUp() {
        Testing.onFail = XCTFail
    }
    
    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HealthcheckProvider().text, "Hello, World!")
    } */

    func testHealthCheck() {
        var config = try! Config(arguments: ["vapor", "--env=test"])
        try! config.set("healthcheck.url", "healthcheck")
        try! config.addProvider(HealthcheckProvider.Provider.self)
        let drop = try! Droplet(config)
        background {
            try! drop.run()
        }
        
        try! drop
            .testResponse(to: .get, at: "healthcheck")
            .assertStatus(is: .ok)
            .assertJSON("status", equals: "up")
    }
    
    static var allTests = [
        ("testHealthCheck", testHealthCheck),
    ]
}
