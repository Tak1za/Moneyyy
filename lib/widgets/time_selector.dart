import 'package:flutter/material.dart';

import '../models/time_period_enum.dart';

class TimeSelector extends StatelessWidget {
  final TimePeriod timePeriod;
  final void Function(TimePeriod timePeriod) selectTimePeriod;

  const TimeSelector(
    this.timePeriod,
    this.selectTimePeriod, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Center(
        child: ListView.separated(
          itemBuilder: (BuildContext ctx, int index) {
            return GestureDetector(
              onTap: () {
                selectTimePeriod(TimePeriod.values[index]);
              },
              child: Container(
                decoration: timePeriod == TimePeriod.values[index]
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      )
                    : null,
                padding: const EdgeInsets.all(5),
                child: Text(
                  TimePeriod.values[index].name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(
              width: 20,
            );
          },
          itemCount: TimePeriod.values.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
