import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    "https://firebasestorage.googleapis.com/v0/b/db-polleria-cabana.firebasestorage.app/o/Screen1.png?alt=media&token=456e2f75-717a-41ea-b5b8-f14b9463326a",
    "https://firebasestorage.googleapis.com/v0/b/db-polleria-cabana.firebasestorage.app/o/Screen2.png?alt=media&token=daa9e768-b664-4c3c-b852-f1d8a6d187b1",
    "https://firebasestorage.googleapis.com/v0/b/db-polleria-cabana.firebasestorage.app/o/Screen3.png?alt=media&token=ad08a440-3734-42f3-bebe-fd4a88d6ac65",
    "https://firebasestorage.googleapis.com/v0/b/db-polleria-cabana.firebasestorage.app/o/Screen4.png?alt=media&token=80a90c27-effa-4f1a-967f-32cdfa99b0cd",
    "https://firebasestorage.googleapis.com/v0/b/db-polleria-cabana.firebasestorage.app/o/Screen5.png?alt=media&token=a87940eb-aaae-4f50-a628-f4a78dfc92ff",
  ];

  /// 🔥 Versión segura sin null crash
  double _getSelected(int index) {
    if (!_pageController.hasClients) return 0;

    final page = _pageController.page;
    if (page == null) return 0;

    return (1 - ((page - index).abs().clamp(0.0, 1.0)));
  }

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      if (!_pageController.hasClients) return;

      final page = _pageController.page;
      if (page == null) return;

      setState(() {
        _currentPage = page.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔥 PageView estable
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // Indicadores
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                final selected = _getSelected(index);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10 + (10 * selected),
                  height: 10,
                  decoration: BoxDecoration(
                    color: selected > 0.5 ? Colors.brown : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
          ),

          // Botón "Empezar"
          if (_currentPage == _images.length - 1)
            Positioned(
              bottom: 40,
              left: 50,
              right: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/loginCliente');
                },
                child: const Text(
                  "Empezar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}











