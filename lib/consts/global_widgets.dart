import 'package:flutter/material.dart';

class SquareGradientButton extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final double height;

  const SquareGradientButton({super.key, required this.onPress, required this.text, required this.colors, required this.height});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {onPress(context);},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

class SquareGradientButtonSizeable extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final Size size;

  const SquareGradientButtonSizeable({super.key, required this.onPress, required this.text, required this.colors, required this.size});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {onPress(context);},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

abstract class AbstractDropDownSelector<T> extends StatefulWidget {
  final Size size;
  final Color color;
  final Color textColor;
  final Function(T?) onSelect;
  final List<T> options;
  final T? initalSelect;
  const AbstractDropDownSelector({super.key, required this.onSelect, required this.options, required this.initalSelect, required this.size, required this.color, required this.textColor});
}
  
abstract class AbstractDropDownSelectorState<T> extends State<AbstractDropDownSelector<T>> {
  late T? selected = widget.initalSelect;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: widget.color
      ), 
      child: Container(
        width: widget.size.width,
        height: widget.size.height,   
        alignment: Alignment.center,
        child :DropdownButton<T>(
          value: selected,
          alignment: Alignment.centerRight,
          onChanged: (T? newValue) {
            setState(() {
              selected = newValue;
              widget.onSelect(newValue);
            });
            
          },
          items: widget.options.map((T option) {
            return DropdownMenuItem<T>(
              value: option,
              child: Row(
                children: [
                  Text(
                    optionToString(option),
                    style: TextStyle(
                      fontSize: 20,
                      color: widget.textColor
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
      )
    );
  }

  String optionToString(T option);

}

abstract class IInteractableList<T> {
  onPress(T element, BuildContext context);
  onLongPress(T element, BuildContext context);
}

class ConfirmationDialog<T> extends StatelessWidget {
  final T? value;
  const ConfirmationDialog({super.key, required this.displayText, required this.onConfirmCallback, required this.value});
  final Function(T?,BuildContext) onConfirmCallback;
  final String displayText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        height: 200,
        width: 300,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.blue,Colors.blue.shade400],text: "Confirm",onPress: _onConfirm),
                  const SizedBox(width: 20),
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.red,Colors.red.shade400],text: "Cancel",onPress: _popBack),
                ],
              )
            ) 
          ],
        ),
        
      )
    );
  }
  void _onConfirm(BuildContext context) {
    _popBack(context);
    onConfirmCallback(value,context);
    
  }
  void _popBack(BuildContext context) {
    Navigator.pop(context);
  }
}