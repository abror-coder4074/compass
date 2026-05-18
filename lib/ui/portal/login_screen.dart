import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../compass_theme.dart';

final Uri _certiportUrl = Uri.parse('https://certiport.pearsonvue.com');

Future<void> _openCertiportWebsite(BuildContext context) async {
  final opened = await launchUrl(
    _certiportUrl,
    mode: LaunchMode.externalApplication,
  );

  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open Certiport website.')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    this.showInvalidLogin = false,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool showInvalidLogin;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        if (compact) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showInvalidLogin) ...[
                  const _InvalidLoginAlert(),
                  const SizedBox(height: 28),
                ],
                const _TestingCenterLabel(),
                const SizedBox(height: 30),
                _LoginForm(
                  usernameController: usernameController,
                  passwordController: passwordController,
                  onLogin: onLogin,
                ),
              ],
            ),
          );
        }

        final topOffset = showInvalidLogin ? 156.0 : 0.0;
        return SizedBox(
          height: 700 + topOffset,
          child: Stack(
            children: [
              if (showInvalidLogin)
                const Positioned(
                  left: 56,
                  top: 28,
                  right: 56,
                  child: _InvalidLoginAlert(),
                ),
              Positioned(
                left: 56,
                top: 44 + topOffset,
                child: const _TestingCenterLabel(),
              ),
              Positioned(
                top: 92 + topOffset,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 700,
                    child: _LoginForm(
                      usernameController: usernameController,
                      passwordController: passwordController,
                      onLogin: onLogin,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InvalidLoginAlert extends StatelessWidget {
  const _InvalidLoginAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('login-invalid-alert'),
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: 4,
                child: ColoredBox(color: Color(0xFFD94A35)),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDEAE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Color(0xFFD94A35),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Text(
                      'Invalid login.',
                      style: TextStyle(
                        color: CompassColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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

class _TestingCenterLabel extends StatelessWidget {
  const _TestingCenterLabel();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Edu Action LLC. (90087882)',
      style: TextStyle(
        color: CompassColors.text,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final linkStyle = TextStyle(
      color: Colors.blue.shade700,
      fontSize: 16,
      decoration: TextDecoration.underline,
      decorationColor: Colors.blue.shade700,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome',
          style: TextStyle(
            color: CompassColors.text,
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Log in to take your exam',
          style: TextStyle(
            color: CompassColors.text,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '(* indicates a required field)',
          style: TextStyle(
            color: CompassColors.mutedText,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 36),
        _PlainLoginField(label: 'Username *', controller: usernameController),
        const SizedBox(height: 20),
        _PlainLoginField(
          label: 'Password *',
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _LoginButton(onPressed: onLogin),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Or login with',
          style: TextStyle(color: CompassColors.text, fontSize: 14),
        ),
        const SizedBox(height: 10),
        _CertiportLoginButton(onPressed: onLogin),
        const SizedBox(height: 58),
        _LoginLinkLine(
          leading: 'Forgot your username or password? ',
          link: 'I Cannot Access My Account',
          linkStyle: linkStyle,
          onTap: () => _openCertiportWebsite(context),
        ),
        const SizedBox(height: 16),
        _LoginLinkLine(
          leading: 'Don\'t have an account? ',
          link: 'Create an account now.',
          linkStyle: linkStyle,
          onTap: () => _openCertiportWebsite(context),
        ),
        const SizedBox(height: 16),
        _LoginLinkLine(
          leading: 'Test Candidate Support ',
          link: 'Test Candidate Support',
          linkStyle: linkStyle,
          onTap: () => _openCertiportWebsite(context),
        ),
        const SizedBox(height: 16),
        _LoginLinkLine(
          leading: 'Exam Tutorials ',
          link: 'Exam Tutorials',
          linkStyle: linkStyle,
          onTap: () => _openCertiportWebsite(context),
        ),
      ],
    );
  }
}

class _PlainLoginField extends StatelessWidget {
  const _PlainLoginField({
    required this.label,
    required this.controller,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CompassColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 33,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enableSuggestions: !obscureText,
            autocorrect: !obscureText,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Color(0xFFD9D9D9)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Color(0xFFD9D9D9)),
              ),
              focusedBorder: CompassFocusedInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: CompassColors.certiportTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ).copyWith(side: CompassControlStates.elevatedHoverSide()),
        child: const Text('Login'),
      ),
    );
  }
}

class _CertiportLoginButton extends StatelessWidget {
  const _CertiportLoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF3B73F2),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Text(
                    'C',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginLinkLine extends StatelessWidget {
  const _LoginLinkLine({
    required this.leading,
    required this.link,
    required this.linkStyle,
    required this.onTap,
  });

  final String leading;
  final String link;
  final TextStyle linkStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          leading,
          style: const TextStyle(
            color: CompassColors.text,
            fontSize: 14,
            fontFamily: 'Arial',
          ),
        ),
        InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          child: Text(link, style: linkStyle),
        ),
      ],
    );
  }
}
