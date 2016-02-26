Pod::Spec.new do |s|

  s.name            = "Ciconia"
  s.version         = "0.1.1"
  s.summary         = "Ciconia"
  s.description     = "On-demand migrations structure provider, based on NSOperation and NSOperationQueue"
  s.license         = "Apache v2"
  s.author          = { "Pietro Caselani" => "pietro.caselani@involves.com.br" }
  s.platform        = :ios
  s.source          = { :git => "https://github.com/CopyIsRight/Ciconia", :tag => "#{s.version}" }
  s.source_files    = "Classes/**/*.{h,m}"
  s.requires_arc    = true
  s.homepage        = "https://github.com/CopyIsRight/Ciconia"
  
  s.dependency 'SQLAid', '0.1.0'

end
