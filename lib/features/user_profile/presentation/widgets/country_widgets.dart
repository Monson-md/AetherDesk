import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/country.dart';

/// Label presentation for [Country], kept in `presentation/` since the
/// domain entity itself must stay free of Flutter/l10n imports.
extension CountryPresentation on Country {
  String label(AppLocalizations l10n) => switch (this) {
    Country.none => l10n.userProfileCountryNone,
    Country.france => l10n.userProfileCountryFrance,
    Country.belgium => l10n.userProfileCountryBelgium,
    Country.switzerland => l10n.userProfileCountrySwitzerland,
    Country.canada => l10n.userProfileCountryCanada,
    Country.unitedStates => l10n.userProfileCountryUnitedStates,
    Country.unitedKingdom => l10n.userProfileCountryUnitedKingdom,
    Country.germany => l10n.userProfileCountryGermany,
    Country.spain => l10n.userProfileCountrySpain,
    Country.italy => l10n.userProfileCountryItaly,
    Country.morocco => l10n.userProfileCountryMorocco,
    Country.algeria => l10n.userProfileCountryAlgeria,
    Country.tunisia => l10n.userProfileCountryTunisia,
    Country.senegal => l10n.userProfileCountrySenegal,
    Country.ivoryCoast => l10n.userProfileCountryIvoryCoast,
    Country.other => l10n.userProfileCountryOther,
  };
}
