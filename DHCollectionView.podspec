Pod::Spec.new do |spec|

  spec.name         = "DHCollectionView"
  spec.version      = "1.0.0"
  spec.summary      = "UICollectionView with simple usage for cell's dynamic size"
  spec.description  = "This framework makes UICollectionView easy to use."

  spec.homepage     = "https://github.com/RIMaker/DHCollectionView"
  spec.license      = "MIT"
  spec.author       = { "Zhora Agadzhanyan" => "zhoraagadzhanyan@gmail.com" }
  spec.platform     = :ios, "13.1"
  spec.source       = { :git => "https://github.com/RIMaker/DHCollectionView.git", :tag => spec.version.to_s }
  spec.source_files  = "DHCollectionView/**/*"
  spec.swift_versions = "5.0"
end
