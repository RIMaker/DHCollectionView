<p align="center">
<img src="Resources/DHCollectionView-logo.png" alt="DHCollectionView" title="DHCollectionView" width="557"/>
</p>

<p align="center">
<img src="https://img.shields.io/badge/Swift-13.0-red">
<a href="https://github.com/RIMaker/DHCollectionView/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-black"></a>
</p>

UICollectionView with simple usage for cell's dynamic size

## Features

- [x] Vertical/Horizontal scrolling sections.
- [x] Left align section.
- [x] Dynamic height for cells.
- [x] Dynamic width for cells in horizontal sections (optional).
- [x] Scaling effect on select cell.
- [x] Columns number is settable.

### Installation
#### CocoaPods

```ruby
# platform :ios, '13.0'

target 'MyApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyApp
  pod 'DHCollectionView'

end
```

### Usage
```swift
import DHCollectionView

let url = URL(string: "https://example.com/image.png")
imageView.kf.setImage(with: url)
```
