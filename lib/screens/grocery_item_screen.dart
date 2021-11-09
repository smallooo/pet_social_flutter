import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_social_flutter/models/grocery_item.dart';
import 'package:pet_social_flutter/models/petsocial_pages.dart';
import 'package:pet_social_flutter/utils/ToastUtils.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GroceryItemScreen extends StatefulWidget {
  final Function(GroceryItem) onCreate;
  final Function(GroceryItem, int) onUpdate;
  final GroceryItem? originalItem;
  final int index;
  final bool isUpdating;

  static MaterialPage page({
    GroceryItem? item,
    int index = -1,
    required Function(GroceryItem) onCreate,
    required Function(GroceryItem, int) onUpdate,
  }) {
    return MaterialPage(
      name: PetSocialPages.groceryItemDetails,
      key: ValueKey(PetSocialPages.groceryItemDetails),
      child: GroceryItemScreen(
        originalItem: item,
        index: index,
        onCreate: onCreate,
        onUpdate: onUpdate,
      ),
    );
  }

  const GroceryItemScreen({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
    this.index = -1,
  })  : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _GroceryItemScreenState createState() => _GroceryItemScreenState();
}

class _GroceryItemScreenState extends State<GroceryItemScreen> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }
  dynamic _pickImageError;

  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;
  bool isVideo = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if(_nameController.text.isNotEmpty && _imageFileList!= null && _imageFileList!.isNotEmpty){
                ToastUtils.toast('Upload post');
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              }else{
                ToastUtils.toast('Please enter a post content and add images');
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              }
            },
          )
        ],
        elevation: 0.0,
        title: Text('Posting',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildNameField(),
            buildImageField(),
            buildTimeField(context),
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
            hintText: 'Post a interesting moment for your pet...',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSubImageField()
      ],
    );
  }


  Widget buildSubImageField() {
    if (_imageFileList == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: 'image_picker_example_picked_image',
            child: Image.asset('assets/petsocial_assets/recommend.png'),
          )
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: 'image_picker_example_picked_image',
            child: Image.file(File(_imageFileList![0].path)),
          )
        ],
      );
    }
  }



  Widget buildTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chose pet photo',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                try {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {_imageFile = pickedFile;});
                } catch (e) {
                  setState(() {_pickImageError = e;});
                }
              },
            ),
          ],
        ),
        Text('${_timeOfDay.format(context)}'),
      ],
    );
  }


  @override
  void initState() {
    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _nameController.text = originalItem.name;
      _currentSliderValue = originalItem.quantity;
      _importance = originalItem.importance;
      _currentColor = originalItem.color;
      final date = originalItem.date;
      _timeOfDay = TimeOfDay(
        hour: date.hour,
        minute: date.minute,
      );
      _dueDate = date;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

