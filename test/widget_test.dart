import 'package:flutter_test/flutter_test.dart';
import 'package:nexacode/main.dart';

void main() {
  testWidgets('NexaCodeApp renders login or dashboard',
      (WidgetTester tester) async {
    // Build the NexaCodeApp with a default language code
    await tester.pumpWidget(const NexaCodeApp(langCode: 'en'));

    // Wait for Firebase auth stream to settle
    await tester.pumpAndSettle();

    // Check for either login screen or dashboard screen
    expect(
      find.textContaining('Initializing NexaCode'),
      findsNothing, // Should be gone after loading
    );

    // Check for login screen text or dashboard content
    final loginText = find.textContaining('>>');
    final dashboardText = find.textContaining('Dashboard');

    // ✅ Use both variables in a conditional expectation
    expect(
      loginText.evaluate().isNotEmpty || dashboardText.evaluate().isNotEmpty,
      true,
      reason: 'Either login or dashboard screen should be visible',
    );
  });
}
