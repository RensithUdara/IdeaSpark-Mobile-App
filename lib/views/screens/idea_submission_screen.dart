import 'package:flutter/material.dart';
import '../../controllers/idea_controller.dart';
import '../../utils/constants.dart';

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
      await Future.delayed(Duration(seconds: AppConstants.aiProcessingDelay));

      try {
        await IdeaController.submitIdea(
          name: _nameController.text,
          tagline: _taglineController.text,
          description: _descriptionController.text,
        );

        setState(() {
          _isSubmitting = false;
        });

        _showToast(AppConstants.ideaSubmittedMessage);

        // Clear form
        _nameController.clear();
        _taglineController.clear();
        _descriptionController.clear();
      } catch (error) {
        setState(() {
          _isSubmitting = false;
        });
        _showToast('Error submitting idea. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submit Your Idea',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Share your innovative startup idea with the community and get AI-powered feedback!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Idea Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Idea Name',
                hintText: 'Enter your startup idea name',
                prefixIcon: Icon(Icons.lightbulb_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.nameRequiredMessage;
                }
                if (value.length < AppConstants.nameMinLength) {
                  return AppConstants.nameMinLengthMessage;
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Tagline Field
            TextFormField(
              controller: _taglineController,
              decoration: InputDecoration(
                labelText: 'Tagline',
                hintText: 'A catchy one-liner describing your idea',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.taglineRequiredMessage;
                }
                if (value.length < AppConstants.taglineMinLength) {
                  return AppConstants.taglineMinLengthMessage;
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your idea in detail...',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.descriptionRequiredMessage;
                }
                if (value.length < AppConstants.descriptionMinLength) {
                  return AppConstants.descriptionMinLengthMessage;
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            
            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitIdea,
              child: _isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Processing...'),
                      ],
                    )
                  : Text('Submit Idea'),
            ),
            
            if (_isSubmitting) ...[
              SizedBox(height: 16),
              Card(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.smart_toy, color: Theme.of(context).primaryColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'AI is analyzing your idea and generating insights...',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
