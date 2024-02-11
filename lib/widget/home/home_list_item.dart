import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:shimmer/shimmer.dart';

class home_list_item extends StatefulWidget {
  const home_list_item({super.key});

  @override
  State<home_list_item> createState() => _home_list_itemState();
}

class _home_list_itemState extends State<home_list_item> {
  firestore_helper db_helper = firestore_helper();
  List<Map<String, dynamic>> input_data = [];
  bool is_loading = true;
  bool is_mounted = false;

  @override
  void initState() {
    is_mounted = true;
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> temp = await db_helper.fetch_input();

    if (is_mounted) {
      setState(() {
        input_data = temp;
        is_loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: is_loading
            ? ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 100),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 24, right: 24),
                      child: ListTile(
                        title: Container(
                          height: 20,
                          color: Colors.white,
                        ),
                        subtitle: Container(
                          height: 15,
                          color: Colors.white,
                        ),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        trailing: Container(
                          width: 60,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              )
            : input_data.isEmpty
                ? const Center(
                    child: Text('No input data yet!'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 100),
                    itemCount: input_data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> input_item = input_data[index];

                      return Slidable(
                        closeOnScroll: true,
                        endActionPane:
                            const ActionPane(motion: BehindMotion(), children: [
                          SlidableAction(
                            onPressed: _handleEdit,
                            foregroundColor: Colors.blue,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: _handleDelete,
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ]),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 18, bottom: 18.0, left: 24, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(-5, 5),
                                    )
                                  ], borderRadius: BorderRadius.circular(50)),
                                  child: CircleAvatar(
                                      backgroundColor: Colors
                                          .primaries[Random()
                                              .nextInt(Colors.primaries.length)]
                                          .shade100
                                          .withOpacity(0.35),
                                      radius: 28,
                                      child: Text(
                                        input_item['icon'],
                                        style: const TextStyle(fontSize: 38),
                                      )),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      input_item['description'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          input_item['date'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${input_item['is_income'] ? '+' : '-'} ${input_item['money']} đ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: input_item['is_income']
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    Text(
                                      input_item['name'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
  }
}

void _handleEdit(BuildContext context) {
  // Implement your edit logic here
}
void _handleDelete(BuildContext context) {
  // Implement your edit logic here
}
