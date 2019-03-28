//
//  OptionalExtensions.swift
//  OpRes
//
// This software licensed under the MIT LICENSE.
// See LICENSE file in the project root for full license information.
//

extension Optional {
    /// Returns true if the option is a `some` value.
    public var isSome: Bool {
        switch self {
        case .some(_):
            return true
        case .none:
            return false
        }
    }
    
    /// Returns true if the option is a `none` value.
    public var isNone: Bool {
        return !self.isSome
    }
    
    /// Unwraps an option, yielding the content of a `some`.
    ///
    /// - Parameter message: An message to be print if the option is `none`.
    /// - Returns: Wrapped value.
    public func expect(_ message: String) -> Wrapped {
        if self.isSome {
            return self!
        } else {
            fatalError(message)
        }
    }
    
    /// Unwraps an option. This is equivalent to the `Forced Unwrapping`.
    ///
    /// - Returns: Wrapped value.
    public func unwrap() -> Wrapped {
        return self!
    }
    
    /// Returns the contained value or a default.
    ///
    /// - Parameter default: A value to be returned if the option is `none`.
    /// - Returns: Wrapped value or a default.
    public func unwrap(or default: Wrapped) -> Wrapped {
        if self.isSome {
            return self!
        } else {
            return `default`
        }
    }
    
    /// Returns the contained value or computes it from a closure.
    ///
    /// - Parameter f: A function to be evaluated if the option is `none`.
    /// - Returns: Wrapped value or a default
    public func unwrap(or f: () throws -> Wrapped) rethrows -> Wrapped {
        if self.isSome {
            return self!
        } else {
            return try f()
        }
    }
    
    /// Applies a function to the contained value (if any), or returns the provided default (if not).
    ///
    /// - Parameters:
    ///   - default: A default value to be returned if the option is `none`.
    ///   - transform: A function to be evaluated if the option is `some`.
    /// - Returns: Mapped or default value.
    /// - Throws: Throws an error if `f` throws an error.
    public func map<U>(or default: U, transform: (Wrapped) throws -> U) rethrows -> U {
        if self.isSome {
            return try transform(self!)
        } else {
            return `default`
        }
    }
    
    /// pplies a function to the contained value (if any), or computes a default (if not).
    ///
    /// - Parameters:
    ///   - default: A default function to be evaluated if the option is `none`.
    ///   - transform: A function to be evaluated if the option is `some`.
    /// - Returns: Mapped or default value
    /// - Throws: Throws an error if `f` throws an error.
    public func map<U>(or default: () throws -> U, transform: (Wrapped) throws -> U) rethrows -> U {
        if self.isSome {
            return try transform(self!)
        } else {
            return try `default`()
        }
    }
    
    /// Returns the wrapped value if the option is `some`, otherwise returns given error.
    ///
    /// - Parameter error: An error to be thrown if the option is `none`.
    /// - Returns: A result value.
    public func ok<E>(or error: E) -> Result<Wrapped, E> where E: Error {
        switch self {
        case let .some(w):
            return .success(w)
        case .none:
            return .failure(error)
        }
    }
    
    /// Returns the wrapped value if the option is `some`, otherwise returns an error returned from the given closure.
    ///
    /// - Parameter error: A function to be evaluated if the option is `none`.
    /// - Returns: A result value.
    public func ok<E>(or f: () -> E) -> Result<Wrapped, E> where E: Error {
        switch self {
        case let .some(w):
            return .success(w)
        case .none:
            return .failure(f())
        }
    }
    
    /// Returns `none` if the option is `none`, otherwise returns `optb`.
    ///
    /// - Parameter optb: Another optional value to be returned if the option is `some`.
    /// - Returns: `optb` or `none`.
    public func and<T>(_ optb: T?) -> T? {
        if self.isSome {
            return optb
        } else {
            return nil
        }
    }
    
    /// Returns `none` if the option is `none`, otherwise calls `f` with the wrapped value and returns the result.
    /// This is equivalent to `flatMap`.
    ///
    /// - Parameter f: A function to be evaluated if the option is `none`.
    /// - Returns: Transformed value or `none`.
    /// - Throws: Throws an error if `f` throws an error.
    public func and<U>(_ f: (Wrapped) throws -> U?) rethrows -> U? {
        return try flatMap(f)
    }
    
