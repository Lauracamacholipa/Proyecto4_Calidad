Before do
  @args = []
end

After do
  Capybara.current_session.driver.quit
end