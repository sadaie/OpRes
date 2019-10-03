# `OpRes`

`OpRes.framework` is tiny library to extend Swift's `Optional` and `Result` type to be Rust lang style.

## Install

**If you want to use `Carthage` or `CocoaPods`, please use the commitment tagged `0.5.6` .**

### With `Swift Package Manager`

Add this lines to your `Package.swift` or set to the setting in Xcode.

```swift
dependencies: [
    .package(
        url: "https://github.com/sadaie/OpRes.git",
        from: "1.0.0"
    )
]
```

## Usage

Please see `OpResTests/OpResTests.swift` to know more details.

### `Optional`

```swift
import OpRes

let option: Int? = 10
// The first statement is equivalent to the second one.
let x: Int = option.map { $0 * 10 } ?? 0
let y: Int = option.map(or: 0) { $0 * 10 }

print(x == y) // prints `true`
```

### `Result`

```swift
import OpRes

enum MyError: Error {
    case someError
}

let option: Int? = 10
let result: Result<Int, MyError> = option.map { $0 * 10 }.ok(or: .someError)
let x: Int = option.map { $0 * 10 }.expect("should be unwrapped")
let y: Int = result.expect("should be unwrapped")

print(x == y) // prints `true`
```

## License

MIT license.  
