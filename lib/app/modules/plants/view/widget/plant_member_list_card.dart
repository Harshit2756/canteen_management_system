import 'package:flutter/material.dart';

import '../../../../data/models/network/plants/plants_model.dart';

class PlantMemberListCard extends StatelessWidget {
  final Member member;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PlantMemberListCard({
    super.key,
    required this.member,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.user?.name ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('User Id: ${member.userId}'),
            ],
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
