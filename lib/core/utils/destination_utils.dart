class DestinationUtils {

  static Set<String> getAliases(String query) {
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return {};

    final aliases = <String>{lower};

    if (lower.contains('bangalore') || lower.contains('bengaluru')) {
      aliases.addAll(['bangalore', 'bengaluru', 'bangaluru']);
    }
    if (lower.contains('cochin') || lower.contains('kochi')) {
      aliases.addAll(['cochin', 'kochi', 'ernakulam']);
    }
    if (lower.contains('coorg') || lower.contains('madikeri') || lower.contains('kodagu')) {
      aliases.addAll(['coorg', 'madikeri', 'kodagu']);
    }
    if (lower.contains('calicut') || lower.contains('kozhikode')) {
      aliases.addAll(['calicut', 'kozhikode']);
    }
    if (lower.contains('trivandrum') || lower.contains('thiruvananthapuram')) {
      aliases.addAll(['trivandrum', 'thiruvananthapuram']);
    }
    if (lower.contains('alleppey') || lower.contains('alappuzha')) {
      aliases.addAll(['alleppey', 'alappuzha']);
    }
    if (lower.contains('pondicherry') || lower.contains('puducherry')) {
      aliases.addAll(['pondicherry', 'puducherry']);
    }
    if (lower.contains('mysore') || lower.contains('mysuru')) {
      aliases.addAll(['mysore', 'mysuru']);
    }
    if (lower.contains('mangalore') || lower.contains('mangaluru')) {
      aliases.addAll(['mangalore', 'mangaluru']);
    }
    if (lower.contains('chikmagalur') || lower.contains('chikkamagaluru')) {
      aliases.addAll(['chikmagalur', 'chikkamagaluru']);
    }
    if (lower.contains('madras') || lower.contains('chennai')) {
      aliases.addAll(['madras', 'chennai']);
    }
    if (lower.contains('ooty') || lower.contains('udhagamandalam')) {
      aliases.addAll(['ooty', 'udhagamandalam', 'ootacamund']);
    }
    if (lower.contains('kodaikanal') || lower.contains('kodai')) {
      aliases.addAll(['kodaikanal', 'kodai']);
    }

    return aliases;
  }

  static bool matchesDestination({
    required String hotelDestination,
    required String hotelCity,
    required String hotelState,
    required String targetDestination,
  }) {
    final target = targetDestination.trim().toLowerCase();
    if (target.isEmpty || target == 'all') {
      return true;
    }

    final aliases = getAliases(target);
    final hDest = hotelDestination.toLowerCase().trim();
    final hCity = hotelCity.toLowerCase().trim();
    final hState = hotelState.toLowerCase().trim();

    return aliases.any((alias) =>
        hDest.contains(alias) ||
        hCity.contains(alias) ||
        hState.contains(alias) ||
        alias.contains(hDest) ||
        alias.contains(hCity) ||
        alias.contains(hState));
  }
}
