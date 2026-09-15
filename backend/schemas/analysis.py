from pydantic import BaseModel


class EmotionAnalysis(BaseModel):
    primary_emotion: str
    secondary_emotions: list[str]
    distribution: dict[str, float]