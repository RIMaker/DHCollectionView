//
//  DHCollectionView.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

public class DHCollectionView: UIView  {
    
    //MARK: Appearance
    @objc fileprivate dynamic var collectionViewBackgroundColor = DHConstant.UI.backgroundColor {
        willSet { collectionView.backgroundColor = newValue }
    }

    public override var backgroundColor: UIColor? {
        get { return collectionViewBackgroundColor }
        set { collectionViewBackgroundColor = newValue! }
    }

    @objc public dynamic var placeholderImageViewHeight = DHConstant.UI.placeholderImageViewHeight {
        willSet {
            placeholderImageViewHeightConstraint.constant = newValue
            layoutIfNeeded()
        }
    }
    
    @objc public dynamic var placeholderImageViewWidth = DHConstant.UI.placeholderImageViewWidth {
        willSet {
            placeholderImageViewWidthConstraint.constant = newValue
            layoutIfNeeded()
        }
    }
    
    @objc public dynamic var refreshControlTintColor = DHConstant.UI.refreshControlTintColor {
        willSet {
            refreshControl.tintColor = newValue
        }
    }
    
    @objc public dynamic var placeholderViewBackgroundColor = DHConstant.UI.placeholderViewBackgroundColor {
        willSet {
            placeholderView.backgroundColor = newValue
        }
    }
    
    @objc public dynamic var placeholderTitleLabelTextColor = DHConstant.UI.placeholderTitleLabelTextColor {
        willSet {
            placeholderTitleLabel.textColor = newValue
        }
    }
    
    @objc public dynamic var placeholderTitleLabelTextAlignment = DHConstant.UI.placeholderTitleLabelTextAlignment {
        willSet {
            placeholderTitleLabel.textAlignment = newValue
        }
    }
    
    @objc public dynamic var placeholderTitleLabelFont = DHConstant.UI.placeholderTitleLabelFont {
        willSet {
            placeholderTitleLabel.font = newValue
        }
    }
    
    @objc public dynamic var placeholderMessageLabelTextColor = DHConstant.UI.placeholderMessageLabelTextColor {
        willSet {
            placeholderTitleLabel.textColor = newValue
        }
    }
    
    @objc public dynamic var placeholderMessageLabelTextAlignment = DHConstant.UI.placeholderMessageLabelTextAlignment {
        willSet {
            placeholderTitleLabel.textAlignment = newValue
        }
    }
    
    @objc public dynamic var placeholderMessageLabelFont = DHConstant.UI.placeholderMessageLabelFont {
        willSet {
            placeholderTitleLabel.font = newValue
        }
    }
    
    @objc public dynamic var cellEstimatedSize = DHConstant.UI.cellEstimatedSize
    
    @objc public dynamic var supplementaryItemsEstimatedSize = DHConstant.UI.supplementaryItemsEstimatedSize
    
    @objc public dynamic var cellDownScale = DHConstant.Animation.downScale

    
    //MARK: Constraints
    fileprivate var placeholderImageViewHeightConstraint: NSLayoutConstraint!
    fileprivate var placeholderImageViewWidthConstraint: NSLayoutConstraint!
    
