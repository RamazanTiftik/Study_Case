import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// default language -> de
final localeProvider = StateProvider<Locale>((ref) => const Locale('de'));
