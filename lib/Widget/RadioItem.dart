import 'package:flutter/material.dart';
import 'package:flutter_localization_app/model/LanguageModel.dart';

class RadioItem extends StatelessWidget {
  final LanguageModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 4.0, right: 4.0),
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Container(
                  width: 60.0,
                  height: 4.0,
                  decoration: new BoxDecoration(
                    color: _item.isSelected
                        ? Colors.redAccent
                        : Colors.transparent,
                    border: new Border.all(
                        width: 1.0,
                        color: _item.isSelected
                            ? Colors.redAccent
                            : Colors.transparent),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(2.0)),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.only(top: 8.0),
                  child: new Text(
                    _item.desc,
                    style: TextStyle(
                      color:
                          _item.isSelected ? Colors.redAccent : Colors.black54,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
