import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false;
  String _targetPhrase = "Hello"; // Modify this with your desired phrase
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  double _accuracy = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords ?? "";
      _confidenceLevel = result.confidence;

      // Check accuracy
      if (_wordsSpoken.toLowerCase() == _targetPhrase.toLowerCase()) {
        // If recognized words match the target phrase
        _accuracy = 100;
      } else {
        // If recognized words do not match the target phrase
        _accuracy = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : speechEnabled
                    ? "Tap the microphone and start listening"
                    : "Speech not available",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(.0),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Text(
              "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Accuracy: ${_accuracy.toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : startListening,
        tooltip: "Listen",
        child: Icon(
          _speechToText.isListening ? Icons.mic : Icons.mic_off,
          color: Colors.white,
        ),
      ),
    );
  }
}




// import 'package:backup/speech/speech_with_confidence/pages/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final SpeechController controller =Get.put(SpeechController());
//
//     return Scaffold(
//     appBar: AppBar(),
//     body: Center(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Obx(() => Text(
//               controller.speechToText.isListening
//                   ? "Listening..."
//                   : controller.speechEnabled.value
//                   ? "Tap the microphone and start listening"
//                   : "Speech not available",
//               style: const TextStyle(fontSize: 20),
//             )),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(.0),
//               child: Obx(() => Text(
//                 controller.wordsSpoken.value,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 25),
//               )),
//             ),
//           ),
//           Obx(() {
//             if (!controller.speechToText.isListening &&
//                 controller.confidenceLevel.value > 0) {
//               return Text(
//                 "Confidence: ${controller.confidenceLevel.value.toStringAsFixed(1)}%",
//                 style: const TextStyle(
//                     fontSize: 30, fontWeight: FontWeight.w200),
//               );
//             } else {
//               return SizedBox();
//             }
//           }),
//           Obx(() {
//             return Text(
//               "Accuracy: ${controller.calculateAccuracy().toStringAsFixed(1)}%",
//               style: const TextStyle(
//                   fontSize: 30, fontWeight: FontWeight.w200),
//             );
//           }),
//         ],
//       ),
//     ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (controller.speechToText.isListening) {
//             controller.stopListening();
//           } else {
//             controller.startListening();
//           }
//         },
//         tooltip: "Listen",
//         child: Icon(
//           controller.speechToText.isListening ? Icons.mic : Icons.mic_off,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
