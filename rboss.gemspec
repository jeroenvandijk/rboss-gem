# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rboss}
  s.version = "0.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joseph Wilk"]
  s.date = %q{2009-06-04}
  s.description = %q{Api wrapping Yahoo Boss search}
  s.email = ["joe@eshopworks.co.uk"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "TODO.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "TODO.txt", "config/hoe.rb", "config/requirements.rb", "features/steps/web_search_steps.rb", "features/web_search.feature", "gem_tasks/cucumber.rake", "gem_tasks/deployment.rake", "gem_tasks/environment.rake", "gem_tasks/fix_cr_lf.rake", "gem_tasks/gemspec.rake", "gem_tasks/rspec.rake", "gem_tasks/verify_rcov.rake", "gem_tasks/website.rake", "lib/boss.rb", "lib/boss/api.rb", "lib/boss/config.rb", "lib/boss/result.rb", "lib/boss/result/base.rb", "lib/boss/result/image.rb", "lib/boss/result/news.rb", "lib/boss/result/spell.rb", "lib/boss/result/web.rb", "lib/boss/result_collection.rb", "lib/boss/result_factory.rb", "lib/boss/version.rb", "rboss.gemspec", "spec/boss/api_spec.rb", "spec/boss/config_spec.rb", "spec/boss/result_collection_spec.rb", "spec/boss/result_factory_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/eshopworks/rboss-gem}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rboss}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Api wrapping Yahoo Boss search}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 1.1.3"])
      s.add_runtime_dependency(%q<rspec>, [">= 1.1.4"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 1.1.2"])
      s.add_development_dependency(%q<hoe>, [">= 1.12.2"])
    else
      s.add_dependency(%q<json_pure>, [">= 1.1.3"])
      s.add_dependency(%q<rspec>, [">= 1.1.4"])
      s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
      s.add_dependency(%q<hoe>, [">= 1.12.2"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 1.1.3"])
    s.add_dependency(%q<rspec>, [">= 1.1.4"])
    s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
    s.add_dependency(%q<hoe>, [">= 1.12.2"])
  end
end
