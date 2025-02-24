import 'package:canteen_app/core/utils/constants/extension/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../interfaces/dropdown_data_provider.dart';
import '../../utils/media/icons_strings.dart';
import '../../utils/media/text_strings.dart';
import '../../utils/theme/colors.dart';
import 'base_dropdown.dart';
import '../../../app/data/models/local/member_id_model.dart';

class MemberDropdown extends StatelessWidget {
  final MemberDataProvider controller;

  const MemberDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BaseDropdown<int>(
          value: controller.selectedMemberId.isNotEmpty ? int.tryParse(controller.selectedMemberId.value) : null,
          labelText: HTexts.manager,
          hintText: HTexts.selectManager,
          prefixIcon: const Icon(HIcons.manager),
          suffix: InkWell(
            onTap: () => controller.getMemberList(isFromApi: true),
            child: const Icon(HIcons.refresh),
          ),
          dropdownColor: HColors.white,
          validator: (value) => value.toString().validateNotEmpty(HTexts.manager),
          items: controller.membersList.isEmpty ? [_buildEmptyItem(context, HTexts.noManagersFound)] : _buildMemberItems(controller.membersList),
          onChanged: (value) => controller.selectedMemberId.value = value?.toString() ?? '',
        ));
  }

  DropdownMenuItem<int> _buildEmptyItem(BuildContext context, String text) {
    return DropdownMenuItem(
      value: null,
      child: Center(
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildMemberItems(List<Map<String, dynamic>> members) {
    return members.map((memberMap) {
      final member = memberMap.values.first as MemberIdModel;
      return DropdownMenuItem<int>(
        value: int.tryParse(member.id),
        child: Text(member.name),
      );
    }).toList();
  }
}
