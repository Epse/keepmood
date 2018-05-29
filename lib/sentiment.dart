enum Sentiment { veryUnhappy, unhappy, neutral, happy, veryHappy }

class SentimentRecording {
  // id is not final because it can be set after insertion into database
  int id;
  final DateTime time;
  final Sentiment sentiment;
  final String comment;

  SentimentRecording(this.sentiment, this.time, [this.id, this.comment = ""]);

  SentimentRecording.fromMap(Map map)
      : id = map["id"],
        time = DateTime.parse(map["timestamp"]),
        sentiment = parseSentiment(map["sentiment"]),
        comment = map["comment"];

  Map toMap() {
    // Damn those type annotations.. You need them or it fails
    Map<String, dynamic> map = {
      "timestamp": time.toIso8601String(),
      "sentiment": sentimentString(sentiment)
    };
    if (id != null) {
      map["id"] = id;
    }
    if (comment != null) {
      map["comment"] = comment;
    }
    return map;
  }
}

String sentimentString(Sentiment sentiment) {
  switch (sentiment) {
    case Sentiment.happy:
      return "Happy";
      break;
    case Sentiment.veryHappy:
      return "Very Happy";
      break;
    case Sentiment.unhappy:
      return "Unhappy";
      break;
    case Sentiment.veryUnhappy:
      return "Very Unhappy";
      break;
    default:
      return "Meh!";
      break;
  }
}

Sentiment parseSentiment(String string) {
  switch (string) {
    case "Very Unhappy":
      return Sentiment.veryUnhappy;
      break;
    case "Unhappy":
      return Sentiment.unhappy;
      break;
    case "Happy":
      return Sentiment.happy;
      break;
    case "Very Happy":
      return Sentiment.veryHappy;
      break;
    default:
      return Sentiment.neutral;
  }
}
