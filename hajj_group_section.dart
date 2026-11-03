import 'package:flutter/material.dart';

class HajjGroupSection extends StatelessWidget {
  const HajjGroupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEEF2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Text('হজ্জ গ্রুপ', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.circle, color: Colors.red, size: 10),
            SizedBox(width: 4),
            Text('লাইভ', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessage(
                  'মুফতি আব্দুল্লাহ',
                  'আসসালামু আলাইকুম। কারো কোনো প্রশ্ন থাকলে করতে পারেন।',
                  '১০:৩০ AM',
                  isDark,
                  isAdmin: true,
                ),
                const SizedBox(height: 10),
                _buildMessage(
                  'আবু বকর',
                  'ইহরাম অবস্থায় কি মোবাইল ব্যবহার করা যাবে?',
                  '১০:৩২ AM',
                  isDark,
                ),
                const SizedBox(height: 10),
                _buildMessage(
                  'মুফতি আব্দুল্লাহ',
                  'হ্যাঁ, মোবাইল ব্যবহারে কোনো বাধা নেই। তবে অশ্লীল কথা বা ঝগড়া থেকে বিরত থাকুন।',
                  '১০:৩৩ AM',
                  isDark,
                  isAdmin: true,
                ),
                const SizedBox(height: 10),
                _buildMessage(
                  'ফাতিমা',
                  'মহিলাদের ইহরামে কী কী পরতে হয়?',
                  '১০:৩৫ AM',
                  isDark,
                ),
                const SizedBox(height: 10),
                _buildMessage(
                  'মুফতি আব্দুল্লাহ',
                  'মহিলারা তাদের স্বাভাবিক পোশাক পরবেন, শুধু নিকাব ও গ্লাভস খুলে রাখবেন। মাথা ও শরীর ঢাকা থাকবে।',
                  '১০:৩৬ AM',
                  isDark,
                  isAdmin: true,
                ),
              ],
            ),
          ),
          _buildMessageInput(isDark),
        ],
      ),
    );
  }

  Widget _buildMessage(
    String name,
    String message,
    String time,
    bool isDark, {
    bool isAdmin = false,
  }) {
    return Align(
      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAdmin
              ? (isDark ? Colors.green[900] : Colors.green[50])
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAdmin ? Colors.green[700] : Colors.blue[700],
                    fontSize: 12,
                  ),
                ),
                if (isAdmin) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'মুফতি',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'আপনার প্রশ্ন লিখুন...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.green[700],
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