    /// Returns `none` if the option is `none`, otherwise calls predicate with the wrapped value and returns:
    /// - `some(t)` if predicate returns true (where `t` is the wrapped value), and
    /// - `none` if predicate returns false.
    ///
    /// - Parameter predicate: A function to be evaluated if the option is `some`.
    /// - Returns: Wrapped value or `none`.
    /// - Throws: Throws an error if `predicate` throws an error.
    public func filter(_ predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        if try self.isSome && predicate(self!) {
            return self
        } else {
            return nil
        }
    }
    
    /// Returns the option if it contains a value, otherwise returns `optb`.
    ///
    /// - Parameter optb: Another option value to be returned if the option is `none`.
    /// - Returns: The option or `optb`.
    public func or(_ optb: Wrapped?) -> Wrapped? {
        if self.isSome {
            return self
        } else {
            return optb
        }
    }
    
    /// Returns the option if it contains a value, otherwise calls `f` and returns the result.
    ///
    /// - Parameter f: A function to be evaluated if the option is `none`.
    /// - Returns: The option or the result of `f`.
    /// - Throws: Throws an error if `f` throws an error.
    public func or(_ f: () throws -> Wrapped?) rethrows -> Wrapped? {
        if self.isSome {
            return self
        } else {
            return try f()
        }
    }
    
    /// Returns `some` if exactly one of self, `optb` is `some`, otherwise returns `none`.
    ///
    /// - Parameter optb: Another option to be returned if the option is `none` *AND* `optb` is `some`.
    /// - Returns: The option, `optb` or `none`.
    public func xor(_ optb: Wrapped?) -> Wrapped? {
        switch (self.isSome, optb.isSome) {
        case (true, false):
            return self
        case (false, true):
            return optb
        default:
            return nil
        }
    }
    
    /// Inserts `value` into the option if it is `none`, then returns a mutable reference to the contained value.
    ///
    /// - Parameter value: A value to be inserted if the option is `none`.
    /// - Returns: A mutable reference to the wrapped value.
    public mutating func getOrInsert(_ value: Wrapped) -> UnsafeMutablePointer<Wrapped> {
        if self.isSome {
            return UnsafeMutablePointer(mutating: &self!)
        } else {
            self = .some(value)
            return UnsafeMutablePointer(mutating: &self!)
        }
    }
    
    /// Inserts a value computed from `f` into the option if it is `none`, then returns a mutable reference to the contained value.

    ///
    /// - Parameter f: A function to be evaluated if the option is `none`.
    /// - Returns: A mutable reference to the wrapped value.
    /// - Throws: Throws an error if `f` throws an error.
    public mutating func getOrInsert(_ f: () throws -> Wrapped) rethrows -> UnsafeMutablePointer<Wrapped> {
        if self.isSome {
            return UnsafeMutablePointer(mutating: &self!)
        } else {
            let value = try f()
            self = .some(value)
            return UnsafeMutablePointer(mutating: &self!)
        }
    }
    
    /// Takes the value out of the option, leaving a `none` in its place.
    ///
    /// - Returns: Wrapped value or `none`.
    public mutating func take() -> Wrapped? {
        if self.isSome {
            let value = self!
            self = .none
            return value
        } else {
            return nil
        }
    }
    
    /// Replaces the actual value in the option by the value given in parameter, returning the old value if present, leaving a Some in its place without deinitializing either one.
    ///
    /// - Parameter value: A value to be replaced.
    /// - Returns: Old wrapped value.
    public mutating func replace(_ value: Wrapped) -> Wrapped? {
        let old = self
        self = .some(value)
        return old
    }
    
    /// Transposes an `Optional` of a `Result` into a `Result` of an `Optional`.
    ///
    /// `.none` will be mapped to `.success(.none)`.
    /// `.some(.success(_))` and `.some(.failure(_))` will be mapped to `.success(.some(_))` and `.failure(_)`.
    /// - Returns: Transposed value.
    public func transpose<T, E>() -> Result<T?, E> where Wrapped == Result<T, E>, E: Error {
        switch self {
        case .some(.success(let s)):
            return .success(s)
        case .some(.failure(let e)):
            return .failure(e)
        case .none:
            return .success(nil)
        }
    }
}
