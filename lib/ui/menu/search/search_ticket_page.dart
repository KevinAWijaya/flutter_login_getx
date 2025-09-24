import 'package:flutter/material.dart';
import 'package:flutter_login_getx/ui/menu/search/search_ticket_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/color.dart';
import '../../../data/models/ticket.dart';
import 'search_bar.dart';

class SearchTicketPage extends GetView<SearchTicketController> {
  const SearchTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColor.white,
      body: Column(children: [_header(), _ticketList()]),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: VColor.primary,
      child: CustomSearchBar(
        onChanged: (value) {
          controller.filterTicket(value);
        },
      ),
    );
  }

  Widget _ticketList() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Found: ${controller.filteredTickets.length}",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 18, color: VColor.primary),
              ),
              const SizedBox(height: 5),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredTickets.length,
                itemBuilder: (context, index) {
                  return _ticketItem(controller.filteredTickets[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketItem(Ticket ticket) {
    final totalDebt = (ticket.grandTotal ?? 0) - (ticket.payment ?? 0);
    final createdTime = ticket.created != null ? DateFormat("HH:mm").format(DateTime.parse(ticket.created!)) : "--:--";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: const BoxDecoration(color: VColor.backgroundCard),
      child: Row(
        children: [
          // Time
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: VColor.primary, shape: BoxShape.circle),
            child: ticket.paid != null
                ? const Icon(Icons.check, color: VColor.white)
                : Text(
                    createdTime,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
          ),
          const SizedBox(width: 12),

          // Ticket Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${ticket.barcode}",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16, color: VColor.primary),
                ),
                Text(
                  "${ticket.customerName ?? 'Unknown'}"
                  "${ticket.tableDineInName != null ? ' · ${ticket.tableDineInName}' : ''}",
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: VColor.primary),
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${(ticket.grandTotal ?? 0).toStringAsFixed(2)}",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 20, color: VColor.primary),
              ),
              if (ticket.payment != ticket.grandTotal)
                Text(
                  "(\$${(totalDebt).toStringAsFixed(2)})",
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: VColor.primary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
