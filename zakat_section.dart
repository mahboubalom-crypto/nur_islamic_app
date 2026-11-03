import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZakatSection extends StatefulWidget {
  final void Function(String tab) setActiveTab;

  const ZakatSection({super.key, required this.setActiveTab});

  @override
  State<ZakatSection> createState() => _ZakatSectionState();
}

class _ZakatSectionState extends State<ZakatSection> {
  int _tabIndex = 0; // 0 = হিসাব, 1 = ফিতরা, 2 = জানুন

  // নিসাব হিসাবের জন্য দাম (ইউজার পরিবর্তন করতে পারবে)
  // সাড়ে ৭ ভরি সোনা = ৮৭.৪৮ গ্রাম, সাড়ে ৫২ ভরি রুপা = ৬১২.৩৬ গ্রাম
  static const double goldNisabGram = 87.48;
  static const double silverNisabGram = 612.36;

  final _goldPriceCtrl = TextEditingController(text: '12000'); // প্রতি গ্রাম
  final _silverPriceCtrl = TextEditingController(text: '150'); // প্রতি গ্রাম

  final _cashCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _goldGramCtrl = TextEditingController();
  final _silverGramCtrl = TextEditingController();
  final _businessCtrl = TextEditingController();
  final _investmentCtrl = TextEditingController();
  final _receivableCtrl = TextEditingController();
  final _debtCtrl = TextEditingController();

  // ফিতরা
  final _fitraPersonCtrl = TextEditingController(text: '1');
  final _wheatPriceCtrl = TextEditingController(text: '60'); // প্রতি কেজি (গম)
  final _fitraKgCtrl = TextEditingController(text: '1.75'); // ১.৭৫ কেজি গম

  bool _nisabBySilver = true; // সতর্কতামূলক: রুপার নিসাব

