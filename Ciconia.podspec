#
# Be sure to run `pod lib lint Ciconia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Ciconia"
  s.version          = "0.2.3"
  s.summary          = "Migrations structure provider."
  s.description      = "On-demand migrations structure provider, based on NSOperation and NSOperationQueue"
  s.homepage         = "https://github.com/CopyIsRight/Ciconia"
  s.license          = 'MIT'
  s.author           = { "Pietro Caselani" => "pc1992@gmail.com", "Felipe Lobo" => "frlwolf@gmail.com" }
  s.source           = { :git => "https://github.com/CopyIsRight/Ciconia.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  
  s.dependency 'SQLAid', '~> 0.2'
end
