#!/usr/bin/env bash
# mzsh configuration utilities
# Stores user configuration in ~/.mzsh.json

CONFIG_FILE="$HOME/.mzsh.json"

# Initialize config file if it doesn't exist
config_init() {
  if [[ ! -f "$CONFIG_FILE" ]]; then
    echo '{}' > "$CONFIG_FILE"
  fi
}

# Get a config value
# Usage: config_get <key> [default]
config_get() {
  local key="$1"
  local default="${2:-}"
  
  config_init
  
  if command -v jq >/dev/null 2>&1; then
    jq -r ".\"$key\" // \"$default\"" "$CONFIG_FILE" 2>/dev/null || echo "$default"
  else
    # Fallback if jq not available (shouldn't happen in mzsh context)
    echo "$default"
  fi
}

# Set a config value
# Usage: config_set <key> <value>
config_set() {
  local key="$1"
  local value="$2"
  
  config_init
  
  if command -v jq >/dev/null 2>&1; then
    local tmp_file
    tmp_file=$(mktemp)
    jq ".\"$key\" = \"$value\"" "$CONFIG_FILE" > "$tmp_file"
    mv "$tmp_file" "$CONFIG_FILE"
  else
    echo "Error: jq is required to manage config" >&2
    return 1
  fi
}

# Delete a config value
# Usage: config_delete <key>
config_delete() {
  local key="$1"
  
  config_init
  
  if command -v jq >/dev/null 2>&1; then
    local tmp_file
    tmp_file=$(mktemp)
    jq "del(.\"$key\")" "$CONFIG_FILE" > "$tmp_file"
    mv "$tmp_file" "$CONFIG_FILE"
  else
    echo "Error: jq is required to manage config" >&2
    return 1
  fi
}

# List all config
config_list() {
  config_init
  
  if command -v jq >/dev/null 2>&1; then
    jq '.' "$CONFIG_FILE" 2>/dev/null || echo '{}'
  else
    echo "Error: jq is required to manage config" >&2
    return 1
  fi
}
