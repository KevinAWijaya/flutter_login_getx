import 'package:flutter/material.dart';

import '../../../core/color.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String)? onChanged;
  final VoidCallback? onScan;

  const CustomSearchBar({super.key, this.onChanged, this.onScan});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search box
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: VColor.surfaceContainerHigh, borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  const Icon(Icons.search, color: VColor.onSurface, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: widget.onChanged,
                      style: const TextStyle(color: VColor.onSurface),
                      cursorColor: VColor.onSurface,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: VColor.onSurface),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: VColor.onSurface),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Scan button
        GestureDetector(
          onTap: widget.onScan,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: VColor.surfaceContainerHigh, shape: BoxShape.circle),
            child: const Icon(Icons.qr_code_scanner, color: VColor.onSurface),
          ),
        ),
      ],
    );
  }
}
