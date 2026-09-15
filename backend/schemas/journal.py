from pydantic import BaseModel
from datetime import datetime

# Import the schema that describes our emotion analysis
from schemas.analysis import EmotionAnalysis


# Data we expect when someone creates a journal entry
class JournalRequest(BaseModel):
    text: str


# Data we send back after creating a journal entry
class JournalResponse(BaseModel):
    # MongoDB document ID
    id: str

    # Original journal text
    text: str

    # When the journal was created
    createdAt: datetime

    # Current state of emotion analysis
    analysisStatus: str

    # Emotion analysis produced by our model
    analysis: EmotionAnalysis