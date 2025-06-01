import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


import 'counter_cubit.dart';
import 'counter_display.dart';


class CounterButton extends StatefulWidget {
  const CounterButton({super.key});

  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {

  @override
  Widget build(BuildContext context) {

    final counterCubit = context.read<CounterCubit>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, int>(builder: (context, count){
              return Text("Counter: $count");

            }),
            
            ElevatedButton(onPressed: (){
              counterCubit.increment();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: counterCubit,
                    child: const CounterDisplay(),
                  ),
                ),
              );
            }
                , child: Text("Increase")),
          ],
        ),
      ),
    );
  }
}
