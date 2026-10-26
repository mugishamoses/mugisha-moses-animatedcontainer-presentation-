/// One step in a parcel's journey, e.g. "Picked up" or "Out for delivery".
class DeliveryStep {
  const DeliveryStep({
    required this.label,
    required this.time,
    required this.done,
  });

  final String label;
  final String time;
  final bool done;
}

/// A parcel the customer is waiting for.
class Parcel {
  const Parcel({
    required this.trackingId,
    required this.title,
    required this.status,
    required this.eta,
    required this.courier,
    required this.steps,
  });

  final String trackingId;
  final String title;
  final String status;
  final String eta;
  final String courier;
  final List<DeliveryStep> steps;
}

/// Sample data so the demo works offline in class.
const List<Parcel> sampleParcels = [
  Parcel(
    trackingId: 'KGL-20481',
    title: 'Wireless headphones',
    status: 'Out for delivery',
    eta: 'Arrives today, 14:30',
    courier: 'Jean – Moto rider',
    steps: [
      DeliveryStep(label: 'Order placed', time: 'Mon 09:12', done: true),
      DeliveryStep(label: 'Packed at warehouse', time: 'Mon 16:40', done: true),
      DeliveryStep(label: 'Out for delivery', time: 'Today 11:05', done: true),
      DeliveryStep(label: 'Delivered', time: 'Pending', done: false),
    ],
  ),
  Parcel(
    trackingId: 'KGL-20517',
    title: 'Phone case',
    status: 'In transit',
    eta: 'Arrives Thursday',
    courier: 'Kigali Hub',
    steps: [
      DeliveryStep(label: 'Order placed', time: 'Tue 18:20', done: true),
      DeliveryStep(label: 'Packed at warehouse', time: 'Wed 08:02', done: true),
      DeliveryStep(label: 'Out for delivery', time: 'Pending', done: false),
      DeliveryStep(label: 'Delivered', time: 'Pending', done: false),
    ],
  ),
];
