import 'package:flutter/material.dart';

/// A video project shown in "Recent projects" on the home screen.
class Project {
  const Project({
    required this.title,
    required this.duration,
    required this.editedAgo,
    required this.gradient,
  });

  final String title;
  final String duration;
  final String editedAgo;

  /// Stands in for a video thumbnail, so the demo needs no image assets.
  final List<Color> gradient;
}

const List<Project> recentProjects = [
  Project(
    title: 'Beach day',
    duration: '0:42',
    editedAgo: 'Edited 2h ago',
    gradient: [Color(0xFFFF8A5B), Color(0xFF7B2FF7)],
  ),
  Project(
    title: 'Campus vlog',
    duration: '1:15',
    editedAgo: 'Edited yesterday',
    gradient: [Color(0xFF34C3A0), Color(0xFF1B4E8C)],
  ),
  Project(
    title: 'Kigali nights',
    duration: '0:28',
    editedAgo: 'Edited Mon',
    gradient: [Color(0xFFFFC75F), Color(0xFFD7263D)],
  ),
];
