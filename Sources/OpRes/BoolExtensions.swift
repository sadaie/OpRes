//
//  BoolExtensions.swift
//  OpRes
//
// This software licensed under the MIT LICENSE.
// See LICENSE file in the project root for full license information.
//

extension Bool {
    public func map<T>(_ f: (Bool) throws -> T) rethrows -> T {
        return try f(self)
    }
    
    public func then<T>(_ f: () -> T) -> T? {
        if self {
            return f()
        } else {
            return nil
        }
    }
    
    public func otherwise<T>(_ f: () -> T) -> T? {
        if !self {
            return f()
        } else {
            return nil
        }
    }
    
    public func `if`<T>(then f: () -> T, else g: () -> T) -> T {
        if self {
            return f()
        } else {
            return g()
        }
    }
}
