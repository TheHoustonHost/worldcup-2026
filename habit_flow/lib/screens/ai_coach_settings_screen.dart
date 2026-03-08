import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class AICoachSettingsScreen extends StatefulWidget {
  const AICoachSettingsScreen({super.key});

  @override
  State<AICoachSettingsScreen> createState() => _AICoachSettingsScreenState();
}

class _AICoachSettingsScreenState extends State<AICoachSettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  String? _savedKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedKey = prefs.getString('openai_api_key');
      _apiKeyController.text = _savedKey ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveApiKey() async {
    setState(() => _isSaving = true);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('openai_api_key', _apiKeyController.text.trim());
    
    setState(() {
      _savedKey = _apiKeyController.text.trim();
      _isSaving = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API Key saved!'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
    }
  }

  Future<void> _clearApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('openai_api_key');
    
    setState(() {
      _apiKeyController.clear();
      _savedKey = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API Key cleared'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  Card(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'About AI Coach',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'AI Coach uses OpenAI to provide personalized habit advice. Without an API key, it uses a basic rule-based system.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // API Key Input
                  const Text(
                    'OpenAI API Key',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'sk-...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get your API key from platform.openai.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Status
                  if (_savedKey != null && _savedKey!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.secondaryColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'API Key configured',
                            style: TextStyle(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveApiKey,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save API Key'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Clear Button
                  if (_savedKey != null && _savedKey!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _clearApiKey,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppTheme.errorColor),
                          foregroundColor: AppTheme.errorColor,
                        ),
                        child: const Text('Clear API Key'),
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Usage Info
                  const Text(
                    'Pricing',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PricingRow(
                            label: 'GPT-4o Mini',
                            price: '\$0.60 / 1M input tokens',
                          ),
                          const SizedBox(height: 8),
                          _PricingRow(
                            label: 'GPT-4o Mini',
                            price: '\$2.40 / 1M output tokens',
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Typical monthly cost for AI Coach: \$1-5/month with normal usage',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String label;
  final String price;

  const _PricingRow({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          price,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
