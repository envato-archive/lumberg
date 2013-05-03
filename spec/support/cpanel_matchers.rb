RSpec::Matchers.define :return_a_list do |method|
  match do |subj|
    subj[:params][:data].is_a?(Array)
  end

  failure_message_for_should do |subj|
    "expected an Array at [:params][:data], got #{subj[:params][:data].class}"
  end

  failure_message_for_should_not do |subj|
    "expected a non-Array at [:params][:data], got #{subj[:params][:data].class}"
  end

  description do
    "return an Array at [:params][:data]"
  end
end
