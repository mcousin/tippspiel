RSpec::Matchers.define :be_logged_in do
  match do |user|
    controller.current_user
    puts cookies.inspect
    cookies['auth_token'] == user.auth_token
  end
end