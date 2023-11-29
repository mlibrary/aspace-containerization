# bentley_config.rb

# Application
AppConfig[:pui_indexer_enabled] = false
AppConfig[:enable_public] = false
AppConfig[:enable_docs] = false
AppConfig[:enable_oai] = false

# Plugin-specific configuration
AppConfig[:accession_events] = {
  agent_username: "admin",
  agent_role: "authorizer",
  accession_role: "source",
  outcome: "fail",
  event_types: ["custody_transfer"]
}

AppConfig[:browse_page_db_url] = ENV["BROWSE_PAGE_DB_URL"]

AppConfig[:user_defined_in_basic] = {
  "accessions" => ["text_1", "string_1", "enum_1", "enum_2", "enum_3", "enum_4", "boolean_1", "boolean_2"],
  "digital_objects" => [],
  "resources" => ["enum_1", "enum_2", "enum_3", "integer_1"],
  "hide_user_defined_section" => true
}
