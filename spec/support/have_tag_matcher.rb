# Ensure this is defined for Ruby 1.8
module MiniTest; class Assertion < Exception; end; end

RSpec::Matchers.define :have_tag do |*args|

  match_unless_raises Test::Unit::AssertionFailedError do |response|
    tag = args.shift
    content = args.first.is_a?(Hash) ? nil : args.shift

    options = {
      :tag => tag.to_s
    }.merge(args[0] || {})

    options[:content] = content if content

    begin
      begin
        assert_tag(options)
      rescue NoMethodError
        # We are not in a controller, so let's do the checking ourselves
        doc = HTML::Document.new(response, false, false)
        tag = doc.find(options)
        assert tag, "expected tag, but no tag found matching #{options.inspect} in:\n#{response.inspect}"
      end
    # In Ruby 1.9, MiniTest::Assertion get's raised, so we'll
    # handle raising a Test::Unit::AssertionFailedError
    rescue MiniTest::Assertion => e
      raise Test::Unit::AssertionFailedError, e.message
    end
  end
end