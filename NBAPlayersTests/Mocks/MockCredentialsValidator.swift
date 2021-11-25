//
//  MockCredentialsValidator.swift
//  CombineDemoTests
//
//

import Foundation
@testable import CombineDemo

final class MockCredentialsValidator: CredentialsValidatorProtocol {
    // MARK: - validateCredentials
    var validateCredentialsCalled = false
    var validateCredentialsClosure: ((@escaping (Result<(), Error>) -> Void) -> Void)?
    
    func validateCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<(), Error>) -> Void
    ) {
        validateCredentialsCalled = true
        validateCredentialsClosure?(completion)
    }
}
