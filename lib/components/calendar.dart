import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:maitungsi/model.dart';
import 'package:maitungsi/constants.dart';
import 'package:intl/intl.dart';

class CalendarWithList extends StatefulWidget {
  final Map<DateTime, List> events;

  CalendarWithList({this.events});

  @override
  _CalendarWithListState createState() => _CalendarWithListState();
}

class _CalendarWithListState extends State<CalendarWithList>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  AnimationController _animationController;
  List<DailyDetailList> _selectedEvents;
  final f = NumberFormat("#,###.0#", "en_US");
  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _events = widget.events;
    _selectedEvents = _events[_events.keys.first] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderList() {
    double totalValue = 0;
    _selectedEvents.forEach((element) {
      totalValue += element.value;
    });
    return Text(
      'Total : ' + f.format(totalValue),
      style: kMainTextStyle.copyWith(color: kSecondaryColor),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Card(
                elevation: 10.0,
                color: kPrimaryColor,
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(
                    event.itemName,
                    style: kMainTextStyle.copyWith(fontSize: 16.0),
                  ),
                  subtitle: Text(
                    event.category,
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontStyle: FontStyle.italic,
                      fontSize: 14.0,
                    ),
                  ),
                  trailing: Text(f.format(event.value), style: kMainTextStyle),
                ),
              ))
          .toList(),
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8.0),
        TableCalendar(
          headerVisible: false,
          calendarController: _calendarController,
          events: _events,
          initialSelectedDay: _events.keys.first,
          initialCalendarFormat: CalendarFormat.month,
          formatAnimation: FormatAnimation.slide,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          availableGestures: AvailableGestures.verticalSwipe,
          availableCalendarFormats: const {
            CalendarFormat.month: '',
            CalendarFormat.week: '',
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            weekdayStyle: TextStyle().copyWith(color: Colors.white),
            weekendStyle: TextStyle().copyWith(color: Colors.cyanAccent),
            holidayStyle: TextStyle().copyWith(color: Colors.cyan),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle().copyWith(color: Colors.lightBlueAccent),
            weekdayStyle: TextStyle(color: Colors.white),
          ),
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonVisible: false,
          ),
          builders: CalendarBuilders(
            selectedDayBuilder: (context, date, _) {
              return FadeTransition(
                opacity:
                    Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  color: Colors.deepOrange[300],
                  width: 100,
                  height: 100,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
                  ),
                ),
              );
            },
            todayDayBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                color: Colors.amber[400],
                width: 100,
                height: 100,
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0),
                ),
              );
            },
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];

              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  ),
                );
              }

              return children;
            },
          ),
          onDaySelected: (date, events) {
            _onDaySelected(date, events);
            _animationController.forward(from: 0.0);
          },
          onVisibleDaysChanged: _onVisibleDaysChanged,
          onCalendarCreated: _onCalendarCreated,
        ),
        SizedBox(height: 8.0),
        _buildHeaderList(),
        Divider(
          color: Colors.white,
        ),
        SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }
}
