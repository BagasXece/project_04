import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_4/core/themes/app_theme.dart';
import 'package:project_4/features/siswa/domain/repositories/siswa_repository.dart';
import 'package:project_4/features/siswa/domain/repositories/siswa_repository_impl.dart';
import 'package:project_4/features/siswa/presentation/providers/siswa_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_4/features/siswa/data/datasources/siswa_remote_datasource.dart';
import 'package:project_4/features/siswa/presentation/pages/siswa_list_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SiswaRemoteDataSource()),
        // ProxyProvider<SiswaRemoteDataSource, SiswaRepository>(
        //   update: (_, remoteDataSource, __) =>
        //       SiswaRepositoryImpl(remoteDataSource),
        // ),
        // ChangeNotifierProvider(create: (_) => SiswaFormProvider()),
        Provider<SiswaRepository>(
          create: (c) => SiswaRepositoryImpl(c.read<SiswaRemoteDataSource>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seleksi TNI',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: ChangeNotifierProvider(
        create: (_) =>
            SiswaListProvider(repository: context.read<SiswaRepository>()),
        child: const SiswaListPage(),
      ),
    );
  }
}
