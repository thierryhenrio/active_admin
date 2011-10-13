# More info at https://github.com/guard/guard#readme

guard 'spork', cucumber: false do
  watch('spec/spec_helper.rb')
  watch(%r{^spec/support/.+\.rb$})
end

guard 'rspec', version: 2, cli: "--drb", all_on_start: false, all_after_pass: false  do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/active_admin/(.+)\.rb$})     { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch(%r(^lib/generators/active_admin/(.+)\.rb$))     { |m| "spec/unit/generators/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
end

