import 'package:flutter/material.dart';

class Toast {
  static void success(BuildContext ctx, String msg) =>
      _show(ctx, msg, const Color(0xFF16A34A));
  static void error(BuildContext ctx, String msg) =>
      _show(ctx, msg, const Color(0xFFDC2626));
  static void warning(BuildContext ctx, String msg) =>
      _show(ctx, msg, const Color(0xFFF59E0B));

  static void _show(BuildContext ctx, String msg, Color accent) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        content: Container(
          decoration: BoxDecoration(
            color: accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Color(0xFF334155)),
                onPressed: () => ScaffoldMessenger.of(ctx).hideCurrentSnackBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}