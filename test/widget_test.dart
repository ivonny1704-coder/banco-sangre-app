import 'package:banco_sangre_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const BancoSangreApp());

    await tester.pumpAndSettle();

    expect(find.text('Banco de Sangre'), findsOneWidget);

    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
