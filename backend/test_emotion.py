from services.emotion_service import analyze_emotion


text = "I am so happy today! Everything went perfectly and I feel amazing."


result = analyze_emotion(text)


print("\nEmoStar analysis:\n")

print("Primary emotion:", result["primary_emotion"])

print("Secondary emotions:", result["secondary_emotions"])

print("Distribution:", result["distribution"])