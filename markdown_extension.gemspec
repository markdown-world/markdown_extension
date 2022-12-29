require_relative 'lib/markdown_extension/version'

Gem::Specification.new do |s|
  s.name = 'markdown_extension'
  s.version = MarkdownExtension::Version
  s.author = ['Zhuang Biaowei']
  s.email = ['zbw@kaiyuanshe.org']
  s.homepage = 'https://github.com/markdown-world/markdown_extension'
  s.license = 'Apache-2.0'
  s.summary = 'A markdown extension for generating HTML in order to support a wider variety of formats.'
  s.files = Dir.glob('{lib,test}/**/*')
  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.5.0'
  s.add_runtime_dependency 'tomlrb', '~>2.0.0'
  s.add_runtime_dependency 'kramdown', '~>2.0'
  s.add_runtime_dependency 'kramdown-parser-gfm', '~>1.0'
end
