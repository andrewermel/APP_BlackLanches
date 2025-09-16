# Configuration for FactoryBot
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Lint factories to ensure they're valid
  config.before(:suite) do
    FactoryBot.lint unless ENV['SKIP_FACTORY_LINT']
  end
end
