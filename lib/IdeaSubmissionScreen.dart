import 'dart:math';

import 'package:flutter/material.dart';

import 'StartupIdea.dart';
import 'StorageServices.dart';
class IdeaSubmissionScreen extends StatefulWidget {
  @override
  _IdeaSubmissionScreenState createState() => _IdeaSubmissionScreenState();
}

class _IdeaSubmissionScreenState extends State<IdeaSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  int _generateAIRating() {
    Random random = Random();
    return 60 + random.nextInt(40); // Rating between 60-100
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _submitIdea() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate AI processing
      await Future.delayed(Duration(seconds: 2));

      String id = DateTime.now().millisecondsSinceEpoch.toString();
      StartupIdea newIdea = StartupIdea(
        id: id,
        name: _nameController.text,
        tagline: _taglineController.text,
        description: _descriptionController.text,
        aiRating: _generateAIRating(),
        createdAt: DateTime.now(),
      );

      await StorageServices.saveIdea(newIdea);

      setState(() {
        _isSubmitting = false;
      });

      _showToast('🎉 Idea submitted successfully! AI Rating: ${newIdea.aiRating}/100');

      // Clear form
      _nameController.clear();
      _taglineController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Submit Your Startup Idea',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Startup Name',labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter startup name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _taglineController,
              decoration: InputDecoration(
                labelText: 'Tagline',labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.campaign),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter tagline';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            SizedBox(height: 24),

            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitIdea,
                child: _isSubmitting
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('AI is evaluating...'),
                  ],
                )
                    : Text('Submit Idea', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}