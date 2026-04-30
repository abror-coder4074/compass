import 'package:supabase_flutter/supabase_flutter.dart';

String friendlyErrorMessage(Object error) {
  if (error is AuthException) {
    return _cleanMessage(error.message, fallback: 'Authentication failed.');
  }
  if (error is PostgrestException) {
    return _postgrestMessage(error);
  }
  if (error is StorageException) {
    return _cleanMessage(error.message, fallback: 'Storage request failed.');
  }
  if (error is FormatException) {
    return _cleanMessage(error.message, fallback: 'Invalid data format.');
  }

  final text = error.toString();
  return _cleanMessage(
    _extractMessageField(text),
    fallback: 'Something went wrong.',
  );
}

String _postgrestMessage(PostgrestException error) {
  final searchable = [
    error.message,
    error.code,
    error.details?.toString(),
    error.hint,
  ].whereType<String>().join(' ');

  if (searchable.contains('duplicate key') || searchable.contains('23505')) {
    return 'A record with the same unique value already exists.';
  }
  if (searchable.contains('violates foreign key') ||
      searchable.contains('23503')) {
    return 'This record references a missing related record.';
  }

  return _cleanMessage(error.message, fallback: 'Database request failed.');
}

String _extractMessageField(String text) {
  final messageMatch = RegExp(
    r'message:\s*(.*?)(?:,\s*(?:statusCode|code|details|hint|error|originalError):|\)$)',
  ).firstMatch(text);
  if (messageMatch != null) {
    return messageMatch.group(1) ?? text;
  }
  return text;
}

String _cleanMessage(String message, {required String fallback}) {
  var text = message.trim();
  for (final prefix in const [
    'Exception: ',
    'FormatException: ',
    'AuthException: ',
    'PostgrestException: ',
    'StorageException: ',
  ]) {
    if (text.startsWith(prefix)) {
      text = text.substring(prefix.length).trim();
    }
  }
  return text.isEmpty ? fallback : text;
}
