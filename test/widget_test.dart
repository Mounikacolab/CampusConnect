import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/main.dart';
import 'package:my_first_app/providers/notice_provider.dart';

void main() {
  testWidgets('CampusConnect displays its home screen title', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NoticeProvider(),
        child: const CampusConnectApp(),
      ),
    );
    await tester.pump();
    expect(find.text('CampusConnect'), findsOneWidget);
    expect(find.text('College Digital Notice Board'), findsOneWidget);
  });
}
