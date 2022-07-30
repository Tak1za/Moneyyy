import 'package:flutter/material.dart';

import '../models/time_period_enum.dart';

class TimeSelector extends StatelessWidget {
  const TimeSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext ctx, int index) {
            return TextButton(
              onPressed: () {},
              child: Text(
                TimePeriod.values[index].name,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
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
