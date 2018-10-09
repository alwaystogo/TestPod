Pod::Spec.new do |s|

  s.name         = "Files"
  s.version      = "0.0.1"
  s.summary      = "First Test Pod."
  s.description  = <<-DESC 
  This is is descrpition.
                   DESC
  s.homepage     = "http://blog.csdn.net/codingfire"
  s.license      = "MIT"
  s.author             = { "yunfei.yang" => "623099552@qq.com" }
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/alwaystogo/TestPod.git", :tag => "0.0.1" }
  s.requires_arc = true
  s.source_files = "Files/*"
end
