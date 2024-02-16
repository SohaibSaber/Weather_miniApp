import 'package:clean_architecture/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:clean_architecture/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/widgets/main_wrapper.dart';
import 'features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue.withOpacity(0.002),
  ));

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(providers: [
        BlocProvider(create: (_) => locator<HomeBloc>()),
        BlocProvider(create: (_) => locator<BookmarkBloc>()),
      ], child: MainWrapper())));
}
