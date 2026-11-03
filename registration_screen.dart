// ==========================================================
// RegistrationScreen — প্রথমবার অ্যাপ খুললে নিবন্ধনের স্ক্রিন
//
// • তথ্য: নাম, মোবাইল নম্বর, ইমেইল
// • "এড়িয়ে যান" দিয়ে স্কিপ করা যায়
// • তথ্য শুধু এই ফোনের SharedPreferences-এ সেভ হয় (কোনো সার্ভারে যায় না)
// • নিবন্ধন বা স্কিপ — যেটাই হোক, স্ক্রিনটা আর দ্বিতীয়বার আসে না
//
// পরে সার্ভার/Firebase যোগ করতে চাইলে শুধু
// RegistrationStore.save() ফাংশনটা বদলালেই হবে, স্ক্রিন বদলাতে হবে না।
// ==========================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationStore {
  static const String doneKey = 'nur_registration_done';
  static const String skippedKey = 'nur_registration_skipped';
  static const String nameKey = 'nur_reg_name';
  static const String phoneKey = 'nur_reg_phone';
  static const String emailKey = 'nur_reg_email';

  static Future<bool> isDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(doneKey) ?? false;
  }

  // ভবিষ্যতে সার্ভারে পাঠাতে হলে এই ফাংশনের ভেতরেই পাঠানোর কোড বসবে।
  static Future<void> save({
    required String name,
    required String phone,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameKey, name);
    await prefs.setString(phoneKey, phone);
    await prefs.setString(emailKey, email);
    await prefs.setBool(skippedKey, false);
    await prefs.setBool(doneKey, true);
  }

  static Future<void> skip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(skippedKey, true);
    await prefs.setBool(doneKey, true);
  }

  static Future<Map<String, String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(nameKey) ?? '',
      'phone': prefs.getString(phoneKey) ?? '',
      'email': prefs.getString(emailKey) ?? '',
    };
  }
}

class RegistrationScreen extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onFinished;

  const RegistrationScreen({
    super.key,
    required this.isDarkTheme,
    required this.onFinished,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // বাংলা অঙ্ক লিখলেও যেন ঠিকমতো যাচাই ও সেভ হয়।
  String _normalizePhone(String input) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var result = input;
    for (var i = 0; i < bn.length; i++) {
      result = result.replaceAll(bn[i], i.toString());
    }
    return result.replaceAll(RegExp(r'[\s\-()]'), '');
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().length < 2) return 'আপনার নাম লিখুন';
    return null;
  }

  String? _validatePhone(String? v) {
    final phone = _normalizePhone(v ?? '');
    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(phone)) {
      return 'সঠিক মোবাইল নম্বর লিখুন (দেশের কোডসহ হলেও চলবে)';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final email = (v ?? '').trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'সঠিক ইমেইল লিখুন';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _busy = true);
    try {
      await RegistrationStore.save(
        name: _nameCtrl.text.trim(),
        phone: _normalizePhone(_phoneCtrl.text),
        email: _emailCtrl.text.trim(),
      );
    } catch (_) {
      // সেভ ব্যর্থ হলেও অ্যাপ চালু হবে; পরের বার স্ক্রিনটা আবার আসবে।
    }
    if (!mounted) return;
    widget.onFinished();
  }

  Future<void> _skip() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await RegistrationStore.skip();
    } catch (_) {}
    if (!mounted) return;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.isDarkTheme;
    final titleColor = dark ? Colors.white : const Color(0xFF0F2E2A);
    final subColor = dark ? Colors.grey[400]! : Colors.grey[700]!;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF020617) : const Color(0xFFEEF2F1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(titleColor, subColor),
                  const SizedBox(height: 24),
                  _field(
                    controller: _nameCtrl,
                    label: 'নাম',
                    icon: Icons.person_outline,
                    validator: _validateName,
                    keyboardType: TextInputType.name,
                    dark: dark,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    controller: _phoneCtrl,
                    label: 'মোবাইল নম্বর',
                    icon: Icons.phone_outlined,
                    validator: _validatePhone,
                    keyboardType: TextInputType.phone,
                    formatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9০-৯+\-\s()]')),
                    ],
                    dark: dark,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    controller: _emailCtrl,
                    label: 'ইমেইল',
                    icon: Icons.mail_outline,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    action: TextInputAction.done,
                    onSubmitted: _submit,
                    dark: dark,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _busy ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'নিবন্ধন করুন',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: _busy ? null : _skip,
                    child: Text(
                      'এড়িয়ে যান',
                      style: TextStyle(
                        color: dark ? Colors.green[300] : Colors.green[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'আপনার তথ্য শুধু এই ফোনেই সংরক্ষিত থাকবে, কোথাও পাঠানো হবে না।',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subColor, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color titleColor, Color subColor) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF1F4B3F), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: const Text('🕌', style: TextStyle(fontSize: 36)),
        ),
        const SizedBox(height: 14),
        Text(
          'স্বাগতম',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'নাম, মোবাইল নম্বর ও ইমেইল দিয়ে নিবন্ধন করুন।\nচাইলে এড়িয়ে যেতেও পারেন।',
          textAlign: TextAlign.center,
          style: TextStyle(color: subColor, fontSize: 12.5, height: 1.4),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required bool dark,
    TextInputType? keyboardType,
    TextInputAction action = TextInputAction.next,
    List<TextInputFormatter>? formatters,
    VoidCallback? onSubmitted,
  }) {
    final baseBorder = dark ? const Color(0xFF1E293B) : const Color(0xFFE1E6E4);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: action,
      inputFormatters: formatters,
      validator: validator,
      onFieldSubmitted: (_) => onSubmitted?.call(),
      style: TextStyle(
        color: dark ? Colors.white : Colors.black87,
        fontSize: 14.5,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: dark ? Colors.grey[400] : Colors.grey[700],
          fontSize: 13.5,
        ),
        prefixIcon: Icon(icon, size: 20, color: Colors.green[700]),
        filled: true,
        fillColor: dark ? const Color(0xFF0F172A) : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: _border(baseBorder),
        enabledBorder: _border(baseBorder),
        focusedBorder: _border(Colors.green[700]!, width: 1.6),
        errorBorder: _border(Colors.red[400]!),
        focusedErrorBorder: _border(Colors.red[400]!, width: 1.6),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