  double? _totalAsset;
  double? _zakatAmount;
  double? _nisabValue;
  bool? _isEligible;

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goldPriceCtrl.text =
          prefs.getString('zakat_gold_price') ?? _goldPriceCtrl.text;
      _silverPriceCtrl.text =
          prefs.getString('zakat_silver_price') ?? _silverPriceCtrl.text;
      _wheatPriceCtrl.text =
          prefs.getString('zakat_wheat_price') ?? _wheatPriceCtrl.text;
    });
  }

  Future<void> _savePrices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zakat_gold_price', _goldPriceCtrl.text);
    await prefs.setString('zakat_silver_price', _silverPriceCtrl.text);
    await prefs.setString('zakat_wheat_price', _wheatPriceCtrl.text);
  }

  @override
  void dispose() {
    for (final c in [
      _goldPriceCtrl,
      _silverPriceCtrl,
      _cashCtrl,
      _bankCtrl,
      _goldGramCtrl,
      _silverGramCtrl,
      _businessCtrl,
      _investmentCtrl,
      _receivableCtrl,
      _debtCtrl,
      _fitraPersonCtrl,
      _wheatPriceCtrl,
      _fitraKgCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _v(TextEditingController c) =>
      double.tryParse(_toEnglishDigits(c.text.trim())) ?? 0;

  String _toEnglishDigits(String input) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var out = input;
    for (var i = 0; i < bn.length; i++) {
      out = out.replaceAll(bn[i], i.toString());
    }
    return out;
  }

  String _toBn(String input) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var out = input;
    for (var i = 0; i < bn.length; i++) {
      out = out.replaceAll(i.toString(), bn[i]);
    }
    return out;
  }

  String _fmt(double v) => _toBn(v.toStringAsFixed(2));

  void _calculate() {
    FocusScope.of(context).unfocus();
    _savePrices();

    final goldPrice = _v(_goldPriceCtrl);
    final silverPrice = _v(_silverPriceCtrl);

    final goldValue = _v(_goldGramCtrl) * goldPrice;
    final silverValue = _v(_silverGramCtrl) * silverPrice;

    final total = _v(_cashCtrl) +
        _v(_bankCtrl) +
        goldValue +
        silverValue +
        _v(_businessCtrl) +
        _v(_investmentCtrl) +
        _v(_receivableCtrl);

    final net = total - _v(_debtCtrl);

    final nisab = _nisabBySilver
        ? silverNisabGram * silverPrice
        : goldNisabGram * goldPrice;

    final eligible = net >= nisab && nisab > 0;

    setState(() {
      _totalAsset = net;
      _nisabValue = nisab;
      _isEligible = eligible;
      _zakatAmount = eligible ? net * 0.025 : 0;
    });
  }

  void _reset() {
    for (final c in [
      _cashCtrl,
      _bankCtrl,
      _goldGramCtrl,
      _silverGramCtrl,
      _businessCtrl,
      _investmentCtrl,
      _receivableCtrl,
      _debtCtrl,
    ]) {
      c.clear();
    }
    setState(() {
      _totalAsset = null;
      _zakatAmount = null;
      _nisabValue = null;
      _isEligible = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(isDark),
        const SizedBox(height: 12),
        _tabs(isDark),
        const SizedBox(height: 14),
        if (_tabIndex == 0) _calculatorTab(isDark),
        if (_tabIndex == 1) _fitraTab(isDark),
        if (_tabIndex == 2) _learnTab(isDark),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _header(bool isDark) {
    return Row(
      children: [
        InkWell(
          onTap: () => widget.setActiveTab('seba'),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black87),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 6,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.orange[700],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'যাকাত ও ফিতরা',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _tabs(bool isDark) {
    final labels = ['যাকাত হিসাব', 'ফিতরা', 'জানুন'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      selected ? const Color(0xFF315B4D) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : (isDark ? Colors.white70 : const Color(0xFF315B4D)),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _card(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: child,
    );
  }

  Widget _cardTitle(String t, bool isDark) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          t,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF315B4D),
          ),
        ),
      );

  Widget _input(
    String label,
    TextEditingController ctrl,
    bool isDark, {
    String? hint,
    String suffix = '৳',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint ?? '0',
          suffixText: suffix,
          labelStyle:
              TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF315B4D), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF315B4D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _calculatorTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card(
          isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardTitle('নিসাব ও বর্তমান বাজারদর', isDark),
              _input('সোনার দাম (প্রতি গ্রাম)', _goldPriceCtrl, isDark),
              _input('রুপার দাম (প্রতি গ্রাম)', _silverPriceCtrl, isDark),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'নিসাব হিসাব করুন:',
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('রুপা'),
                    selected: _nisabBySilver,
                    onSelected: (_) => setState(() => _nisabBySilver = true),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('সোনা'),
                    selected: !_nisabBySilver,
                    onSelected: (_) => setState(() => _nisabBySilver = false),
                  ),
                ],
              ),
            ],
          ),
        ),
        _card(
          isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardTitle('সম্পদের বিবরণ', isDark),
              _input('হাতে থাকা নগদ টাকা', _cashCtrl, isDark),
              _input('ব্যাংকে জমানো টাকা', _bankCtrl, isDark),
              _input('স্বর্ণের পরিমাণ (গ্রাম)', _goldGramCtrl, isDark,
                  suffix: 'গ্রাম'),
              _input('রুপার পরিমাণ (গ্রাম)', _silverGramCtrl, isDark,
                  suffix: 'গ্রাম'),
              _input('ব্যবসার পণ্যের মূল্য', _businessCtrl, isDark),
              _input('বিনিয়োগ ও অন্যান্য সঞ্চয়', _investmentCtrl, isDark),
              _input('পাওনা টাকা (যা ফেরত পাবেন)', _receivableCtrl, isDark),
              _input('ঋণ বা দেনা (যা পরিশোধ করতে হবে)', _debtCtrl, isDark),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(child: _primaryButton('হিসাব করুন', _calculate)),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('রিসেট'),
            ),
          ],
        ),
        if (_totalAsset != null) ...[
          const SizedBox(height: 14),
          _card(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardTitle('হিসাবের ফলাফল', isDark),
                Text('নিসাব মূল্য: ${_fmt(_nisabValue ?? 0)} ৳',
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87)),
                Text('নিট সম্পদ: ${_fmt(_totalAsset ?? 0)} ৳',
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87)),
                const Divider(),
                Text(
                  _isEligible == true
                      ? 'আপনি যাকাত প্রদানে বাধ্যবাধক (Eligible)'
                      : 'আপনার ওপর যাকাত ফরজ নয়',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isEligible == true ? Colors.green : Colors.red,
                  ),
                ),
                if (_isEligible == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    'প্রদেয় যাকাতের পরিমাণ: ${_fmt(_zakatAmount ?? 0)} ৳',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF315B4D),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _fitraTab(bool isDark) {
    return _card(
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('সাদাকাতুল ফিতর হিসাব', isDark),
          _input('পরিবারের সদস্য সংখ্যা', _fitraPersonCtrl, isDark,
              suffix: 'জন'),
          _input('গম/আটার বাজারদর (প্রতি কেজি)', _wheatPriceCtrl, isDark),
          _input('ফিতরার পরিমাণ (কেজি প্রতি জন)', _fitraKgCtrl, isDark,
              suffix: 'কেজি'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF315B4D)),
            child: const Text('ফিতরা হিসাব করুন',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
          Text(
            'মোট ফিতরা: ${_fmt((double.tryParse(_fitraPersonCtrl.text) ?? 1) * (double.tryParse(_wheatPriceCtrl.text) ?? 60) * (double.tryParse(_fitraKgCtrl.text) ?? 1.75))} ৳',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315B4D)),
          ),
        ],
      ),
    );
  }

  Widget _learnTab(bool isDark) {
    return _card(
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('যাকাত ও ফিতরা সম্পর্কে জরুরি মাসয়ালা', isDark),
          const Text(
            '১. যাকাত কার ওপর ফরজ?\nনিসাব পরিমাণ সম্পদের মালিক হলে এবং তা এক চন্দ্র বছরকাল স্থায়ী হলে তার ওপর যাকাত ফরজ হয়।\n\n'
            '২. নিসাব কী?\nস্বর্ণের ক্ষেত্রে সাড়ে ৭ ভরি (৮৭.৪৮ গ্রাম) এবং রূপার ক্ষেত্রে সাড়ে ৫২ ভরি (৬১২.৩৬ গ্রাম) সমপরিমাণ মূল্যকে নিসাব বলা হয়।\n\n'
            '৩. ফিতরা কখন ওয়াজিব হয়?\nঈদুল ফিতরের দিন সুবহে সাদিকের সময় যার কাছে নেসাব পরিমাণ সম্পদ থাকে, তার ওপর ফিতরা ওয়াজিব হয়।',
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}
