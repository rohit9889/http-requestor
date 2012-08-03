Gem::Specification.new do |s|
  s.name = 'http-requestor'
  s.version = '0.0.1'
  s.date = Date.today
  
  s.summary = "A Wrapper around Net/HTTP which allows you to perform HTTP Requests."
  s.description = "A Wrapper around Net/HTTP which allows you to perform HTTP Requests."
  
  s.author = "Rohit Sharma"
  s.email = "rohit0981989@gmail.com"
  s.homepage = "http://github.com/rohit9889/http-requestor"
  
  s.require_paths = ['lib']
  
  s.files = Dir['{bin,lib}/**/*'] + %w(MIT-LICENSE README.rdoc)
  s.test_files = Dir['test/**/*']
end