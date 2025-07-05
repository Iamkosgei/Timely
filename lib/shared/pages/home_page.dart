import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/clock/presentation/widgets/clock_widget.dart';
import '../../features/prime_number/presentation/cubits/number_cubit.dart';
import '../../features/prime_number/presentation/cubits/number_state.dart';
import '../../features/prime_number/presentation/widgets/prime_notification_bottom_sheet.dart';
import '../../injection_container.dart';
import '../widgets/status_display_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => sl<NumberCubit>(),
        child: const _HomePageContent(),
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // Clock section - main focus
              const Expanded(flex: 3, child: ClockWidget()),
              const SizedBox(height: 24),
              // Status section - minimal
              Expanded(
                flex: 1,
                child: BlocConsumer<NumberCubit, NumberState>(
                  listener: (context, state) {
                    if (state is PrimeNumberFound) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => PrimeNotificationBottomSheet(
                          primeNumber: state.numberData,
                          lastPrimeTime: state.lastPrimeTime,
                        ),
                      );
                    } else if (state is NumberError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.message}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is NumberLoading) {
                      return LoadingStatusWidget(
                        lastFetchTime: state.lastFetchTime,
                        lastPrimeTime: state.lastPrimeTime,
                      );
                    } else if (state is NumberLoaded) {
                      return NumberLoadedStatusWidget(
                        numberData: state.numberData,
                        lastFetchTime: state.lastFetchTime,
                        lastPrimeTime: state.lastPrimeTime,
                      );
                    } else if (state is PrimeNumberFound) {
                      return PrimeFoundStatusWidget(
                        numberData: state.numberData,
                        lastFetchTime: state.lastFetchTime,
                        lastPrimeTime: state.lastPrimeTime,
                      );
                    } else if (state is NumberError) {
                      return ErrorStatusWidget(
                        message: state.message,
                        lastFetchTime: state.lastFetchTime,
                        lastPrimeTime: state.lastPrimeTime,
                      );
                    } else {
                      return const InitialStatusWidget();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
