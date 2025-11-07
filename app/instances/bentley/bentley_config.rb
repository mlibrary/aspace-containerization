# bentley_config.rb

# Application
AppConfig[:pui_indexer_enabled] = false
AppConfig[:enable_public] = false
AppConfig[:enable_docs] = false
AppConfig[:enable_oai] = false
AppConfig[:enable_custom_reports] = true
AppConfig[:default_page_size] = 25
AppConfig[:allow_other_admins_access_to_system_info] = true

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

AppConfig[:reindex_on_startup] = false

AppConfig[:refid_rule] = "<%= SecureRandom.hex %>"
AppConfig[:refid_rule_only_on_create] = false
