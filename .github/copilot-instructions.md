# Project Context: Compound Support Agent

You are an expert AI engineering assistant helping a Solution Architect build a local-only, multi-agent customer support system. This project strictly relies on "Compound AI" patterns (routing, drafting, and validation loops) to achieve high reliability using small, fast local models.

## 1. Architectural Constraints (CRITICAL)

- **NO CLOUD LLMs:** Do not ever suggest, import, or write code for OpenAI, Anthropic, or any cloud-based API. There are no API keys in this project.
- **Inference Engine:** Strictly use `langchain-ollama` connecting to local instances (e.g., `http://localhost:11434` or `host.docker.internal:11434`).
- **Resource Limits:** The system is developed on macOS (Apple Silicon) and will deploy to a low-resource Linux CPU VPS. Code must remain highly efficient and memory-conscious.

## 2. Multi-Agent Model Strategy

When suggesting LLM integration, adhere to this specific division of labor:

- **Router & Validator (`llama3.2:latest`):** Use this 3B model exclusively for fast, single-purpose classification, JSON extraction, and YES/NO hallucination checks. Provide it with rigid, zero-shot system prompts.
- **Drafter (`qwen2.5:14b`):** Use this 14B model for synthesizing database facts and writing the actual customer-facing responses.

## 3. Orchestration: LangGraph Rules

- **State Management:** Always use Python `TypedDict` to define the global State schema.
- **Nodes:** Write Nodes as pure, modular Python functions that accept the State and return an updated dictionary. Keep business logic separate from LLM invocation.
- **Edges:** Leverage Conditional Edges for reflection loops (e.g., routing back to the Drafter if the Validator detects a hallucination). Do not use manual `while` loops for agentic cycles.

## 4. Tech Stack & Tooling

- **Package Manager:** `uv`. Do not suggest `pip`, `poetry`, or `conda`.
- **Typing:** Strict Python type hints are mandatory. Code must pass `mypy`.
- **Formatting/Linting:** Assume `ruff` is the standard.
- **Testing:** Write unit tests using `pytest`. Mock the LLM endpoints when testing the LangGraph logic layer to ensure fast test execution.
- **Separation of Concerns:** Keep the Logic layer (LangGraph), Inference layer (Ollama), and Data layer (Mock DB/MySQL) completely decoupled.

## 5. Workflow Context

The developer operates via a strict Epic/Story/Task Git workflow. When implementing a feature, focus only on the scope of the current specific Task (e.g., just the Router Node) rather than rewriting the entire StateGraph.
