require 'database_cleaner'
RSpec.configure do |config|
  config.before(:suite) do
    # This says that before the entire test suite runs, clear the test database out completely.
    # This gets rid of any garbage left over from interrupted or poorly-written tests - a common source of surprising test behavior.
    DatabaseCleaner.clean_with(:truncation)

    # This part sets the default database cleaning strategy to be transactions.
    # Transactions are very fast, and for all the tests where they do work - that is, any test where the entire test runs in the RSpec process - they are preferable.
    DatabaseCleaner.strategy = :transaction
  end

  # These lines hook up database_cleaner around the beginning and end of each test,
  # telling it to execute whatever cleanup strategy we selected beforehand.
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
