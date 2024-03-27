Pod::Spec.new do |spec|

  spec.name         = "DHCollectionView"
  spec.version      = "1.1.4"
  spec.summary      = "UICollectionView with simple usage for cell's dynamic size"
  spec.description  = "This framework makes UICollectionView easy to use. It allows to make vertical/horizontal UICollectionView sections with cell's dynamic size simply."

  spec.homepage     = "https://github.com/RIMaker/DHCollectionView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Zhora Agadzhanyan" => "zhoraagadzhanyan@gmail.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/RIMaker/DHCollectionView.git", :tag => spec.version }
  spec.source_files  = "DHCollectionView/**/*.{swift}"
  spec.swift_versions = "5.0"
end
