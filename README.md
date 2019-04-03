# `OpRes`

`OpRes.framework` is tiny library to extend Swift's `Optional` and `Result` type to be Rust lang style.

## Install

### With [`Carthage`](https://github.com/Carthage/Carthage)

Add this line to your `Cartfile`.

```
github "sadaie/OpRes"
```

### With [`CocoaPods`](https://github.com/CocoaPods/CocoaPods)

Add This line to your `Podfile`.

```
pod 'OpRes'
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