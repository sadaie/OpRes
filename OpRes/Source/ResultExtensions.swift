//
//  ResultExtensions.swift
//  OpRes
//
// This software licensed under the MIT LICENSE.
// See LICENSE file in the project root for full license information.
//

extension Result {
    /// Returns true if the result is a `.success`.
    public var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    /// Returns true if the result is a `.failure`.
    public var isFailure: Bool {
        return !self.isSuccess
    }
    
    /// Returns the success value if the result is a `.success`, otherwise nil.
    public var success: Success? {
        switch self {
        case .success(let s):
            return s
        case .failure(_):
            return nil
        }
    }
    
    /// Returns the error value if the result is a `.failure`, otherwise nil.
    public var failure: Failure? {
        switch self {
        case .success(_):
            return nil
        case .failure(let e):
            return e
        }
    }
    
    /// Unwraps an result, yielding the content of a `.success`.
    /// If the result is `.failure`, `fatalError` will be called with the `message` parameter.
    ///
    /// - Parameter message: An message to be print if the result is `.failure`.
    /// - Returns: the success value.
    public func expect(_ message: String) -> Success {
        switch self {
        case .success(let s):
            return s
        case .failure(let e):
            fatalError("\(message): \(e)")
        }
    }
    
    /// Unwraps a result.
    /// If the result is `.failure`, `fatalError` will be called.
    ///
    /// - Returns: the success value.
    public func unwrap() -> Success {
        switch self {
        case .success(let s):
            return s
        case .failure(let e):
            fatalError("\(e)")
        }
    }
    
    /// Returns the success value or a default.
    ///
    /// - Parameter default: A value to be returned if the result is `.failure`.
    /// - Returns: the success value or a default.
    public func unwrap(or default: Success) -> Success {
        switch self {
        case .success(let s):
            return s
        case .failure(_):
            return `default`
        }
    }
    
    /// Returns the success value or computes it from a closure.
    ///
    /// - Parameter f: A function to be evaluated if the result is `.failure`.
    /// - Returns: Success value or a default computed by the given closure.
    public func unwrap(or f: (Failure) -> Success) -> Success {
        switch self {
        case .success(let s):
            return s
        case .failure(let e):
            return f(e)
        }
    }
    
    /// Returns `.failure` if the result is `.failure`, otherwise returns `optb`.
    ///
    /// - Parameter optb: Another result to be returned if the result is `.success`.
    /// - Returns: `optb` or `.failure`.
    public func and<T>(_ res: Result<T, Failure>) -> Result<T, Failure> {
        switch self {
        case .success(_):
            return res
        case .failure(let e):
            return .failure(e)
        }
    }
    
    /// Returns `.failure` if the result is `.failure`, otherwise calls `f` with the success value and returns the result.
    /// This is equivalent to `flatMap`.
    ///
    /// - Parameter f: A function to be evaluated if the result is `.failure`.
    /// - Returns: Transformed value or `.failure`.
    public func and<T>(_ f: (Success) -> Result<T, Failure>) -> Result<T, Failure> {
        switch self {
        case .success(let s):
            return f(s)
        case .failure(let e):
            return .failure(e)
        }
    }
    
    /// Returns the result if it is `.success`, otherwise returns `optb`.
    ///
    /// - Parameter optb: Another result to be returned if the result is `.failure`.
    /// - Returns: The result or `optb`.
    public func or<F>(_ res: Result<Success, F>) -> Result<Success, F> where F: Error {
        switch self {
        case .success(let s):
            return .success(s)
        case .failure(_):
            return res
        }
    }
    
    /// Returns the result if it is `.success`, otherwise calls `f` and returns the result.
    ///
    /// - Parameter f: A function to be evaluated if the result is `.failure`.
    /// - Returns: The result or the result of `f`.
    public func or<F>(_ f: (Failure) -> Result<Success, F>) -> Result<Success, F> where F: Error {
        switch self {
        case .success(let s):
            return .success(s)
        case .failure(let e):
            return f(e)
        }
    }
    
    /// Transposes a `Result` of an `Optional` into an `Optional` of a `Result`.
    ///
    /// `.success(.none)` will be mapped to `.none`.
    /// `.success(.some(_))` and `.failure(_)` will be mapped to `.some(.success(_))` and `.some(.failure(_))`.
    /// - Returns: Transposed value.
    public func transpose<T>() -> Result<T, Failure>? where Success == T? {
        switch self {
        case .success(.some(let s)):
            return .success(s)
        case .success(.none):
            return nil
        case .failure(let e):
            return .failure(e)
        }
    }
}

extension Result where Success: CustomStringConvertible {
    /// Unwraps a result, yielding the content of a `.failure`.
    ///
    /// If the result is `.success`, `fatalError` will be called.
    /// - Returns: The content of the `.failure`.
    public func unwrapError() -> Failure {
        switch self {
        case .success(let s):
            fatalError("called Result.unwrapError() on a .success value: \(s.description)")
        case .failure(let e):
            return e
        }
    }
    
    /// Unwraps a result, yielding the content of a `.failure`.
    ///
    /// If the result is `.success`, `fatalError` will be called with the given `message` parameter.
    /// - Returns: The content of the `.failure`.
    public func expectError(_ message: String) -> Failure {
        switch self {
        case .success(let s):
            fatalError("\(message): \(s.description)")
        case .failure(let e):
            return e
        }
    }
}
