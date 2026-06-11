import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders an [AsyncValue]: a centered spinner while loading, a centered error
/// message on failure, and [builder] with the data once it's available.
///
/// For a view that needs several providers, nest one [AsyncValueView] per
/// provider (the inner builder runs only once the outer data is ready).
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.builder,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: builder,
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Error loading data:\n$error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
