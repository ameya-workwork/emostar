from fastapi import APIRouter
from datetime import datetime

# Schema for the incoming journal request
from schemas.journal import JournalRequest, JournalResponse

# Our emotion-analysis function
from services.emotion_service import analyze_emotion

# MongoDB collection where journals are stored
from database import journals_collection


# Create a router for journal-related endpoints
router = APIRouter()


# Endpoint for creating a new journal entry
@router.post("/journal", response_model=JournalResponse)
def create_journal(journal: JournalRequest):

    # Analyze the text using our pre-trained emotion model
    analysis = analyze_emotion(journal.text)

    # Create the journal document that will be stored in MongoDB
    entry = {
        "text": journal.text,

        # Save the date and time when the journal was created
        "createdAt": datetime.now(),

        # The emotion analysis has been completed successfully
        "analysisStatus": "complete",

        # Store the emotion analysis with the journal
        "analysis": analysis,
    }

    # Insert the journal document into MongoDB
    result = journals_collection.insert_one(entry)

    # Send a response back to whoever called the API
    # Send the saved journal and its emotion analysis back to the app
    return {
        "id": str(result.inserted_id),
        "text": journal.text,
        "createdAt": entry["createdAt"],
        "analysisStatus": "complete",

        # Send the emotion results so Flutter can display them
        "analysis": analysis,
    }