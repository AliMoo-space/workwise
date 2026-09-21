1- lib\core\design_system\widgets\feedback\app_dialog.dart 
تعديل زر confirm من appbuttom الى textbuttom  



2- lib\core\design_system\widgets\buttons\app_button.dart 
    style: (textStyle ?? AppTextStyles.titleLarge).copyWith(
                      color: style.foregroundColor?.resolve({}),
                    ),

   اضافة استايل ل text الزر                  

3- lib\core\design_system\widgets\app_bar\app_app_bar.dart
   اضافة custom widget appbar 