class Report {
  final String title;
  final String date;
  final String content;

  const Report({
    required this.title,
    required this.date,
    required this.content,
  });

  Report copyWith({
    String? title,
    String? date,
    String? content,
  }) {
    return Report(
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
    );
  }

  static List<Report> samples() {
    const lorem =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ante ipsum primis in faucibus orci luctus '
        'et ultrices posuere cubilia curae. Suspendisse potenti. Integer at nulla nec lacus tincidunt imperdiet.';

    return const [
      Report(title: 'Setting AP', date: '13/09/2025', content: lorem),
      Report(title: 'UI/UX Design', date: '12/09/2025', content: lorem),
      Report(title: 'Riset Pengguna', date: '11/09/2025', content: lorem),
    ];
  }
}


