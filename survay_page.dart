import 'package:flutter/material.dart';
import 'package:fruit_market/survay_service.dart';
import 'package:get/get.dart';

import 'models.dart';

class SurveyPage extends StatefulWidget {
  final Fruit fruit;
  const SurveyPage({super.key, required this.fruit});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int productStars = 0;
  int serviceStars = 0;
  final TextEditingController commentController = TextEditingController();

  final SurveyService surveyService = SurveyService();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Widget buildStars(int selected, Function(int) onTap) {
    return Row(
      children: List.generate(5, (i) {
        return IconButton(
          icon: Icon(
            i < selected ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 32,
          ),
          onPressed: () => onTap(i + 1),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate ${widget.fruit.name}"),
        backgroundColor: Colors.green,
      ),
      // ✅ Use SingleChildScrollView to avoid overflow
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(widget.fruit.imageUrl, height: 180),

            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Text("Product Rate")),
                Expanded(
                  child: buildStars(productStars, (v) {
                    setState(() => productStars = v);
                  }),
                ),
              ],
            ),

            Row(
              children: [
                const Expanded(child: Text("Service Rate")),
                Expanded(
                  child: buildStars(serviceStars, (v) {
                    setState(() => serviceStars = v);
                  }),
                ),
              ],
            ),

            const SizedBox(height: 20),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write a comment...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, // Button takes full width
              child: ElevatedButton(
                onPressed: () async {
                  if (productStars == 0 || serviceStars == 0) {
                    Get.snackbar(
                      "Error",
                      "Please rate both",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  try {
                    await surveyService.submitSurvey(
                      fruitId: widget.fruit.fruitId,
                      productRate: productStars,
                      serviceRate: serviceStars,
                      comment: commentController.text.trim(),
                    );

                    Get.snackbar(
                      "Success",
                      "Survey saved ❤️",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );

                    Future.delayed(const Duration(seconds: 1), Get.back);
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Failed to save survey",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
