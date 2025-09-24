import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/color.dart';
import '../../../../core/constants/size.dart';
import '../../../../core/constants/space.dart';
import '../../../../data/models/service.dart';
import '../../../../data/models/ticket.dart';
import '../../../widgets/text.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  final List<Ticket> tickets;

  const ServiceCard({super.key, required this.service, required this.tickets});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tickets = widget.tickets;
    final visibleTickets = _expanded ? tickets : tickets.take(2).toList();
    final remainingCount = tickets.length - 2;

    return Container(
      padding: const EdgeInsets.all(marginMedium),
      decoration: const BoxDecoration(color: VColor.surfaceContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.service.name ?? "No Service",
                    style: const TextStyle(fontSize: textSizeLarge, fontWeight: FontWeight.w700, color: VColor.primary),
                  ),
                  spaceHorizontalSuperSmall,
                  Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: VColor.primary, size: textSizeLarge),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VText(
                    "Sales: ${tickets.length} · \$${tickets.fold<double>(0, (sum, t) => sum + (t.grandTotal ?? 0))}",
                    fontSize: textSizeSmall,
                    color: VColor.primary,
                  ),
                  const Text(
                    "+ New Sales",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          spaceVerticalSmall,

          // Tickets
          Container(
            decoration: BoxDecoration(color: VColor.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
            child: tickets.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: marginMedium, horizontal: marginSmall),
                    decoration: const BoxDecoration(color: VColor.surfaceContainerHigh, borderRadius: borderRadiusMedium),
                    child: const VText("No Record Found", fontSize: textSizeLarge, isBold: true, color: VColor.primary, align: TextAlign.center),
                  )
                : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _ticketItem(visibleTickets[index]),
                        separatorBuilder: (context, index) => Divider(color: Colors.grey.shade400, thickness: 1),
                        itemCount: visibleTickets.length,
                      ),

                      // See more / Hide button
                      if (tickets.length > 2)
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _expanded = !_expanded;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: VColor.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 2, offset: const Offset(0, 3))],
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: VColor.primary),
                                    const SizedBox(width: 2),
                                    Text(
                                      _expanded ? "Minimize" : "See $remainingCount others",
                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 18, color: VColor.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _ticketItem(Ticket ticket) {
    final totalDebt = (ticket.grandTotal ?? 0) - (ticket.payment ?? 0);
    final createdTime = ticket.created != null ? DateFormat("HH:mm").format(DateTime.parse(ticket.created!)) : "--:--";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(color: VColor.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Time
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: VColor.primary, shape: BoxShape.circle),
            child: ticket.paid != null
                ? const Icon(Icons.check, color: VColor.onPrimary)
                : Text(
                    createdTime,
                    style: const TextStyle(color: VColor.onPrimary, fontSize: 13, fontWeight: FontWeight.w600),
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
