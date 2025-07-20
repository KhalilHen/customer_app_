import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/menu_controller.dart';
import 'package:hf_customer_app/models/menu_item_option_group.dart';
import 'package:hf_customer_app/models/menu_item_options.dart';

class CustomMenuOptionsWidget extends StatefulWidget {
  final MenuItemOptionGroup item;
  // final MenuItemOptions item;

  const CustomMenuOptionsWidget({super.key, required this.item});
  @override
  CustomMenuOptionsWidgetState createState() => CustomMenuOptionsWidgetState();
}

class CustomMenuOptionsWidgetState extends State<CustomMenuOptionsWidget> {
  final menuController = MenuItemController();
  final bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: menuController.fetchMenuOptions(widget.item.id),
      builder: (context, snapshot) {
        {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();

            case ConnectionState.done:

             if (snapshot.hasData && snapshot.data != null) {
    if (snapshot.data!.isEmpty) {
      return const Text("No options available");
    } 


             }


              if (snapshot.hasData || snapshot.data!.isEmpty) {
                final menuOptionGroups = snapshot.data!
                    .where((menuOptions) => menuOptions.isActive)
                    .toList();

                // ** This goes to the custom widget which completly controls how the group options look
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: menuOptionGroups
                      .map((menuOptions) => buildMenuOptions(menuOptions))
                      .toList(),
                );


                
              }

              

            case ConnectionState.none:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ConnectionState.active:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
          return const Text(
            "Der ging iets mis met het ophalen van de opties contact support a.u.b",
          );
        }
      },
    );
  }

  Widget buildMenuOptions( MenuItemOptions menuOptions) {
return FilterChip(
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            menuOptions.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // if (menuOptions.priceModifier >=  0.00) ...[
        if (menuOptions.priceModifier >= Decimal.parse('0.00')) ...[
 
          const SizedBox(width: 8),
          Text(
            '+€${menuOptions.priceModifier}',
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    ),
    backgroundColor: Colors.grey[50],
    selectedColor: Colors.deepOrange.withAlpha(2),
    checkmarkColor: Colors.deepOrange,
    side: BorderSide(color: Colors.grey[300]!, width: 1),
    selected: false, // Manage with your state
    onSelected: (selected) {
    },
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

    elevation: isSelected ? 2 : 0,
    shadowColor: Colors.deepOrange.withAlpha(2),
  );

  }
}
