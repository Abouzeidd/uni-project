import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models.dart';
import 'rate_model.dart';
import 'rate_service.dart';

class SurveyPage extends StatefulWidget {
  final Fruit fruit;
  final String userEmail;

  const SurveyPage({super.key, required this.fruit, required this.userEmail});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int productStars = 0;
  int serviceStars = 0;

  final TextEditingController commentController = TextEditingController();
  final RateService rateService = RateService();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Widget buildStars(int selectedStars, Function(int) onStarTap) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < selectedStars ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 32,
          ),
          onPressed: () => onStarTap(index + 1),
        );
      }),
    );
  }

  Future<void> submitRate() async {
    if (productStars == 0 || serviceStars == 0) {
      Get.snackbar(
        "Warning",
        "Please rate both product and service",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final rate = Rate(
      fruitId: widget.fruit.fruitId.toString(),
      userEmail: widget.userEmail,
      productRate: productStars,
      serviceRate: serviceStars,
      comment: commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await rateService.insertRate(rate);

      Get.snackbar(
        "Thank you!",
        "Your rating has been saved successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      setState(() {
        productStars = 0;
        serviceStars = 0;
        commentController.clear();
      });

      Future.delayed(const Duration(seconds: 1), () => Get.back());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save your rating. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Rate ${widget.fruit.name}"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.fruit.imageUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "Survey",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(flex: 2, child: Text("Product Rate", style: TextStyle(fontSize: 18))),
                Expanded(flex: 3, child: buildStars(productStars, (stars) => setState(() => productStars = stars))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(flex: 2, child: Text("Service Rate", style: TextStyle(fontSize: 18))),
                Expanded(flex: 3, child: buildStars(serviceStars, (stars) => setState(() => serviceStars = stars))),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Leave a Comment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your comment here...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: submitRate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  minimumSize: const Size(180, 50),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
