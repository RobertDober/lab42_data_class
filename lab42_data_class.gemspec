require_relative "lib/lab42/data_class/version"
version = Lab42::DataClass::VERSION

description = <<~DESCRIPTION
  An Immutable DataClass for Ruby

  Exposes a class factory function `Kernel::DataClass` and a class
  modifer `Module#dataclass', also creates two _tuple_ classes, `Pair` and
  `Triple`
DESCRIPTION

Gem::Specification.new do |s|
  s.name        = 'lab42_data_class'
  s.version     = version
  s.summary     = 'Finally a dataclass in ruby'
  s.description = description
  s.authors     = ["Robert Dober"]
  s.email       = 'robert.dober@gmail.com'
  s.files       = Dir.glob("lib/**/*.rb")
  s.files      += %w[LICENSE README.md]
  s.homepage    = "https://github.com/robertdober/lab42_data_class"
  s.licenses    = %w[Apache-2.0]

  s.required_ruby_version = '>= 3.1.0'
end
