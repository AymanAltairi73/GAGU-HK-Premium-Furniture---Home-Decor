import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      // In debug mode, use the default error handler
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In release mode, log the error but don't crash
      debugPrint('Flutter error: ${details.exception}');
    }
  };

  // Catch errors outside Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform error: $error');
    return true;
  };

  runApp(const GaguApp());
}

class GaguApp extends StatelessWidget {
  const GaguApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAGU HK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF141E30)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const GaguWebPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE0E0E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.store,
                        size: 60,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'GAGU HK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Premium Furniture & Home Decor',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// صفحة تعرض موقع GAGU HK داخل WebView.
class GaguWebPage extends StatefulWidget {
  const GaguWebPage({super.key});

  @override
  State<GaguWebPage> createState() => _GaguWebPageState();
}

class _GaguWebPageState extends State<GaguWebPage> {
  // متحكم WebView لإدارة التحميل والتنقل داخل الصفحة.
  late final WebViewController _controller;

  // نستخدم هذا المتغير لإظهار/إخفاء مؤشر التحميل فوق الـ WebView.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // تهيئة WebView مع السماح بالجافاسكربت وتعريف سلوكيات التحميل والأخطاء.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            // هنا تقدر تضيف هاندل للأخطاء إذا تحب
          },
        ),
      )
      ..loadRequest(Uri.parse('https://gaguhk.com/'));
  }

  @override
  Widget build(BuildContext context) {
    // واجهة صفحة الـ WebView مع AppBar وزر إعادة تحميل ومؤشر تحميل فوق المحتوى.
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAGU HK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
