require_relative 'lib/glmath'

Gem::Specification.new do |s|
  s.name          = 'glmath'
  s.version       = GLMath::VERSION
  s.summary       = 'Ruby Math Helper for OpenGL'
  s.description   = 'Ruby Math Helper for OpenGL'
  s.license       = 'MIT'
  s.authors       = %w'SilverPhoenix99 P3t3rU5'
  s.email         = %w'silver.phoenix99@gmail.com pedro.megastore@gmail.com'
  s.homepage      = 'https://github.com/SilverPhoenix99/glmath'
  s.require_paths = %w'lib'
  s.files         = Dir['{lib/**/*.rb,*.md}']
  s.add_development_dependency 'rspec', '~> 3'
end
