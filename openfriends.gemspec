# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{openfriends}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Citrusbyte"]
  s.autorequire = %q{openfriends}
  s.date = %q{2009-02-11}
  s.description = %q{Ruby bindings for OpenFriends specification}
  s.email = %q{openfriends-help@citrusbyte.com}
  s.extra_rdoc_files = ["LICENSE", "TODO"]
  s.files = ["lib/openfriends/consumer.rb", "lib/openfriends/peer.rb", "lib/openfriends/provider.rb", "lib/openfriends/response.rb", "lib/openfriends.rb", "spec/openfriends_spec.rb", "spec/spec_helper.rb", "README.markdown", "LICENSE", "TODO", "Rakefile"]
  s.has_rdoc = true
  s.homepage = %q{http://openfriendsproject.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby bindings for OpenFriends specification}
  s.add_dependency("json")

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
