# TogglableSecureField
**SwiftUI password field with show/hide feature**

<img src="https://raw.githubusercontent.com/perfaram/TogglableSecureField/main/Demo/demo.gif" height="450" alt="TogglableSecureField demo"/>

## What
Description

## Why?
SwiftUI is great, but currently it's anything but straightforward to build a password input control that can show its content. Most solutions end up using a `Binding<Bool>` to control which field to show, and a conditional in the view builder. This requires hackery to transfer the keyboard focus or keep cursor position, and tends to make the UI stutter when toggling between states. 
`TogglableSecureField` solves the problem by wrapping a UITextField in a UIViewRepresentable, in an elegant manner. `TogglableSecureField` also preserves `TextField`/`SecureField`'s natural accessibility features. 

## How
This package requires iOS 13 at least.

### Installation
Through [Swift Package Manager](https://swift.org/package-manager/), either:
* manually, by adding it to the `dependencies` of your `Package.swift`
    ```swift
    dependencies: [
          .package(url: "https://github.com/badrinathvm/StepperView.git", from: "1.6.7")
    ]
    ```
* or via XCode, by adding it as a package dependency:
    1. from the File menu, select Add Packages...
    2. Enter "https://github.com/perfaram/TogglableSecureField" into the package repository URL text field,
    3. Add TogglableSecureField to the appropriate target.

### Usage
First, `import TogglableSecureField`. Then, drop `TogglableSecureField` instead of `SecureField`:
```swift
TogglableSecureField("Password",
                     secureContent: $password,
                     onCommit: {
    guard !password.isEmpty else { return }
    print("User gave \(password) as password")
})
```
The `onCommit` closure is called when the user validates their input (using the keyboard's "Done" button). At any time, the current input is accessible through the `secureContent` binding. 
Just like SwiftUI's `TextField`/`SecureField`, the first argument passed to the initializer will be used as an accessibility label.

> Note that the provided [demo app](https://github.com/perfaram/TogglableSecureField/main/Demo) showcases most features! 

### Features
#### `leftView`
The `TogglableSecureField` initializer also supports providing an accessory view, akin to `UITextField.leftView`. For instance, this will display a simple lock on the left of the text field.
```swift
TogglableSecureField("Password",
                     secureContent: $password,
                     leftView: {
                        Image(systemName: "lock.fill")
                            .foregroundColor($password.wrappedValue.isEmpty ? .secondary : .primary)
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .frame(width: 18, height: 18, alignment: .center)
                            .accessibilityHidden(true)
                     },
                     onCommit: {
                        guard !password.isEmpty else { return }
                            print("User gave \(password) as password")
})
.padding(10)
.background(Color.primary.opacity(0.05).cornerRadius(10))
.padding()
```
One could envision using this to show the count of failed login attempts, or an indicator of whether the password respects complexity rules.

#### `BindableSecureField`
If you don't want to use the provided toggle button, this package also provides a `BindableSecureField`, whose visibility is controlled by a binding.  

#### `.useMonospacedFont()`
`.useMonospacedFont()` is a modifier available on `TogglableSecureField` and `BindableSecureField` that, you guessed it, changes the font to a monospace font. Because every character has the same width, toggling between "bullets" / secure password mode and plain text then preserves the characters' positions. It is then straightforward for the user to visually map the "bullets" to their underlying characters. This is perhaps desirable from a UX perspective. 
