from services.emotion_model import get_raw_emotions


# ============================================================
# EMOSTAR EMOTION MAPPING
# ============================================================

EMOTION_MAP = {

    # Positive emotions
    "joy": "Joy",
    "excitement": "Joy",
    "amusement": "Joy",
    "love": "Joy",
    "gratitude": "Joy",
    "admiration": "Joy",
    "pride": "Joy",
    "approval": "Joy",

    # Calm
    "relief": "Calm",
    "caring": "Calm",

    # Sadness
    "sadness": "Sadness",
    "grief": "Sadness",
    "disappointment": "Sadness",
    "remorse": "Sadness",

    # Anxiety
    "nervousness": "Anxiety",
    "fear": "Anxiety",
    "embarrassment": "Anxiety",

    # Anger
    "anger": "Anger",
    "annoyance": "Anger",
    "disgust": "Anger",
    "disapproval": "Anger",

    # Confusion
    "confusion": "Confusion",
    "realization": "Confusion",
    "curiosity": "Confusion",

    # Motivation
    "desire": "Motivation",
    "optimism": "Motivation",

    # Stress
    "stress": "Stress",
}


# ============================================================
# ANALYZE JOURNAL
# ============================================================

def analyze_emotion(text: str):

    # Get the original GoEmotions scores.
    raw_scores = get_raw_emotions(text)


    # --------------------------------------------------------
    # Combine GoEmotions into EmoStar categories.
    # --------------------------------------------------------

    emotion_scores = {}

    for label, score in raw_scores.items():

        if label not in EMOTION_MAP:
            continue

        category = EMOTION_MAP[label]

        emotion_scores[category] = (
            emotion_scores.get(category, 0)
            + score
        )


    # --------------------------------------------------------
    # Remove extremely weak signals.
    #
    # A score below 5% is treated as background noise.
    # This prevents an angry journal from showing tiny
    # amounts of Joy, Confusion, etc.
    # --------------------------------------------------------

    emotion_scores = {
        emotion: score
        for emotion, score in emotion_scores.items()
        if score >= 0.05
    }


    # --------------------------------------------------------
    # No meaningful emotion detected.
    # --------------------------------------------------------

    if not emotion_scores:

        return {
            "primary_emotion": "Calm",
            "secondary_emotions": [],
            "distribution": {
                "Calm": 100.0
            }
        }


    # --------------------------------------------------------
    # Sort emotions from strongest to weakest.
    # --------------------------------------------------------

    sorted_emotions = sorted(
        emotion_scores.items(),
        key=lambda item: item[1],
        reverse=True
    )


    # --------------------------------------------------------
    # Primary emotion.
    # --------------------------------------------------------

    primary_emotion = sorted_emotions[0][0]


    # --------------------------------------------------------
    # Only keep emotions that are at least 10% of the
    # strongest emotion.
    #
    # This is different from the 5% absolute cutoff above.
    #
    # Example:
    #
    # Joy     = 0.90
    # Sadness = 0.03
    #
    # Sadness is technically present, but it is too weak
    # to be considered a meaningful secondary emotion.
    # --------------------------------------------------------

    strongest_score = sorted_emotions[0][1]

    meaningful_emotions = [
        (emotion, score)
        for emotion, score in sorted_emotions
        if score >= strongest_score * 0.10
    ]


    # --------------------------------------------------------
    # Keep at most five emotions for the pie chart.
    # --------------------------------------------------------

    meaningful_emotions = meaningful_emotions[:5]


    # --------------------------------------------------------
    # Calculate total score.
    # --------------------------------------------------------

    total = sum(
        score
        for _, score in meaningful_emotions
    )


    # --------------------------------------------------------
    # Convert scores into percentages.
    # --------------------------------------------------------

    distribution = {
        emotion: round(
            (score / total) * 100,
            1
        )
        for emotion, score in meaningful_emotions
    }


    # --------------------------------------------------------
    # Make sure percentages add up to exactly 100.
    # --------------------------------------------------------

    difference = round(
        100.0 - sum(distribution.values()),
        1
    )

    if difference != 0:

        largest = max(
            distribution,
            key=distribution.get
        )

        distribution[largest] += difference


    # --------------------------------------------------------
    # Secondary emotions.
    # --------------------------------------------------------

    secondary_emotions = [
        emotion
        for emotion, _ in meaningful_emotions
        if emotion != primary_emotion
    ]


    # --------------------------------------------------------
    # Final response.
    # --------------------------------------------------------

    return {
        "primary_emotion": primary_emotion,
        "secondary_emotions": secondary_emotions,
        "distribution": distribution,
    }