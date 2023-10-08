//
//  DHCollectionView.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

public class DHCollectionView: UIView  {
    
    var didSelectItemAt: ((_ model: DHCellModel?, _ indexPath: IndexPath) -> ())?
    var willDisplayCellAt: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ())?
    var willDisplaySupplementaryViewAt: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind, _ indexPath: IndexPath) -> ())?
    var didEndDisplayingSupplementaryViewAt: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind, _ indexPath: IndexPath) -> ())?
    var didScroll: ((_ scrollView: UIScrollView) -> ())?
    var supplementaryViewHandler: ((_ view: UICollectionReusableView, _ kind: DHSupplementaryElementKind) -> ())?
    var cellHandler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ())?
    var onTopRefresh: (() -> ())? {
        didSet {
            addRefreshControl()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collView = setupCollectionView()
        return collView
    }()
    
    lazy var refreshControl = UIRefreshControl()
    
    lazy var placeholderView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var placeholderImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.tintColor = .blue
        return view
    }()
    
    lazy var placeholderLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.sizeToFit()
        return lbl
    }()
    
    private var sections: [DHSectionWrapper] = []
    private var sectionsData: [DHSectionWrapper: DHSectionData] = [:]
    private var cellRegisterIds: Set<String> = []
    private var supplementaryElementRegisterIds: Set<String> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpContent()
    }
    
    func display(withSectionsData sectionsData: [DHSectionWrapper: DHSectionData]) {
        self.sectionsData = sectionsData
        self.sections = sectionsData.keys.sorted(by: { $0.section.id < $1.section.id })
        self.collectionView.reloadData()
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.bounds.height + collectionView.contentInset.bottom)
        collectionView.setContentOffset(bottomOffset, animated: true)
    }
    
    func showPlaceholder(withImage image: UIImage?, withMessage message: String) {
        placeholderLabel.text = message
        placeholderImageView.image = image
        placeholderView.isHidden = false
    }
    
    func hidePlaceholder() {
        placeholderView.isHidden = true
    }
    
    private func addRefreshControl() {
        if collectionView.refreshControl == nil {
            collectionView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(onTopRefresh(_:)), for: .valueChanged)
        }
    }
    
    private func setUpContent() {
        addSubview(collectionView)
        collectionView.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImageView)
        placeholderView.addSubview(placeholderLabel)
        backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            placeholderView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            placeholderView.widthAnchor.constraint(equalTo: self.widthAnchor),
            placeholderView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 100),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 100),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor, constant: 20),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: placeholderView.bottomAnchor, constant: -10),
            placeholderLabel.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor, constant: -20)
        ])
        
    }
    
    private func setupCollectionView() -> UICollectionView {
        let layout = setupCollectionViewLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.backgroundColor = .white
        colView.translatesAutoresizingMaskIntoConstraints = false
        colView.showsVerticalScrollIndicator = false
        colView.showsHorizontalScrollIndicator = false
        colView.delegate = self
        colView.dataSource = self
        return colView
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewLayout {
       
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard sectionIndex < self.sections.count else { return nil }
            
            let mySection = self.sections[sectionIndex]
            let scrollDirection = mySection.scrollDirection
            
            let item = self.setupItem(forSection: mySection)
            
            let group = self.setupGroup(forSection: mySection, withItem: item)
            
            let supplementaryItems = self.setupSupplementaryItems(forSection: mySection, withItem: item)
            
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
    
    private func setupItem(forSection section: DHSectionWrapper) -> NSCollectionLayoutItem {
        
        let scrollDirection = section.scrollDirection
        let widthDimension: NSCollectionLayoutDimension
        let heightDimension: NSCollectionLayoutDimension = .estimated(40)
        
        switch scrollDirection {
        case .vertical(let align):
            switch align {
            case .center:
                widthDimension = .fractionalWidth(1.0)
            case .left:
                widthDimension = .estimated(40)
            }
        case .horizontal(let enableDynamicWidth, _):
            widthDimension = enableDynamicWidth ? .estimated(40): .fractionalWidth(1.0)
        }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: widthDimension,
            heightDimension: heightDimension
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    private func setupGroup(forSection section: DHSectionWrapper, withItem item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let scrollDirection = section.scrollDirection
        let widthDimension: NSCollectionLayoutDimension
        let heightDimension: NSCollectionLayoutDimension = .estimated(40)
        
        switch scrollDirection {
        case .vertical(_):
            widthDimension = .fractionalWidth(1.0)
        case .horizontal(let enableDynamicWidth, _):
            widthDimension = enableDynamicWidth ? .estimated(40): .fractionalWidth(1.0)
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
    
    private func setupSupplementaryItems(forSection section: DHSectionWrapper, withItem item: NSCollectionLayoutItem) -> [NSCollectionLayoutBoundarySupplementaryItem] {
        
        let footerHeaderSize = item.layoutSize
        
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
    
    private func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func supplementaryElement(indexPath: IndexPath, model: DHSupplementaryElementModelContract) -> UICollectionReusableView {
        
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
    
    private func cell(indexPath: IndexPath, model: DHCellModel) -> UICollectionViewCell {
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
    
    private func getCellModelAt(_ indexPath: IndexPath) -> DHCellModel? {
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
    
    private func getSupplementaryElementModelAt(_ indexPath: IndexPath, kind: String) -> DHSupplementaryElementModelContract? {
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
    
    @objc
    private func onTopRefresh(_ sender: UIRefreshControl) {
        endRefreshing()
        onTopRefresh?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            cell.makeScale(0.95, 0.95, completion: {
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
        
        cell.makeScale(0.95, 0.95)
        
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
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard let model = getSupplementaryElementModelAt(indexPath, kind: kind) else {
            return UICollectionReusableView()
        }
        
        let supplementaryElement = supplementaryElement(indexPath: indexPath, model: model)

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

