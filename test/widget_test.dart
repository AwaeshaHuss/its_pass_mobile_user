import 'package:flutter_test/flutter_test.dart';
import 'package:itspass_user/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Verify that the app builds successfully
    expect(find.byType(MyApp), findsOneWidget);
  });
}
