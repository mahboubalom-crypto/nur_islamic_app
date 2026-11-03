import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// একটি বয়ানের তথ্য
class BoyanItem {
  final String title;
  final String speaker;
  final String audioUrl;
  final IconData icon;

  const BoyanItem({
    required this.title,
    required this.speaker,
    required this.audioUrl,
    required this.icon,
  });
}

/// বয়ান তালিকা (আপাতত একজন বক্তার ৫টি রিয়েল বয়ান — archive.org থেকে)
final List<BoyanItem> boyanList = [
  const BoyanItem(
    title: 'নবী মুহাম্মদ (সা.)-এর জীবনী',
    speaker: 'মিজানুর রহমান আজহারী',
    icon: Icons.mosque_outlined,
    audioUrl:
        'https://archive.org/download/mizanurrahmanazharimahfilaudiocollection1/Biography_of_Prophet_Muhammad_By_Mizanur_Rahman_Azhari.mp3',
  ),
  const BoyanItem(
    title: 'কিয়ামতের ময়দান',
    speaker: 'মিজানুর রহমান আজহারী',
    icon: Icons.wb_twilight,
    audioUrl:
        'https://archive.org/download/mizanurrahmanazharimahfilaudiocollection1/Kiyamoter_Moydan_By_Mizanur_Rahman_Azhari.mp3',
  ),
  const BoyanItem(
    title: 'কুরআনের জন্য মৃত্যু',
    speaker: 'মিজানুর রহমান আজহারী',
    icon: Icons.menu_book,
    audioUrl:
        'https://archive.org/download/mizanurrahmanazharimahfilaudiocollection1/Quraner_Jonno_Moron_By_Mizanur_Rahman_Azhari.mp3',
  ),
  const BoyanItem(
    title: 'স্বামী স্ত্রীর সম্পর্ক',
    speaker: 'মিজানুর রহমান আজহারী',
    icon: Icons.favorite_border,
    audioUrl:
        'https://archive.org/download/mizanurrahmanazharimahfilaudiocollection1/Shami_Strir_Shomporke_By_Mizanur_Rahman_Azhari.mp3',
  ),
  const BoyanItem(
    title: 'সূরা যিলযাল তাফসীর',
    speaker: 'মিজানুর রহমান আজহারী',
    icon: Icons.auto_awesome,
    audioUrl:
        'https://archive.org/download/mizanurrahmanazharimahfilaudiocollection1/Tafsir_of_Surah_Zilzal_By_Mizanur_Rahman_Azhari.mp3',
  ),
];

class BoyanSection extends StatelessWidget {
  const BoyanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        ...boyanList.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildBoyanCard(context, item),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF064E3B),
            Color(0xFF0F2E2A),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic_none_outlined,
                color: Colors.amber,
                size: 25,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'বয়ান',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'ইসলামিক বয়ান শুনুন',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoyanCard(BuildContext context, BoyanItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BoyanPlayerPage(item: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[700]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.teal[900],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.teal[700]!,
                ),
              ),
              child: Icon(
                item.icon,
                color: Colors.teal[300],
                size: 25,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.speaker,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_outline,
              color: Colors.grey[400],
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}

/// বয়ান প্লেয়ার পেজ — audioplayers প্যাকেজ ব্যবহার করে
class BoyanPlayerPage extends StatefulWidget {
  final BoyanItem item;

  const BoyanPlayerPage({super.key, required this.item});

  @override
  State<BoyanPlayerPage> createState() => _BoyanPlayerPageState();
}

class _BoyanPlayerPageState extends State<BoyanPlayerPage> {
  final AudioPlayer _player = AudioPlayer();

  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _playerState = state);
    });

    _player.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });

    _player.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });

    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _position = Duration.zero);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    setState(() => _errorMessage = null);

    try {
      if (_playerState == PlayerState.playing) {
        await _player.pause();
      } else if (_playerState == PlayerState.paused) {
        await _player.resume();
      } else {
        setState(() => _isLoading = true);
        await _player.play(UrlSource(widget.item.audioUrl));
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'অডিও চালাতে সমস্যা হয়েছে। ইন্টারনেট সংযোগ পরীক্ষা করুন।';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF042F2E),
        foregroundColor: Colors.white,
        title: Text(
          widget.item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.teal[900],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.teal[700]!),
              ),
              child: Icon(
                widget.item.icon,
                color: Colors.teal[200],
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.item.speaker,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),

            // সিক বার
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                min: 0,
                max: _duration.inSeconds > 0
                    ? _duration.inSeconds.toDouble()
                    : 1,
                value: _position.inSeconds
                    .clamp(0, _duration.inSeconds)
                    .toDouble(),
                activeColor: Colors.teal[300],
                inactiveColor: Colors.grey[800],
                onChanged: (value) {
                  _player.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // প্লে/পজ বাটন
            InkWell(
              onTap: _isLoading ? null : _togglePlayPause,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.teal[700],
                  shape: BoxShape.circle,
                ),
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(22),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 38,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
