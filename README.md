--الحاجات اللي غيرتها عشان تاخدو بالكم و محدش يتلغبط--
**الاتزااااااااااام بالاستراكشررررررررررررر
auth/
│
├── data/
│   ├── datasources/
│   │   
│   │
│   ├── models/
│   │   
│   │
│   └── repositories/
│       
│
├── domain/
│   ├── entities/
│   │   
│   │
│   ├── repositories/
│   │   
│   │
│   └── usecases/
│       
│
└── presentation/
    ├── cubit/
    │  
    │
    ├── screens/
    │   
    │
    └── widgets/
        
--كله يغير اسماء الفولدرااااااااااات--
**
** [text](lib/core/services/service_locator.dart)
** [حذقت الفايل ده ملوش لازمه](lib/core/localization/locale_provider.dart)
**[كتبت كونتات عربي بالحاجات اللي اتغيرت](lib/core/design_system/theme/app_theme.dart)
**[كتبت كونتات عربي بالحاجات اللي اتغيرت](lib/core/design_system/typography/app_text_styles.dart)
**[كتبت كونتات عربي بالحاجات اللي اتغيرت](lib/core/design_system/widgets/buttons/app_button.dart)
**[text](lib/core/localization/localization_extension.dart) => استخدم الاكستنشن دي :
١- بدل     final localization = AppLocalizations.of(context);
احذفها خالص

 child: Text(
    localization.or,)
    و هنا استخدم context.l10.اسم الترجمه





-- Zeyad
* استخدم الcore

*[text](lib/core/localization/localization_extension.dart) => استخدم الاكستنشن دي :
١- بدل     final localization = AppLocalizations.of(context);
احذفها خالص

 child: Text(
    localization.or,)
    و هنا استخدم context.l10.اسم الترجمه
*لون اللوجين
* عندك ايرور فاللوجين بيظهر اول ما بضغط الزرار
* انتفال الفينجر برينت عشان يظهر الناف بار
*ظبط الفورجيت باسوورد



--Ahmed
*[حذفت fontsize , استخدم apptextstyle](lib/features/profile/widgets/job_detail_item.dart)
*شيل النوتيفير من الmain و خلي الui -static data
* استخدم الcore يعني تشوف المتشابه و تبدل باللي في الكور





--Abo_Khalil
