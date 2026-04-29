import 'package:flutter/material.dart';

import '../compass_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

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

        return SizedBox(
          height: 700,
          child: Stack(
            children: [
              const Positioned(left: 56, top: 44, child: _TestingCenterLabel()),
              Positioned(
                top: 92,
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
        _PlainLoginField(label: 'Password *', controller: passwordController),
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
        ),
        const SizedBox(height: 16),
        _LoginLinkLine(
          leading: 'Don\'t have an account? ',
          link: 'Create an account now.',
          linkStyle: linkStyle,
        ),
        const SizedBox(height: 16),
        _LoginLinkLine(
          leading: 'Test Candidate Support ',
          link: 'Test Candidate Support',
          linkStyle: linkStyle,
        ),
        const SizedBox(height: 16),
        _LoginLinkLine(
          leading: 'Exam Tutorials ',
          link: 'Exam Tutorials',
          linkStyle: linkStyle,
        ),
      ],
    );
  }
}

class _PlainLoginField extends StatelessWidget {
  const _PlainLoginField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: CompassColors.certiportTeal),
              ),
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
        ),
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
          child: Center(
            child: Text(
              'C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
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
  });

  final String leading;
  final String link;
  final TextStyle linkStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: CompassColors.text,
          fontSize: 14,
          fontFamily: 'Arial',
        ),
        children: [
          TextSpan(text: leading),
          TextSpan(text: link, style: linkStyle),
        ],
      ),
    );
  }
}
