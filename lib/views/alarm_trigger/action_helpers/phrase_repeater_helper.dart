import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';

class PhraseRepeater {
  final SpeechToText speechToText;
  final Function(String) onPhraseDetected;
  final Function onListeningFailed;
  final double similarityPercentage;

  PhraseRepeater(
      {required this.speechToText,
      required this.onPhraseDetected,
      required this.onListeningFailed,
      required this.similarityPercentage});

  void startListening(String targetPhrase) async {
    speechToText.listen(
      onResult: (result) {
        _onSpeechResult(result, targetPhrase);
      },
      listenOptions: SpeechListenOptions(
        enableHapticFeedback: true,
        listenMode: ListenMode.deviceDefault,
        partialResults: false,
      ),
    );
  }

  void _onSpeechResult(result, String targetPhrase) async {
    try {
      String wordsSpoken = result.recognizedWords;
      if (wordsSpoken.toLowerCase().similarityTo(targetPhrase.toLowerCase()) >
          similarityPercentage) {
        stopListening();
        onPhraseDetected(wordsSpoken);
      } else {
        stopListening();
        onListeningFailed();
      }
    } catch (e) {
      stopListening();
      onListeningFailed();
    }
  }

  void stopListening() async {
    await speechToText.stop();
  }
}