    //MARK: Handlers
    public var didSelectItemAt: ((_ model: DHCellModel?, _ indexPath: IndexPath) -> ())?
    public var willDisplayCellAt: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ())?
    public var didEndDisplayingCellAt: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ())?
    public var willDisplaySupplementaryViewAt: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind, _ indexPath: IndexPath) -> ())?
    public var didEndDisplayingSupplementaryViewAt: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind, _ indexPath: IndexPath) -> ())?
    public var didScroll: ((_ scrollView: UIScrollView) -> ())?
    public var supplementaryViewHandler: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind) -> ())?
    public var cellHandler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ())?
    public var onTopRefresh: (() -> ())? {
        didSet {
            addRefreshControl()
        }
    }
    
    //MARK: Views
    public private(set) lazy var collectionView: UICollectionView = {
        let collView = setupCollectionView()
        return collView
    }()
    
    public private(set) lazy var refreshControl: UIRefreshControl = {
        let rControl = UIRefreshControl()
        rControl.tintColor = refreshControlTintColor
        return rControl
    }()
    
    public private(set) lazy var placeholderView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = placeholderViewBackgroundColor
        return view
    }()
    
    public private(set) lazy var placeholderImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public private(set) lazy var placeholderTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = placeholderTitleLabelTextColor
        lbl.textAlignment = placeholderTitleLabelTextAlignment
        lbl.numberOfLines = 0
        lbl.font = placeholderTitleLabelFont
        lbl.sizeToFit()
        return lbl
    }()
    
    public private(set) lazy var placeholderMessageLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = placeholderMessageLabelTextColor
        lbl.textAlignment = placeholderMessageLabelTextAlignment
        lbl.numberOfLines = 0
        lbl.font = placeholderMessageLabelFont
        lbl.sizeToFit()
        return lbl
    }()
    
    //MARK: View models
    private var sections: [DHSectionWrapper] = []
    private var sectionsData: [DHSectionWrapper: DHSectionData] = [:]
    private var cellRegisterIds: Set<String> = []
    private var supplementaryElementRegisterIds: Set<String> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpContent()
    }
    ///display on collection view given data (sections will be sorted by 'sectionId' property)
    public func display(withSectionsData sectionsData: [DHSectionWrapper: DHSectionData]) {
        self.sectionsData = sectionsData
        self.sections = sectionsData.keys.sorted(by: { $0.sectionId < $1.sectionId })
        self.collectionView.reloadData()
    }
    ///scroll to bottom side of collection view
    public func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.bounds.height + collectionView.contentInset.bottom)
        collectionView.setContentOffset(bottomOffset, animated: true)
    }
    ///show placeholder view with custom image, title and message
    public func showPlaceholder(withImage image: UIImage?, withTitle title: String?, withMessage message: String?) {
        placeholderTitleLabel.text = title
        placeholderMessageLabel.text = message
        placeholderImageView.image = image
        placeholderView.isHidden = false
    }
    ///show collection view
    public func hidePlaceholder() {
        placeholderView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

//MARK: - Selectors
private extension DHCollectionView {
    @objc func onTopRefresh(_ sender: UIRefreshControl) {
        endRefreshing()
        onTopRefresh?()
    }
}

//MARK: - Setup views
private extension DHCollectionView {
    func addRefreshControl() {
        if collectionView.refreshControl == nil {
            collectionView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(onTopRefresh(_:)), for: .valueChanged)
        }
    }
    
    func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func setUpContent() {
        addSubview(collectionView)
        collectionView.addSubview(placeholderView)
        
        let placeholderElements = UIStackView(arrangedSubviews: [
            placeholderTitleLabel,
            placeholderMessageLabel,
            placeholderImageView
        ])
        placeholderElements.axis = .vertical
        placeholderElements.distribution = .fill
        placeholderElements.alignment = .center
        placeholderElements.setCustomSpacing(12, after: placeholderTitleLabel)
        placeholderElements.setCustomSpacing(48, after: placeholderMessageLabel)
        
        placeholderView.addSubview(placeholderElements)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderElements.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderImageViewHeightConstraint = placeholderImageView.heightAnchor.constraint(equalToConstant: DHConstant.UI.placeholderImageViewHeight)
        placeholderImageViewWidthConstraint = placeholderImageView.widthAnchor.constraint(equalToConstant: DHConstant.UI.placeholderImageViewWidth)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            placeholderView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            placeholderView.widthAnchor.constraint(equalTo: self.widthAnchor),
            placeholderView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            placeholderElements.topAnchor.constraint(equalTo: placeholderView.topAnchor, constant: 32),
            placeholderElements.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor, constant: 20),
            placeholderElements.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor, constant: -20),
            placeholderElements.bottomAnchor.constraint(lessThanOrEqualTo: placeholderView.bottomAnchor, constant: -20),
            
            placeholderTitleLabel.widthAnchor.constraint(equalTo: placeholderElements.widthAnchor),
            
            placeholderMessageLabel.widthAnchor.constraint(equalTo: placeholderElements.widthAnchor),
            
            placeholderImageViewHeightConstraint,
            placeholderImageViewWidthConstraint,
            placeholderImageView.widthAnchor.constraint(lessThanOrEqualTo: placeholderElements.widthAnchor)
        ])
        
    }
    
    func setupCollectionView() -> UICollectionView {
        let layout = setupCollectionViewLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.backgroundColor = collectionViewBackgroundColor
        colView.translatesAutoresizingMaskIntoConstraints = false
        colView.showsVerticalScrollIndicator = false
        colView.showsHorizontalScrollIndicator = false
        colView.delegate = self
        colView.dataSource = self
        return colView
    }
    
    func setupCollectionViewLayout() -> UICollectionViewLayout {
       
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard sectionIndex < self.sections.count else { return nil }
            
            let mySection = self.sections[sectionIndex]
            let scrollDirection = mySection.scrollDirection
            
            let item = self.setupItem(forSection: mySection)
            
            let group = self.setupGroup(forSection: mySection, withItem: item)
            
            let supplementaryItems = self.setupSupplementaryItems(forSection: mySection)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryItems
            section.interGroupSpacing = mySection.spacing
            section.contentInsets = mySection.sectionInsets.getInsets()
            if case .horizontal(let enableDynamicWidth,_) = scrollDirection {
                section.orthogonalScrollingBehavior = enableDynamicWidth ? .continuous: .continuousGroupLeadingBoundary
            }
            
            return section
        }
        
        return layout
    }
    
    func setupItem(forSection section: DHSectionWrapper) -> NSCollectionLayoutItem {
        
        let scrollDirection = section.scrollDirection
        let widthDimension: NSCollectionLayoutDimension
        let heightDimension: NSCollectionLayoutDimension = .estimated(cellEstimatedSize)
        
        switch scrollDirection {
        case .vertical(let align):
            switch align {
            case .center:
                widthDimension = .fractionalWidth(1.0)
            case .left:
                widthDimension = .estimated(cellEstimatedSize)
            }
        case .horizontal(let enableDynamicWidth, _):
            widthDimension = enableDynamicWidth ? .estimated(cellEstimatedSize): .fractionalWidth(1.0)
        }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: widthDimension,
            heightDimension: heightDimension
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    func setupGroup(forSection section: DHSectionWrapper, withItem item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let scrollDirection = section.scrollDirection
        let widthDimension: NSCollectionLayoutDimension
        let heightDimension: NSCollectionLayoutDimension = .estimated(cellEstimatedSize)
        
        switch scrollDirection {
        case .vertical(_):
            widthDimension = .fractionalWidth(1.0)
        case .horizontal(let enableDynamicWidth, _):
            widthDimension = enableDynamicWidth ? .estimated(cellEstimatedSize): .fractionalWidth(1.0)
        }
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: widthDimension,
            heightDimension: heightDimension
        )
        
        let group: NSCollectionLayoutGroup
        switch scrollDirection {
        case .horizontal(_, let columns):
            group = .vertical(
                layoutSize: groupSize,
                subitems: (0..<columns).map{_ in item}
            )
        case .vertical(let align):
            switch align {
            case .center(let columns):
                group = .horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: columns
                )
            case .left:
                group = .horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
            }
        }
        
        group.interItemSpacing = .fixed(section.spacing)
        
        return group
    }
    
    func setupSupplementaryItems(forSection section: DHSectionWrapper) -> [NSCollectionLayoutBoundarySupplementaryItem] {
        
        let scrollDirection = section.scrollDirection
        let widthDimension: NSCollectionLayoutDimension
        let heightDimension: NSCollectionLayoutDimension = .estimated(supplementaryItemsEstimatedSize)
        
        switch scrollDirection {
        case .vertical(let align):
            switch align {
            case .center:
                widthDimension = .fractionalWidth(1.0)
            case .left:
                widthDimension = .estimated(supplementaryItemsEstimatedSize)
            }
        case .horizontal(let enableDynamicWidth, _):
            widthDimension = enableDynamicWidth ? .estimated(supplementaryItemsEstimatedSize): .fractionalWidth(1.0)
        }
        
        let footerHeaderSize = NSCollectionLayoutSize(
            widthDimension: widthDimension,
            heightDimension: heightDimension
        )
        
        var supplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem]()
        if let _ = self.sectionsData[section]?.supplementaryElementModels.header {
            supplementaryItems.append(NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            )
        }
        if let _ = self.sectionsData[section]?.supplementaryElementModels.footer {
            supplementaryItems.append(NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerHeaderSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom)
            )
        }
        return supplementaryItems
    }
}

