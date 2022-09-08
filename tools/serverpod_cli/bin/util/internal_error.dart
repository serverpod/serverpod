import 'print.dart';

void printInternalError(dynamic error, StackTrace stackTrace) {
  printww(
    'It is possible that this error is caused by an internal issue with the Serverpod tooling. We would appreciate if you filed an issue over at Github. Please include the stack trace below.',
  );
  print(error);
  print(stackTrace);
  print('');
}
