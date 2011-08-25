def sign_in user
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'weather'
  click_button "Sign in"
  user
end