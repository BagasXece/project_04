import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Toast {
  static void show(String msg, Color color) {
    showOverlayNotification(
      (context) => SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(.85),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              msg,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 2),
    );
  }

  static void success(String msg) => show(msg, const Color(0xFF00C897));
  static void error(String msg) => show(msg, const Color(0xFFFF4C4C));
  static void warning(String msg) => show(msg, const Color(0xFFFF9F29));
}