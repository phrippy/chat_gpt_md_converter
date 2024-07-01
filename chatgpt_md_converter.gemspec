require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name = 'chat_gpt_md_converter'
  spec.version = ChatGptMdConverter::VERSION
  spec.authors = ['Serhii Hordiienko']
  spec.email = ['phrippy2@gmail.com']

  spec.summary = 'Telegram Markdown Formatter'
  spec.description = 'Telegram Markdown Formatter'
  spec.homepage = 'https://github.com/phrippy/chat_gpt_md_converter'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.3'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/phrippy/chat_gpt_md_converter'
  spec.metadata['changelog_uri'] = 'https://github.com/phrippy/chat_gpt_md_converter'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
