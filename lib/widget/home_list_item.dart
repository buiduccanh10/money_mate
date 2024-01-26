import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class home_list_item extends StatelessWidget {
  const home_list_item({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 25, bottom: 100),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
              closeOnScroll: true,
              endActionPane:
                  const ActionPane(motion: BehindMotion(), children: [
                SlidableAction(
                  onPressed: _handleEdit,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: _handleDelete,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ]),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        child: const CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 28,
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Column(
                        children: [
                          Text(
                            'Double coffee',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                '15 July',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      const Column(
                        children: [
                          Text(
                            '-3',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.red),
                          ),
                          Text(
                            'Food',
                            style: TextStyle(
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
          }),
    );
  }
}

void _handleEdit(BuildContext context) {
  // Implement your edit logic here
}
void _handleDelete(BuildContext context) {
  // Implement your edit logic here
}