//MARK: - CollectionView items configuration
extension DHCollectionView {
    func supplementaryElement(indexPath: IndexPath, model: DHSupplementaryElementModelContract) -> UICollectionReusableView {
        
        let kind = model.kind == .footer ? UICollectionView.elementKindSectionFooter: UICollectionView.elementKindSectionHeader
        
        if !supplementaryElementRegisterIds.contains(model.reusableId()) {
            supplementaryElementRegisterIds.insert(model.reusableId())
            
            collectionView.register(
                model.viewType,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: model.reusableId()
            )
        }
        
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: model.reusableId(),
            for: indexPath
        )
    }
    
    func cell(indexPath: IndexPath, model: DHCellModel) -> UICollectionViewCell {
        if !cellRegisterIds.contains(model.id) {
            cellRegisterIds.insert(model.id)
            
            collectionView.register(
                model.cellType,
                forCellWithReuseIdentifier: model.id
            )
        }
        
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: model.id,
            for: indexPath
        )
    }
    
    func getCellModelAt(_ indexPath: IndexPath) -> DHCellModel? {
        guard indexPath.section < sections.count else { return nil }
        
        let section = sections[indexPath.section]
        
        guard
            let dhCellModels = self.sectionsData[section]?.cellModels,
            indexPath.item < dhCellModels.count
        else {
            return nil
        }
        
        let cellModel = dhCellModels[indexPath.item]
        
        return cellModel
    }
    
    func getSupplementaryElementModelAt(_ indexPath: IndexPath, kind: String) -> DHSupplementaryElementModelContract? {
        guard indexPath.section < sections.count else { return nil }
        
        let kind: DHSupplementaryElementKind = kind == UICollectionView.elementKindSectionHeader ? .header: .footer
        let section = sections[indexPath.section]
        
        guard
            let supplementaryElementsModel = self.sectionsData[section]?.supplementaryElementModels
        else {
            return nil
        }
        
        switch kind {
        case .header:
            return supplementaryElementsModel.header
        case .footer:
            return supplementaryElementsModel.footer
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DHCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        
        let dhSection = sections[section]
        
        guard let dhCellModels = self.sectionsData[dhSection]?.cellModels else { return 0 }
        
        return dhCellModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let model = getCellModelAt(indexPath) else {
            return UICollectionViewCell()
        }
        let cell = cell(indexPath: indexPath, model: model)
        
        cellHandler?(cell, indexPath)
        
        if let cell = cell as? DHCellInput {
            cell.update(with: model.data)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = getCellModelAt(indexPath), indexPath.section < sections.count else {
            didSelectItemAt?(nil, indexPath)
            return
        }
        let section = sections[indexPath.section]
        if let cell = collectionView.cellForItem(at: indexPath), section.hasScalingEffectOnSelect {
            cell.makeScale(cellDownScale, cellDownScale, completion: {
                cell.makeScale(1, 1)
            })
        }
        didSelectItemAt?(model, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        guard
            indexPath.section < sections.count,
            sections[indexPath.section].hasScalingEffectOnSelect,
            let cell = collectionView.cellForItem(at: indexPath)
        else { return }
        
        cell.makeScale(cellDownScale, cellDownScale)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        guard
            indexPath.section < sections.count,
            sections[indexPath.section].hasScalingEffectOnSelect,
            let cell = collectionView.cellForItem(at: indexPath)
        else { return }
        
        cell.makeScale(1, 1)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCellAt?(cell, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayingCellAt?(cell, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard let model = getSupplementaryElementModelAt(indexPath, kind: kind) else {
            return UICollectionReusableView()
        }
        
        let supplementaryElement = supplementaryElement(indexPath: indexPath, model: model)
        
        supplementaryViewHandler?(supplementaryElement, model.kind)

        if let supplementaryElement = supplementaryElement as? DHSupplementaryElementInput {
            supplementaryElement.update(with: model.data)
        }
        
        return supplementaryElement
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            willDisplaySupplementaryViewAt?(view, .header, indexPath)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            willDisplaySupplementaryViewAt?(view, .footer, indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            didEndDisplayingSupplementaryViewAt?(view, .header, indexPath)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            didEndDisplayingSupplementaryViewAt?(view, .footer, indexPath)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}

