module RSpec::Rails
  module Matchers
    RSpec::Matchers.define :include_text do |text|
      match do |response_or_text|
        @content = response_or_text.respond_to?(:body) ? response_or_text.body : response_or_text
        @content.include?(text)
      end

      failure_message_for_should do
        "expected '#{@content}' to include '#{text}'"
      end

      failure_message_for_should_not do
        "expected #{@content} to not include '#{text}'"
      end
    end
  end
end