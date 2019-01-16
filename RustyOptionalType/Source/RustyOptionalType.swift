//
//  RustyOptionalType.swift
//  RustyOptionalType
//
//  Created by Sadaie Matsudaira on 2019/01/11.
//  Copyright © 2019 Sadaie Matsudaira. All rights reserved.
//

extension Optional {
    public var isSome: Bool {
        switch self {
        case .some(_):
            return true
        case .none:
            return false
        }
    }
    
    public var isNone: Bool {
        return !self.isSome
    }
    
    public func expect(_ message: String) -> Wrapped {
        if self.isSome {
            return self!
        } else {
            fatalError(message)
        }
    }
    
    public func unwrap() -> Wrapped {
        return self!
    }
    
    public func unwrap(or default: Wrapped) -> Wrapped {
        if self.isSome {
            return self!
        } else {
            return `default`
        }
    }
    
    public func unwrap(or f: () throws -> Wrapped) rethrows -> Wrapped {
        if self.isSome {
            return self!
        } else {
            return try f()
        }
    }
    
    public func map<U>(or default: U, transform: (Wrapped) throws -> U) rethrows -> U {
        if self.isSome {
            return try transform(self!)
        } else {
            return `default`
        }
    }
    
    public func map<U>(or default: () throws -> U, transform: (Wrapped) throws -> U) rethrows -> U {
        if self.isSome {
            return try transform(self!)
        } else {
            return try `default`()
        }
    }
    
    public func ok(or error: Error) throws -> Wrapped {
        if self.isSome {
            return self!
        } else {
            throw error
        }
    }
    
    public func ok(or error: () throws -> Error) throws -> Wrapped {
        if self.isSome {
            return self!
        } else {
            throw try error()
        }
    }
    
    public func and<T>(_ optb: T?) -> T? {
        if self.isSome {
            return optb
        } else {
            return nil
        }
    }
    
    public func and<U>(then f: (Wrapped) throws -> U?) rethrows -> U? {
        return try flatMap(f)
    }
    
    public func filter(_ predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        if try self.isSome && predicate(self!) {
            return self
        } else {
            return nil
        }
    }
    
    public func or(_ optb: Wrapped?) -> Wrapped? {
        if self.isSome {
            return self
        } else {
            return optb
        }
    }
    
    public func or(_ f: () throws -> Wrapped?) rethrows -> Wrapped? {
        if self.isSome {
            return self
        } else {
            return try f()
        }
    }
    
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
    
    public mutating func getOrInsert(_ value: Wrapped) -> Wrapped {
        if self.isSome {
            return self!
        } else {
            self = .some(value)
            return value
        }
    }
    
    public mutating func getOrInsert(_ f: () throws -> Wrapped) rethrows -> Wrapped {
        if self.isSome {
            return self!
        } else {
            let value = try f()
            self = .some(value)
            return value
        }
    }
    
    public mutating func take() -> Wrapped? {
        if self.isSome {
            let value = self!
            self = .none
            return value
        } else {
            return nil
        }
    }
    
    public mutating func replace(_ value: Wrapped) -> Wrapped? {
        let old = self
        self = .some(value)
        return old
    }
}
