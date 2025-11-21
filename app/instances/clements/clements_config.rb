# clements_config.rb

# Application
AppConfig[:enable_public] = false
AppConfig[:enable_oai] = false
AppConfig[:enable_docs] = false

AppConfig[:enable_custom_reports] = true

AppConfig[:accessibility_statement_url] = ENV["ACCESSIBILITY_STATEMENT_URL"]
