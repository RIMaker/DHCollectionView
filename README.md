<p align="center">
<img src="Resources/DHCollectionView-logo.png" alt="DHCollectionView" title="DHCollectionView" width="557"/>
</p>

<p align="center">
<img src="https://img.shields.io/badge/Swift-5.0-red">
<img src="https://img.shields.io/badge/iOS-13.0-blue">
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
- [x] Placeholder view for empty data.

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
- First you should create your own cell and inherit from DHCell:

```swift
import DHCollectionView

final class MyCell: DHCell {
    func update(with data: DHCellModelData?) {
        guard let data = data as? MyCellData else { return }
        //below update your cell data
    }
}
```

MyCellData looks like:

```swift
import DHCollectionView

struct MyCellData: DHCellModelData {
    //your data properties
}
```

- Creating header/footer is equal to cell creating:
  
```swift
import DHCollectionView

final class MyHeader: DHSupplementaryElement {
    func update(with data: DHSupplementaryElementModelData?) {
        guard let data = data as? MyHeaderData else { return }
        //below update your header data
    }
}
```
```swift
import DHCollectionView

struct MyHeaderData: DHSupplementaryElementModelData {
    //your data properties
}
```

- Add `DHCollectionView` to subviews of your `UIViewController`'s view.

- For displaying `MyCell` and `MyHeader` on `DHCollectionView` make a section - `DHSectionWrapper`, cellModels - `[DHCellModel]` and supplementaryElementModels - `DHSupplementaryElementsModel`:
```swift
import DHCollectionView

final class MyViewController: UIViewController {

    private var dataModels: [DataModel]?

    private lazy var collectionView = DHCollectionView()

    override func loadView() {
        view = collectionView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }

    private func updateViews() {
        guard let dataModels, !dataModels.isEmpty else {
            collectionView.showPlaceholder(
                withImage: UIImage(named: "placeholderImage"),
                withTitle: "placeholder title",
                withMessage: "placeholder message"
            )
            return
        }
        collectionView.hidePlaceholder()

        let cellModels = dataModels?.map {
            DHCellModel(
                data: MyCellData(),
                cellType: MyCell.self
            )
        }
        let headerModel = DHHeaderModel(
            data: MyHeaderData(),
            viewType: MyHeader.self
        )
        let section = DHSectionWrapper(
            sectionId: 0,
            sectionInsets: DHSectionInsets(top: 0, left: 16, bottom: 0, right: 16),
            scrollDirection: .vertical(align: .center(columns: 2)),
            spacing: 16,
            hasScalingEffectOnSelect: true
        )
        let sectionData = DHSectionData(
            cellModels: cellModels,
            supplementaryElementModels:
                DHSupplementaryElementsModel(
                    header: headerModel,
                    footer: nil
                )
        )
        
        collectionView.display(withSectionsData: [section : sectionData])
    }
}
```

- `NOTE: Sections will be sorted by 'sectionId' property. 'sectionId' should be a unique across different sections (sections with same 'sectionId' are equal).`
  
- If no data show placeholder view:
```swift
collectionView.showPlaceholder(
    withImage: UIImage(named: "placeholderImage"),
    withTitle: "placeholder title",
    withMessage: "placeholder message"
)
```

- If there is no need to use a header or footer:
```swift
let sectionData = DHSectionData(
    cellModels: cellModels,
    supplementaryElementModels: .noModel
)
```

- If there are many sections make a `enum CustomSection` with `Int` RawValue and conforms to `CaseIterable`. If sections count is dynamic make your sections inside `for` loop.

- `DHCollectionView` properties:
  - `var didSelectItemAt: ((_ model: DHCellModel?, _ indexPath: DHIndexPath) -> ())?`
  - `var willDisplayCellAt: ((_ cell: UICollectionViewCell, _ indexPath: DHIndexPath) -> ())?`
  - `var didEndDisplayingCellAt: ((_ cell: UICollectionViewCell, _ indexPath: DHIndexPath) -> ())?`
  - `var willDisplaySupplementaryViewAt: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind, _ indexPath: DHIndexPath) -> ())?`
  - `var didEndDisplayingSupplementaryViewAt: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind, _ indexPath: DHIndexPath) -> ())?`
  - `var didScroll: ((_ scrollView: UIScrollView) -> ())?`
  - `var supplementaryViewHandler: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind, _ indexPath: DHIndexPath) -> ())?` - to configure supplementary view.
  - `var cellHandler: ((_ cell: UICollectionViewCell, _ indexPath: DHIndexPath) -> ())?` - to configure cell view.
  - `var onTopRefresh: (() -> ())?` - to add refresh control to view.
  - `private(set) var collectionView: UICollectionView` - to configure collection view.
  - `private(set) var refreshControl: UIRefreshControl` - to configure refresh control view.
  - `private(set) var placeholderView: UIView` - to configure placeholder view.
  - `private(set) var placeholderImageView: UIImageView` - to configure placeholder image view.
  - `private(set) var placeholderLabel: UILabel ` - to configure placeholder message label view.
 
- `DHCollectionView` methods:
  - `func display(withSectionsData sectionsData: [DHSectionWrapper: DHSectionData])` - display on collection view given data (sections will be sorted by `sectionId` property).
  - `func scrollToBottom()` - scroll to bottom side of collection view.
  - `func showPlaceholder(withImage image: UIImage?, withTitle title: String?, withMessage message: String?)` - show placeholder view with custom image, title and message.
  - `func hidePlaceholder()` - show collection view.
 
- You can customize these properties of the `DHCollectionView`:
  - `backgroundColor`
  - `placeholderImageViewHeight`
  - `placeholderImageViewWidth` 
  - `refreshControlTintColor` 
  - `placeholderViewBackgroundColor` 
  - `placeholderTitleLabelTextColor`
  - `placeholderTitleLabelTextAlignment`
  - `placeholderTitleLabelFont`
  - `placeholderMessageLabelTextColor`
  - `placeholderMessageLabelTextAlignment`
  - `placeholderMessageLabelFont`
  - `cellEstimatedSize`
  - `supplementaryItemsEstimatedSize`
  - `downScale` - the scale of scaling effect on select cell.

- You can change them through each instance of `DHCollectionView` or via `UIAppearance` like this for example:
```swift
DHCollectionView.appearance().backgroundColor = .red
DHCollectionView.appearance().placeholderImageViewHeight = 200
DHCollectionView.appearance().placeholderImageViewWidth = 200
```
