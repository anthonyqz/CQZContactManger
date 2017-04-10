Pod::Spec.new do |s|
	s.name 				= 'CQZContactManger'
  	s.version			= '0.5.0'
  	s.summary 			= 'CQZContactManger'
  	s.homepage 			= 'https://github.com/anthonyqz/CQZContactManger.git'
  	s.author 			= { "Christian Quicano" => "anthony.qz@ecorenetworks.com" }
  	s.source 			= {:git => 'https://github.com/anthonyqz/CQZContactManger.git', :tag => s.version}
  	s.ios.deployment_target 	= '9.0'
  	s.requires_arc 			= true
	s.frameworks             	= "Foundation"
	s.frameworks             	= "Contacts"
  	s.resources 			= 'project/CQZContactManger/*.{lproj,xcdatamodeld,png,gif,xcassets}', 'project/CQZContactManger/*.{xib}'
	s.source_files			= 'project/CQZContactManger/*.swift'
end