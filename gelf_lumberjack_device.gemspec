Gem::Specification.new do |s|
  s.name = 'gelf_lumberjack_device'
  s.version = File.read(File.expand_path("../VERSION", __FILE__)).strip
  s.summary = "A logging device for the lumberjack gem that writes log entries to Graylog."
  s.description = "A logging device for the lumberjack gem that writes log entries to Graylog via GELF protocol."

  s.authors = ['Hank Beaver', 'Obie Fernandez']
  s.email = ['hbeaver@gmail.com','obiefernandez@gmail.com']
  s.homepage = "http://github.com/blasterpal/gelf_lumberjack_device"

  s.files = ['README.rdoc', 'VERSION', 'Rakefile', 'MIT_LICENSE'] +  Dir.glob('lib/**/*'), Dir.glob('spec/**/*')
  s.require_path = 'lib'
  
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8", "--main", "README.rdoc"]
  s.extra_rdoc_files = ["README.rdoc"]
  
  s.add_dependency "lumberjack", "~>1.0"
  s.add_dependency "gelf", "~>1.3"
end
