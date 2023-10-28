import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/widget/DrawerSellerDashboard.dart';

Color currentColor = Color(0xff443a49);

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

var _value;
final List list_items = [1, 2, 3];

class _AddNewProductState extends State<AddNewProduct> {
  var val = 'New';

  @override
  Widget build(BuildContext context) {
    TextEditingController one = new TextEditingController();
    TextEditingController two = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Products',
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        backgroundColor: Color(0xFFAED0F3),
      ),
      drawer: SellerDashboardDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ProdcutInputFields(
                labelDate: 'Product Name',
                pdController: one,
              ),
              ProdcutInputFields(
                labelDate: 'Product Sku',
                pdController: two,
              ),
              DropDownData(
                select: 'Category',
              ),
              DropDownData(
                select: 'Sub Category',
              ),
              DropDownData(
                select: 'Child Category',
              ),
              CheckBoxes(
                Inptext: 'Product Condition',
                btm: '',
                function: DropDownData(
                  select: 'Product Condition',
                ),
              ),
              CheckBoxes(
                Inptext: 'Allow Estimated Shipping Time',
                btm: '',
                function: Text(
                  'Check Later',
                ),
              ),
              imageColorField(context),
            ],
          ),
        ),
      ),
    );
  }
}

class ProdcutInputFields extends StatefulWidget {
  ProdcutInputFields(
      {Key? key,
      required this.pdController,
      this.inputKey,
      required this.labelDate})
      : super(key: key);
  final TextEditingController pdController;
  var inputKey;

  // final String hintsText;
  final String labelDate;

  @override
  _ProdcutInputFieldsState createState() => _ProdcutInputFieldsState();
}

class _ProdcutInputFieldsState extends State<ProdcutInputFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.01),
      child: TextFormField(
        keyboardType: widget.inputKey,
        controller: widget.pdController,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        // onSaved: (String value) {
        //   mobileno = value;
        //   mobile = mobileno;
        //   print('Mobile no:$mobile');
        // },
        autofocus: false,
        decoration: InputDecoration(
          // prefixIcon: Icon(
          //   Icons.call_outlined,
          // ),
          // hintText: wi,
          labelText: widget.labelDate,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
      ),
    );
  }
}

class DropDownData extends StatefulWidget {
  DropDownData({Key? key, required this.select}) : super(key: key);
  final String select;

  @override
  _DropDownDataState createState() => _DropDownDataState();
}

class _DropDownDataState extends State<DropDownData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.01),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(6.0)),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: DropdownButton(
              value: _value,
              items: [
                DropdownMenuItem(
                  child: Text('Used Product'),
                  value: 'Used',
                ),
                DropdownMenuItem(
                  child: Text('New Product'),
                  value: 'New',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
              hint: Text(widget.select),
              disabledHint: Text("Disabled"),
              elevation: 4,
              // style: TextStyle(color: Colors.green, fontSize: 16),
              icon: Icon(Icons.arrow_drop_down_circle),
              // iconDisabledColor: Colors.red,
              // iconEnabledColor: Colors.green,
              isExpanded: true,
            ),
          ),
        ),
      ),
    );
  }
}

class CheckBoxes extends StatefulWidget {
  const CheckBoxes(
      {Key? key,
      required this.Inptext,
      required this.function,
      required this.btm})
      : super(key: key);
  final String Inptext;
  final Widget function;
  final String btm;

  @override
  _CheckBoxesState createState() => _CheckBoxesState();
}

class _CheckBoxesState extends State<CheckBoxes> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text(widget.Inptext),
              value: _value,
              onChanged: (bool? value) {
                setState(
                  () {
                    _value = value!;
                  },
                );
              },
            ),
            _value
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.btm),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.function,
                          // child:
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

var count = 1.obs;
var pickerColor = [Color(0xff000000)].obs;

imageColorField(BuildContext context) {
  return Card(
    child: ExpansionTile(
      title: Text('Add Image and Colors'),
      children: [
        SingleChildScrollView(
          child: Obx(
            () {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return imageCard(context);
                },
                itemCount: count.toInt(),
              );
            },
          ),
        ),
        belowButton(),
      ],
    ),
  );
}

imageCard(BuildContext context) {
  return Card(
    shape: StadiumBorder(),
    borderOnForeground: true,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.image),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt),
                ),
              ],
            ),
          ],
        ),
        IconButton(onPressed: () {
          throw 'Check Later';
          // return showDialog(
          //   context: context,
          //   builder: (context) => Obx(
          //     () {
          //       return AlertDialog(
          //           title: Text('Select a Color'),
          //           content: MaterialPicker(
          //             pickerColor: pickerColor[count.value - 1],
          //             onColorChanged: (color) {
          //               pickerColor.add(color);
          //             },
          //             // showLabel: true, // only on portrait mode
          //           ),
          //           actions: [
          //             TextButton(
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //                 child: Text('Select the Color'))
          //           ]);
          //     },
          //   ),
          // );
        }, icon: Obx(() {
          return Icon(
            Icons.colorize,
            color: pickerColor.length < count.value - 1 ? pickerColor[0] : null,
          );
        }))
      ],
    ),
  );
}

belowButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton(
          onPressed: () {
            count++;
            pickerColor.add(Color(0xff000000));
          },
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
          ),
          child: Text('Add More Images')),
      ElevatedButton(
          onPressed: () {
            count > 1 ? count-- : print('Value Limit');
            pickerColor.length > 0
                ? pickerColor.removeLast()
                : print('Limit Error');
            print(pickerColor);
          },
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
          ),
          child: Text('Remove Images')),
    ],
  );
}

class showDialogueColor extends StatefulWidget {
  const showDialogueColor({Key? key}) : super(key: key);

  @override
  _showDialogueColorState createState() => _showDialogueColorState();
}

class _showDialogueColorState extends State<showDialogueColor> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// getImage() async{
//   File image = await ImagePicker.pickImage(source: ImageSource.camera);
// }
