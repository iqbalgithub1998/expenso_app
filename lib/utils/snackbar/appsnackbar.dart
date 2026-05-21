import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

/// A utility class for displaying styled snackbars using awesome_snackbar_content.
///
/// Usage:
///   AppSnackbar.success(context, title: 'Done!', message: 'Profile saved.');
///   AppSnackbar.error(context, title: 'Oops!', message: 'Something went wrong.');
///   AppSnackbar.warning(context, title: 'Warning', message: 'Battery low.');
///   AppSnackbar.info(context, title: 'FYI', message: 'New update available.');
///   AppSnackbar.help(context, title: 'Help', message: 'Tap here to learn more.');
class AppSnackbar {
  AppSnackbar._(); // Prevent instantiation

  // ─── Duration presets ────────────────────────────────────────────────────

  static const Duration _short = Duration(seconds: 2);
  static const Duration _medium = Duration(seconds: 4);
  static const Duration _long = Duration(seconds: 6);

  // ─── Public API ──────────────────────────────────────────────────────────

  /// Shows a **success** snackbar (green).
  static void success(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = _medium,
    bool floating = true,
  }) {
    _show(
      context,
      title: title,
      message: message,
      contentType: ContentType.success,
      duration: duration,
      floating: floating,
    );
  }

  /// Shows an **error** snackbar (red).
  static void error(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = _medium,
    bool floating = true,
  }) {
    _show(
      context,
      title: title,
      message: message,
      contentType: ContentType.failure,
      duration: duration,
      floating: floating,
    );
  }

  /// Shows a **warning** snackbar (orange).
  static void warning(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = _medium,
    bool floating = true,
  }) {
    _show(
      context,
      title: title,
      message: message,
      contentType: ContentType.warning,
      duration: duration,
      floating: floating,
    );
  }

  /// Shows an **info** snackbar (blue).
  static void info(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = _medium,
    bool floating = true,
  }) {
    _show(
      context,
      title: title,
      message: message,
      contentType: ContentType.help,
      duration: duration,
      floating: floating,
    );
  }

  /// Shows a **help** snackbar (teal).
  static void help(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = _medium,
    bool floating = true,
  }) {
    _show(
      context,
      title: title,
      message: message,
      contentType: ContentType.help,
      duration: duration,
      floating: floating,
    );
  }

  // ─── Duration shorthands ─────────────────────────────────────────────────

  /// Same as [success] but uses a 2-second duration.
  static void successShort(
    BuildContext context, {
    required String title,
    required String message,
  }) => success(context, title: title, message: message, duration: _short);

  /// Same as [error] but stays for 6 seconds.
  static void errorLong(
    BuildContext context, {
    required String title,
    required String message,
  }) => error(context, title: title, message: message, duration: _long);

  // ─── Core builder ────────────────────────────────────────────────────────

  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
    required Duration duration,
    required bool floating,
  }) {
    // Dismiss any existing snackbar first to prevent stacking.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      // Make the SnackBar background transparent so the
      // AwesomeSnackbarContent widget controls its own look.
      elevation: 0,
      behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
