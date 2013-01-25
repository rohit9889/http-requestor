Gem::Specification.new do |s|
  s.name = 'http-requestor'
  s.version = '1.0.4'
  s.date = Date.today
  
  s.summary = "A Wrapper around Net/HTTP which allows you to perform HTTP Requests."
  s.description = <<-EOF
    A Wrapper around Net/HTTP which allows you to perform HTTP Requests.
    Gives you a simple API interface to send multipart requests.\n
    You can also send HTTP calls using the verbs OPTIONS, PATCH, MOVE, HEAD, TRACE
  EOF
  
  s.author = "Rohit Sharma"
  s.email = "rohit0981989@gmail.com"
  s.homepage = "http://github.com/rohit9889/http-requestor"
  s.license = 'MIT'
  s.add_dependency('mime-types', '>= 1.17.2')
  
  s.require_paths = ['lib']
  
  s.files = Dir['{bin,lib}/**/*'] + %w(MIT-LICENSE README.rdoc)
  s.test_files = Dir['test/**/*']
end