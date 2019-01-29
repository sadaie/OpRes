# `RustyOptionalType`

`RustyOptionalType.framework` is tiny library to extend Swift's `Optional` type to be Rust lang style.

## Install

### With [`Carthage`](https://github.com/Carthage/Carthage)

Add this line to your `Cartfile`.

```
github "sadaie/RustyOptionalType"
```

## Usage

```swift
import RustyOptionalType

let option: Int? = 10
// The first statement is equivalent to the second one.
let x: Int = option.map { $0 * 10 } ?? 0
let y: Int = option.map(or: 0) { $0 * 10 }

print(x == y) // prints `true`
```

## License

MIT lincense.  