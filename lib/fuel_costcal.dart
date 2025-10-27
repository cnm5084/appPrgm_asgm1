// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Fuelcostcal extends StatefulWidget {
  const Fuelcostcal({super.key});

  @override
  State<Fuelcostcal> createState() => _FuelCostCalState();
}

class _FuelCostCalState extends State<Fuelcostcal> {
  //textcontroller
  TextEditingController distancecontroller = TextEditingController();
  TextEditingController efficiencycontroller = TextEditingController();
  String fuelType = 'RON95';
  double result = 0;
  final _formKey = GlobalKey<FormState>();
  String selectedLocation = 'Penisular Malaysia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fuel cost calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(207, 255, 218, 108),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(83, 0, 0, 0)),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(255, 244, 247, 198),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(100, 76, 150, 224),
                  blurRadius: 7,
                  offset: Offset(2, 6),
                ),
              ],
            ),
            height: 535,
            width: 430,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculation done here',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      SizedBox(width: 8),
                      SizedBox(width: 135, child: Text('Distance')),
                      SizedBox(
                        width: 150,
                        height: 60,
                        child: TextFormField(
                          controller: distancecontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Distance travel',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(fontSize: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Distance can\'t be empty';
                            } // check empty input
                            double? numD = double.tryParse(value);
                            if (numD == null) {
                              return 'Please enter number';
                            } //check non-numeric input
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('km'),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 8),
                      SizedBox(width: 135, child: Text('Car fuel efficiency')),
                      SizedBox(
                        width: 150,
                        height: 60,
                        child: TextFormField(
                          controller: efficiencycontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter fuel efficiency',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(fontSize: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Efficiency can\'t be empty';
                            } // check empty input
                            double? numE = double.tryParse(value);
                            if (numE == null) {
                              return 'Please enter number';
                            } //check non-numeric input
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('km/Liter'),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 8),
                      SizedBox(width: 135, child: Text('Type of fuel')),
                      DropdownButton<String>(
                        value: fuelType,
                        items: <String>['RON95', 'RON97', 'Diesel'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          fuelType = newValue!;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Visibility(
                    visible: isVisible(),
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true, // must use with maintainState
                    // maintain layout
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        SizedBox(width: 135, child: Text('Location')),
                        DropdownButton<String>(
                          value: selectedLocation,
                          items: <String>['Penisular Malaysia', 'East Malaysia']
                              .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                          onChanged: (String? newValue) {
                            selectedLocation = newValue!;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ), // visibility: make location become invisible if diesel is not selected
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Successful !'),
                                duration: Duration(seconds: 3),
                              ), // snackBar: show the message at the bottom
                            );
                          }
                          calculateFuelCost();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255,253,222,128,),
                        ),
                        child: Text('Calculate Price'),
                      ),
                      SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: resetAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255,253,222,128,),
                        ),
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration:BoxDecoration(
                          color: Color.fromARGB(155, 160, 179, 249),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)
                        ),
                        child: Text(
                          'Estimated fuel cost: RM${result.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), // container that display total fuel cost calculated
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void calculateFuelCost() {
    double? distance = double.tryParse(distancecontroller.text);
    double? efficiency = double.tryParse(efficiencycontroller.text);

    if (distance != null && efficiency != null) {
      if (fuelType == 'RON95') {
        result = (distance / efficiency) * 2.60;
      } else if (fuelType == 'RON97') {
        result = (distance / efficiency) * 3.14;
      } else if (fuelType == 'Diesel') {
        selectedLocation == 'Penisular Malaysia'
            ? result = (distance / efficiency) * 2.89
            : result = (distance / efficiency) * 2.15;
      }
    } //only calculate when distance and car fuel efficiency not equal to null
    setState(() {});
  } // carry out calculation

  void resetAll() {
    _formKey.currentState!.reset();
    distancecontroller.text = '';
    efficiencycontroller.text = '';
    setState(() {
      fuelType = 'RON95';
      selectedLocation = 'Penisular Malaysia';
      result = 0.0;
    });
  } // return default layout

  bool isVisible() {
    if (fuelType == 'Diesel') {
      return true;
    }
    return false;
  } // control visibility by checking whether 'Diesel' is selected
}
