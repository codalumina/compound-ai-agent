#!/bin/bash

PROJECT_NAME="Compound Support Agent"

echo "🚀 Initializing GitHub Copilot Agile Taxonomy..."

# 1. Create standardized, color-coded labels (--force overwrites if they exist)
echo "Creating labels..."
gh label create "type: epic" --color "3E4B9E" --description "Large scale strategic initiative" --force
gh label create "type: story" --color "0E8A16" --description "User-facing value delivery" --force
gh label create "type: task" --color "FBCA04" --description "Technical implementation step" --force

gh label create "epic: infrastructure" --color "D4C5F9" --force
gh label create "epic: multi-agent" --color "C2E0C6" --force
gh label create "epic: deployment" --color "F9D0C4" --force
gh label create "epic: enterprise" --color "FEF2C0" --force

# 2. Function to create an issue, add to project, and optionally assign Copilot
create_ticket() {
  local title=$1
  local body=$2
  local labels=$3
  local assign_copilot=$4
  
  echo "Creating: $title"
  
  if [ "$assign_copilot" = true ]; then
    # Assigning @copilot triggers GitHub Copilot Workspace to start proposing code
    gh issue create --title "$title" --body "$body" --label "$labels" --project "$PROJECT_NAME" --assignee "@copilot"
  else
    gh issue create --title "$title" --body "$body" --label "$labels" --project "$PROJECT_NAME"
  fi
}

echo "📋 Populating backlog..."

# --- EPIC 1: CORE INFRASTRUCTURE ---
create_ticket "[Epic] Core Infrastructure" "Establish local LLM bridge and LangGraph foundation." "type: epic,epic: infrastructure" false
create_ticket "Establish local LLM bridge" "Configure langchain-ollama to connect to host.docker.internal:11434." "type: task,epic: infrastructure" false
create_ticket "Define global state schema" "Create Python TypedDict for LangGraph containing user_query, database_facts, draft, and validation_status." "type: task,epic: infrastructure" false

# --- EPIC 2: MULTI-AGENT IMPLEMENTATION ---
create_ticket "[Epic] Multi-Agent Implementation" "Build the Router, Drafter, and Validator nodes." "type: epic,epic: multi-agent" false
create_ticket "Build the Router Node" "Prompt engineering for llama3.2 to classify intents and output strictly in JSON." "type: task,epic: multi-agent" false
create_ticket "Build the Drafter Node" "Configure qwen2.5:14b to ingest state facts and output a cohesive response." "type: task,epic: multi-agent" false
create_ticket "Build the Validator Node" "Prompt engineering for llama3.2 to check the draft for hallucinated data." "type: task,epic: multi-agent" false
create_ticket "Configure the StateGraph Edge Logic" "Map the Nodes and write the Conditional Edge logic for the Validator retry loop." "type: task,epic: multi-agent" false

# --- EPIC 3: VPS DEPLOYMENT ---
create_ticket "[Epic] VPS Deployment" "Containerize the logic engine and Ollama for a low-resource Linux server." "type: epic,epic: deployment" false
create_ticket "Containerize the Logic Engine" "Write the Dockerfile for the uv-managed Python application." "type: task,epic: deployment" false
create_ticket "Containerize Ollama for CPU" "Write docker-compose.yml mapping llama.cpp to the VPS CPU architecture." "type: task,epic: deployment" false

echo "✅ Project board successfully populated!"
