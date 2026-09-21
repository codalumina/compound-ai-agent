from langchain_ollama import ChatOllama


def get_router_validator_model() -> ChatOllama:
    """
    Returns the Llama 3.2 3B model.
    Temperature is explicitly set to 0.0 for deterministic classification and validation.
    """
    return ChatOllama(
        model="llama3.2:latest",
        temperature=0.0,
        base_url="http://localhost:11434",  # Defaults to localhost, but explicit is better
    )


def get_drafter_model() -> ChatOllama:
    """
    Returns the Qwen 2.5 14B model.
    Temperature is set slightly higher for natural language generation and drafting.
    """
    return ChatOllama(
        model="qwen2.5:14b", temperature=0.3, base_url="http://localhost:11434"
    )
