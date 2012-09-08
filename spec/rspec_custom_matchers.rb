RSpec::Matchers.define :be_logged_in do
  match do |user|
    cookies['auth_token'] == user.auth_token
  end
end