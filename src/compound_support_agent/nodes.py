from langchain_core.prompts import ChatPromptTemplate

from src.compound_support_agent.llm import get_router_validator_model
from src.compound_support_agent.state import AgentState


def router_node(state: AgentState) -> dict:
    """
    Analyzes the user query and classifies the intent.
    Returns a dictionary updating the 'intent' field in the global state.
    """
    query = state["user_query"]

    # Strict zero-shot prompt to force Llama 3.2 into categorization
    prompt = ChatPromptTemplate.from_messages(
        [
            (
                "system",
                """You are an expert customer support routing agent. 
        Classify the user's query into EXACTLY ONE of the following intents:
        - refund_status
        - technical_support
        - billing_issue
        - general_inquiry
        
        Output ONLY the exact string of the intent. Do not add punctuation, reasoning, or extra words.""",
            ),
            ("human", "{query}"),
        ]
    )

    llm = get_router_validator_model()
    chain = prompt | llm

    response = chain.invoke({"query": query})
    intent = response.content.strip().lower()

    # Fallback circuit breaker in case the 3B model hallucinates the category format
    valid_intents = [
        "refund_status",
        "technical_support",
        "billing_issue",
        "general_inquiry",
    ]
    if intent not in valid_intents:
        intent = "general_inquiry"

    return {"intent": intent}
