// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class PolicyAssistant extends StatelessWidget {
  const PolicyAssistant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Chat List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    Gap(8.w),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onError,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: const Text(
                          "Hi Omar, I'm your HR Policy Assistant. Ask me about leave policies, benefits, or your current balances.",
                        ),
                      ),
                    ),
                  ],
                ),

                Gap(12.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.73.w,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      "How many annual leave days can I carry over to next year?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),

                Gap(12.h),
              ],
            ),
          ),

          Container(
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ActionChip(
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  label: const Text("What's my sick leave balance?"),
                  onPressed: () {},
                ),

                Gap(8.w),
              ],
            ),
          ),

          Gap(8.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: Theme.of(context).colorScheme.onError,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Ask about a policy or balance...",
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Gap(8.w),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
