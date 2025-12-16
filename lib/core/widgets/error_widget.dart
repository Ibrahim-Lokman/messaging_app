import 'package:flutter/material.dart';
import '../errors/failure.dart';

/// Reusable error display widget
class ErrorDisplayWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const ErrorDisplayWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForFailure(failure),
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _getTitleForFailure(failure),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              failure.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  // Inherit padding from theme
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForFailure(Failure failure) {
    if (failure is NetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is AuthFailure) {
      return Icons.lock_outline;
    } else if (failure is ServerFailure) {
      return Icons.cloud_off;
    } else {
      return Icons.error_outline;
    }
  }

  String _getTitleForFailure(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Connection Error';
    } else if (failure is AuthFailure) {
      return 'Authentication Error';
    } else if (failure is ServerFailure) {
      return 'Server Error';
    } else {
      return 'Error';
    }
  }
}

/// Compact error message widget (for inline display)
class ErrorMessageWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const ErrorMessageWidget({
    super.key,
    required this.failure,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              failure.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: onRetry,
              color: Theme.of(context).colorScheme.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}
