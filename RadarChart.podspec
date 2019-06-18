Pod::Spec.new do |s|
  s.name         = "RadarChart"
  s.version      = "1.0.0"
  s.summary      = "Radar Chart viewer."
  s.description  = "Sample radar charts. Easy to use."
  s.homepage     = "https://github.com/shossain2806/RadarChart"
  s.license      = "MIT"
  s.author       = "Saber Hossain"
  s.platform     = :ios, "12.2"
  s.source       = { :git => "https://github.com/shossain2806/RadarChart.git", :tag => "1.0.0" }
  s.source_files = "RadarChart"
  s.swift_version = "5" 
  s.framework      = 'UIKit'
end