import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../features/prime_number/domain/entities/number_data.dart';

/// Base widget for status display
abstract class StatusDisplayWidget extends StatefulWidget {
  const StatusDisplayWidget({super.key});
}

/// Loading status widget with creative animation
class LoadingStatusWidget extends StatusDisplayWidget {
  final DateTime? lastFetchTime;
  final DateTime? lastPrimeTime;

  const LoadingStatusWidget({
    super.key,
    this.lastFetchTime,
    this.lastPrimeTime,
  });

  @override
  State<LoadingStatusWidget> createState() => _LoadingStatusWidgetState();
}

class _LoadingStatusWidgetState extends State<LoadingStatusWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  Timer? _timer;
  String _timeSinceLastPrime = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startTimer();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
  }

  void _startTimer() {
    _updateTimeSinceLastPrime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeSinceLastPrime();
    });
  }

  void _updateTimeSinceLastPrime() {
    if (widget.lastPrimeTime != null && mounted) {
      final duration = DateTime.now().difference(widget.lastPrimeTime!);
      setState(() {
        _timeSinceLastPrime = _formatDuration(duration);
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creative loading animation
        SizedBox(
          width: 40,
          height: 40,
          child: AnimatedBuilder(
            animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Stack(
                  children: [
                    // Outer ring
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    // Inner pulsing dot
                    Center(
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 8 * _pulseAnimation.value,
                            height: 8 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withValues(
                                alpha: _pulseAnimation.value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Orbiting dots
                    ...List.generate(3, (index) {
                      final angle =
                          (index * 2 * math.pi / 3) + _rotationAnimation.value;
                      return Transform.translate(
                        offset: Offset(
                          15 * math.cos(angle),
                          15 * math.sin(angle),
                        ),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withValues(alpha: 0.6),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Fetching...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        if (widget.lastPrimeTime != null && _timeSinceLastPrime.isNotEmpty)
          Text(
            'Last prime: $_timeSinceLastPrime ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          )
        else
          Text(
            'No primes found yet',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        const SizedBox(height: 8),
        Text(
          'Auto-fetching every 10 seconds',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

/// Number loaded status widget
class NumberLoadedStatusWidget extends StatusDisplayWidget {
  final NumberData numberData;
  final DateTime lastFetchTime;
  final DateTime? lastPrimeTime;

  const NumberLoadedStatusWidget({
    super.key,
    required this.numberData,
    required this.lastFetchTime,
    this.lastPrimeTime,
  });

  @override
  State<NumberLoadedStatusWidget> createState() =>
      _NumberLoadedStatusWidgetState();
}

class _NumberLoadedStatusWidgetState extends State<NumberLoadedStatusWidget> {
  Timer? _timer;
  String _timeSinceLastPrime = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _updateTimeSinceLastPrime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeSinceLastPrime();
    });
  }

  void _updateTimeSinceLastPrime() {
    if (widget.lastPrimeTime != null && mounted) {
      final duration = DateTime.now().difference(widget.lastPrimeTime!);
      setState(() {
        _timeSinceLastPrime = _formatDuration(duration);
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${widget.numberData.number}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Not prime',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
        ),
        const SizedBox(height: 4),
        if (widget.lastPrimeTime != null && _timeSinceLastPrime.isNotEmpty)
          Text(
            'Last prime: $_timeSinceLastPrime ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          )
        else
          Text(
            'No primes found yet',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        const SizedBox(height: 8),
        Text(
          'Auto-fetching every 10 seconds',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Prime found status widget with shimmer effect
class PrimeFoundStatusWidget extends StatusDisplayWidget {
  final NumberData numberData;
  final DateTime lastFetchTime;
  final DateTime? lastPrimeTime;

  const PrimeFoundStatusWidget({
    super.key,
    required this.numberData,
    required this.lastFetchTime,
    this.lastPrimeTime,
  });

  @override
  State<PrimeFoundStatusWidget> createState() => _PrimeFoundStatusWidgetState();
}

class _PrimeFoundStatusWidgetState extends State<PrimeFoundStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  Timer? _timer;
  String _timeSinceLastPrime = '';

  @override
  void initState() {
    super.initState();
    _setupShimmer();
    _startTimer();
  }

  void _setupShimmer() {
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  void _startTimer() {
    _updateTimeSinceLastPrime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeSinceLastPrime();
    });
  }

  void _updateTimeSinceLastPrime() {
    if (widget.lastPrimeTime != null && mounted) {
      final duration = DateTime.now().difference(widget.lastPrimeTime!);
      setState(() {
        _timeSinceLastPrime = _formatDuration(duration);
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withValues(
                    alpha: 0.3 + 0.3 * _shimmerAnimation.value.abs(),
                  ),
                  width: 2,
                ),
              ),
              child: Text(
                '${widget.numberData.number}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'PRIME! 🎉',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        if (widget.lastPrimeTime != null && _timeSinceLastPrime.isNotEmpty)
          Text(
            'Last prime: $_timeSinceLastPrime ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          )
        else
          Text(
            'First prime found!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        const SizedBox(height: 8),
        Text(
          'Auto-fetching every 10 seconds',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shimmerController.dispose();
    super.dispose();
  }
}

/// Error status widget
class ErrorStatusWidget extends StatusDisplayWidget {
  final String message;
  final DateTime? lastFetchTime;
  final DateTime? lastPrimeTime;

  const ErrorStatusWidget({
    super.key,
    required this.message,
    this.lastFetchTime,
    this.lastPrimeTime,
  });

  @override
  State<ErrorStatusWidget> createState() => _ErrorStatusWidgetState();
}

class _ErrorStatusWidgetState extends State<ErrorStatusWidget> {
  Timer? _timer;
  String _timeSinceLastPrime = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _updateTimeSinceLastPrime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeSinceLastPrime();
    });
  }

  void _updateTimeSinceLastPrime() {
    if (widget.lastPrimeTime != null && mounted) {
      final duration = DateTime.now().difference(widget.lastPrimeTime!);
      setState(() {
        _timeSinceLastPrime = _formatDuration(duration);
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red.shade400,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          'Error',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red.shade300,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (widget.lastPrimeTime != null && _timeSinceLastPrime.isNotEmpty)
          Text(
            'Last prime: $_timeSinceLastPrime ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          )
        else
          Text(
            'No primes found yet',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        const SizedBox(height: 8),
        Text(
          'Auto-fetching every 10 seconds',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Initial status widget
class InitialStatusWidget extends StatusDisplayWidget {
  const InitialStatusWidget({super.key});

  @override
  State<InitialStatusWidget> createState() => _InitialStatusWidgetState();
}

class _InitialStatusWidgetState extends State<InitialStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.timer_outlined,
          color: Colors.grey.shade400,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          'Starting up...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade400,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'No primes found yet',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Auto-fetching every 10 seconds',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
