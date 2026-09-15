from transformers import pipeline


# Load the pretrained GoEmotions model.
emotion_classifier = pipeline(
    "text-classification",
    model="SamLowe/roberta-base-go_emotions",
    top_k=None
)


def get_raw_emotions(text: str):

    # Send the journal text to the model.
    results = emotion_classifier(text)[0]

    # Print EVERY emotion and its raw probability.
    print("\n========== RAW MODEL RESULTS ==========")

    for result in results:
        print(
            f"{result['label']}: "
            f"{result['score']:.4f}"
        )

    print("=======================================\n")


    # Return the raw scores.
    return {
        result["label"]: result["score"]
        for result in results
    }