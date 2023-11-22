import 'package:calendar/calendarhelper.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  final int? startyear;
  final DateTime? startdate;
  final int? endyear;

  final Color dayColor;
  final Color currentdayColor;
  final Color selecteddayColor;
  final Color daynameColor;
  final Color backgroundColor;

  const Calendar({
    this.startyear,
    this.endyear,
    this.startdate,
    this.dayColor = const Color(0xFFF8F9FA),
    this.currentdayColor = const Color(0xFFFFC300),
    this.selecteddayColor = const Color(0xFFFFD60A),
    this.daynameColor = const Color(0xFF003566),
    this.backgroundColor = const Color(0xFFE9ECEF),
    Key? key,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final CalendarDayData currentDay = widget.startdate != null
      ? CalendarDayData(
          widget.startdate!.year,
          widget.startdate!.month,
          widget.startdate!.day,
        )
      : CalendarDayData(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );

  CalendarDayData? selectedDay;

  late int currentmonth = currentDay.month;
  late int currentyear = currentDay.year;

  bool swipedlastupdate = false;

  void ondayclick(CalendarDayData daydate) {
    selectedDay = daydate;
    setState(() {});
  }

  void onleftnav() {
    currentmonth--;

    if (currentmonth <= 0) {
      currentmonth = 12;
      currentyear--;
    }

    if (widget.startyear == null) {
      if (currentyear < currentDay.year - 1) {
        currentyear = currentDay.year - 1;
        currentmonth = 1;
      }
    } else if (currentyear < widget.startyear!) {
      currentyear = widget.startyear!;
      currentmonth = 1;
    }

    setState(() {});
  }

  void onrightnav() {
    currentmonth++;
    if (currentmonth > 12) {
      currentmonth = 1;
      currentyear++;
    }

    if (widget.endyear == null) {
      if (currentyear > currentDay.year + 1) {
        currentyear = currentDay.year + 1;
        currentmonth = 12;
      }
    } else if (currentyear > widget.endyear!) {
      currentyear = widget.endyear!;
      currentmonth = 12;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var monthdays = CalendarHelper.getDayRows(currentyear, currentmonth);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (details) {
        const int sensitivity = 5;

        if (details.delta.dx > sensitivity) {
          if (!swipedlastupdate) {
            onleftnav();
            swipedlastupdate = true;
          }
        }
        if (details.delta.dx < -sensitivity) {
          if (!swipedlastupdate) {
            onrightnav();
            swipedlastupdate = true;
          }
        }
      },
      onPanEnd: (details) {
        swipedlastupdate = false;
      },
      child: Container(
        color: widget.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: widget.daynameColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalendarNavArrow(
                    const Icon(
                      Icons.keyboard_arrow_left,
                      size: 26,
                      color: Colors.white,
                    ),
                    onclick: onleftnav,
                  ),
                  CalendarNavTitle(
                    "${CalendarHelper.months[currentmonth - 1]} $currentyear",
                  ),
                  CalendarNavArrow(
                    const Icon(
                      Icons.keyboard_arrow_right,
                      size: 26,
                      color: Colors.white,
                    ),
                    onclick: onrightnav,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var dayname in CalendarHelper.daysshort)
                  CalendarWeekDay(dayname, widget.daynameColor)
              ],
            ),
            for (var row in monthdays)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var day in row)
                      if (selectedDay != null && day.equals(selectedDay!))
                        CalendarSelectedDay(day, widget.selecteddayColor)
                      else if (day.equals(currentDay))
                        CalendarCurrentDay(
                          day,
                          widget.currentdayColor,
                          onclick: ondayclick,
                        )
                      else
                        CalendarDay(
                          day,
                          widget.dayColor,
                          onclick: ondayclick,
                        )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CalendarNavArrow extends StatelessWidget {
  final Icon icon;
  final void Function()? onclick;

  const CalendarNavArrow(this.icon, {this.onclick, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (onclick != null) {
          onclick!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: icon,
      ),
    );
  }
}

class CalendarNavTitle extends StatelessWidget {
  final String title;

  const CalendarNavTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CalendarWeekDay extends StatelessWidget {
  final String name;
  final Color color;
  const CalendarWeekDay(this.name, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarDay extends StatelessWidget {
  final CalendarDayData daydata;
  final Color color;
  final void Function(CalendarDayData)? onclick;

  const CalendarDay(this.daydata, this.color, {this.onclick, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          if (onclick != null) onclick!(daydata);
        },
        child: Container(
          margin: const EdgeInsets.all(0.5),
          color: color,
          child: Padding(
            padding: const EdgeInsets.only(right: 9, top: 6),
            child: Text(
              daydata.day.toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarCurrentDay extends StatelessWidget {
  final CalendarDayData daydata;
  final Color color;
  final void Function(CalendarDayData)? onclick;

  const CalendarCurrentDay(this.daydata, this.color, {this.onclick, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onHorizontalDragStart: (detail) {
          if (onclick != null) onclick!(daydata);
        },
        onTapDown: (detail) {
          if (onclick != null) onclick!(daydata);
        },
        child: Container(
          margin: const EdgeInsets.all(0.5),
          color: color,
          child: Padding(
            padding: const EdgeInsets.only(right: 9, top: 6),
            child: Text(
              daydata.day.toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarSelectedDay extends StatelessWidget {
  final CalendarDayData daydata;
  final Color color;
  const CalendarSelectedDay(this.daydata, this.color, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(0.5),
        color: color,
        child: Padding(
          padding: const EdgeInsets.only(right: 9, top: 6),
          child: Text(
            daydata.day.toString(),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}
