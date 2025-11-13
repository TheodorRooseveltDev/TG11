import 'package:flutter/material.dart';
import 'color_tokens.dart';

/// Complete Bingo Theme Definition
/// Includes colors, effects, and theme-specific settings
class BingoTheme {
  final String id;
  final String name;
  final String description;
  final ColorTokens colors;
  final ThemeEffects effects;
  final int unlockCost;
  final bool isUnlockedByDefault;
  final String? backgroundImage; // Path to background image asset
  final String? navbarImage; // Path to navbar background image

  const BingoTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.colors,
    required this.effects,
    this.unlockCost = 0,
    this.isUnlockedByDefault = false,
    this.backgroundImage,
    this.navbarImage,
  });
}

/// Theme-specific Visual Effects
class ThemeEffects {
  final bool hasParticles;
  final bool hasScanlines;
  final bool hasGlow;
  final bool hasGridFloor;
  final String particleType; // 'stars', 'balls', 'rain', 'leaves', 'none'

  const ThemeEffects({
    this.hasParticles = false,
    this.hasScanlines = false,
    this.hasGlow = false,
    this.hasGridFloor = false,
    this.particleType = 'none',
  });
}

/// All Available Themes
class BingoThemes {
  BingoThemes._(); // Private constructor

  // 1. Modern Vibrant (Default Theme)
  static const modernVibrant = BingoTheme(
    id: 'modern_vibrant',
    name: 'Modern Vibrant',
    description: 'Sleek and energetic design with bold colors',
    isUnlockedByDefault: true,
    backgroundImage: 'assets/images/bg_modern_vibrant.png',
    navbarImage: 'assets/images/navbar_modern_vibrant.png',
    colors: ColorTokens(
      id: 'modern_vibrant',
      name: 'Modern Vibrant',
      // 60% - Primary (Deep Navy)
      primary: Color(0xFF0A0E27),
      primaryLight: Color(0xFF151B3D),
      primaryDark: Color(0xFF050714),
      // 30% - Secondary (Dark Purple)
      secondary: Color(0xFF1F1F3D),
      secondaryLight: Color(0xFF2D2D52),
      secondaryDark: Color(0xFF151528),
      // 10% - Accent (Electric Pink)
      accent: Color(0xFFFF3D71),
      accentLight: Color(0xFFFF6B94),
      accentDark: Color(0xFFE6003D),
      // Semantic
      success: Color(0xFF00D68F),
      warning: Color(0xFFFFAA00),
      error: Color(0xFFFF3D71),
      info: Color(0xFF0095FF),
      // Neutral
      background: Color(0xFF0F0F1E),
      surface: Color(0xFF1A1A2E),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onAccent: Color(0xFFFFFFFF),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      // Text - Ensure high contrast
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFB8B8D1),
      textDisabled: Color(0xFF6B6B8A),
      // Border
      border: Color(0xFF3D3D5C),
      divider: Color(0xFF2D2D4A),
    ),
    effects: ThemeEffects(
      hasParticles: true,
      hasGlow: true,
      particleType: 'balls',
    ),
  );

  // 2. 80's Retro Theme
  static const retro80s = BingoTheme(
    id: 'retro_80s',
    name: "80's Retro",
    description: 'Neon synthwave vibes from the golden age',
    unlockCost: 500,
    backgroundImage: 'assets/images/bg_retro_80s.png',
    navbarImage: 'assets/images/navbar_retro_80s.png',
    colors: ColorTokens(
      id: 'retro_80s',
      name: "80's Retro",
      // 60% - Deep Purple-Black
      primary: Color(0xFF1A0B2E),
      primaryLight: Color(0xFF2E1A47),
      primaryDark: Color(0xFF0D0517),
      // 30% - Dark Purple (changed from hot pink for better contrast)
      secondary: Color(0xFF2D1842),
      secondaryLight: Color(0xFF3D2452),
      secondaryDark: Color(0xFF1D0F2E),
      // 10% - Cyan
      accent: Color(0xFF00F0FF),
      accentLight: Color(0xFF33F3FF),
      accentDark: Color(0xFF00D4E6),
      // Semantic
      success: Color(0xFF39FF14),
      warning: Color(0xFFFFAA00),
      error: Color(0xFFFF006E),
      info: Color(0xFF00F0FF),
      // Neutral
      background: Color(0xFF0D0517),
      surface: Color(0xFF1A0B2E),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onAccent: Color(0xFF000000),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      // Text
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFB8B8D1),
      textDisabled: Color(0xFF6B6B8A),
      // Border - Use cyan for that neon look
      border: Color(0xFF00F0FF),
      divider: Color(0x4400F0FF),
    ),
    effects: ThemeEffects(
      hasParticles: true,
      hasScanlines: true,
      hasGlow: true,
      hasGridFloor: true,
      particleType: 'stars',
    ),
  );

  // 3. 90's Nostalgia Theme
  static const nostalgia90s = BingoTheme(
    id: 'nostalgia_90s',
    name: "90's Nostalgia",
    description: 'Radical colors and wild patterns',
    unlockCost: 500,
    backgroundImage: 'assets/images/bg_nostalgia_90s.png',
    navbarImage: 'assets/images/navbar_nostalgia_90s.png',
    colors: ColorTokens(
      id: 'nostalgia_90s',
      name: "90's Nostalgia",
      // 60% - Dark Purple Base (changed from bright yellow)
      primary: Color(0xFF1A0B2E),
      primaryLight: Color(0xFF2E1A47),
      primaryDark: Color(0xFF0D0517),
      // 30% - Magenta
      secondary: Color(0xFF3D1A52),
      secondaryLight: Color(0xFF4F2366),
      secondaryDark: Color(0xFF2B1038),
      // 10% - Cyan (accent)
      accent: Color(0xFF00FFFF),
      accentLight: Color(0xFF33FFFF),
      accentDark: Color(0xFF00E6E6),
      // Semantic
      success: Color(0xFF00FF41),
      warning: Color(0xFFFF6B35),
      error: Color(0xFFFF00FF),
      info: Color(0xFF00FFFF),
      // Neutral
      background: Color(0xFF0D0517),
      surface: Color(0xFF1A0B2E),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onAccent: Color(0xFF000000),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      // Text - High contrast white on dark
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFB8B8D1),
      textDisabled: Color(0xFF6B6B8A),
      // Border - Use accent colors
      border: Color(0xFF00FFFF),
      divider: Color(0x4400FFFF),
    ),
    effects: ThemeEffects(
      hasParticles: true,
      hasGlow: true,
      hasScanlines: true,
      particleType: 'stars',
    ),
  );

  // 4. Space Opera Theme
  static const spaceOpera = BingoTheme(
    id: 'space_opera',
    name: 'Space Opera',
    description: 'Journey through the galaxy far, far away',
    unlockCost: 2000,
    backgroundImage: 'assets/images/bg_space_opera.png',
    navbarImage: 'assets/images/navbar_space_opera.png',
    colors: ColorTokens(
      id: 'space_opera',
      name: 'Space Opera',
      // 60% - Deep Space Black-Blue
      primary: Color(0xFF0A0E27),
      primaryLight: Color(0xFF1A1F3A),
      primaryDark: Color(0xFF050711),
      // 30% - Deep Blue
      secondary: Color(0xFF1A2332),
      secondaryLight: Color(0xFF2D3A52),
      secondaryDark: Color(0xFF0F1622),
      // 10% - Lightsaber Blue
      accent: Color(0xFF3B82F6),
      accentLight: Color(0xFF60A5FA),
      accentDark: Color(0xFF2563EB),
      // Semantic
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      info: Color(0xFF3B82F6),
      // Neutral
      background: Color(0xFF0A0E27),
      surface: Color(0xFF1A2332),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onAccent: Color(0xFFFFFFFF),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      // Text
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFB8B8D1),
      textDisabled: Color(0xFF6B6B8A),
      // Border
      border: Color(0xFF3D5080),
      divider: Color(0xFF2D3E66),
    ),
    effects: ThemeEffects(
      hasParticles: true,
      hasGlow: true,
      particleType: 'stars',
    ),
  );

  // 5. Minimalist Modern Theme
  static const minimalist = BingoTheme(
    id: 'minimalist',
    name: 'Minimalist Modern',
    description: 'Clean, simple, and elegant',
    isUnlockedByDefault: true,
    backgroundImage: 'assets/images/bg_minimalist.png',
    navbarImage: 'assets/images/navbar_minimalist.png',
    colors: ColorTokens(
      id: 'minimalist',
      name: 'Minimalist Modern',
      // 60% - Off-White
      primary: Color(0xFFFAFAFA),
      primaryLight: Color(0xFFFFFFFF),
      primaryDark: Color(0xFFF5F5F5),
      // 30% - Light Gray
      secondary: Color(0xFFE0E0E0),
      secondaryLight: Color(0xFFEEEEEE),
      secondaryDark: Color(0xFFD6D6D6),
      // 10% - Vibrant Blue
      accent: Color(0xFF2563EB),
      accentLight: Color(0xFF3B82F6),
      accentDark: Color(0xFF1D4ED8),
      // Semantic
      success: Color(0xFF059669),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFDC2626),
      info: Color(0xFF2563EB),
      // Neutral
      background: Color(0xFFFAFAFA),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF1F2937),
      onSecondary: Color(0xFF1F2937),
      onAccent: Color(0xFFFFFFFF),
      onBackground: Color(0xFF1F2937),
      onSurface: Color(0xFF1F2937),
      // Text
      textPrimary: Color(0xFF1F2937),
      textSecondary: Color(0xFF6B7280),
      textDisabled: Color(0xFF9CA3AF),
      // Border
      border: Color(0xFFD1D5DB),
      divider: Color(0xFFE5E7EB),
    ),
    effects: ThemeEffects(),
  );

  // 6. Cyberpunk Theme
  static const cyberpunk = BingoTheme(
    id: 'cyberpunk',
    name: 'Cyberpunk',
    description: 'Dark futuristic with neon accents',
    unlockCost: 5000,
    backgroundImage: 'assets/images/bg_cyberpunk.png',
    navbarImage: 'assets/images/navbar_cyberpunk.png',
    colors: ColorTokens(
      id: 'cyberpunk',
      name: 'Cyberpunk',
      // 60% - Deep Black-Purple
      primary: Color(0xFF0D0221),
      primaryLight: Color(0xFF1A0B3F),
      primaryDark: Color(0xFF000000),
      // 30% - Dark Purple
      secondary: Color(0xFF1A0F2E),
      secondaryLight: Color(0xFF2D1A47),
      secondaryDark: Color(0xFF0D0517),
      // 10% - Hot Pink
      accent: Color(0xFFFF10F0),
      accentLight: Color(0xFFFF5CF7),
      accentDark: Color(0xFFE600D9),
      // Semantic
      success: Color(0xFF00FFF0),
      warning: Color(0xFFFFAA00),
      error: Color(0xFFFF006E),
      info: Color(0xFF00FFF0),
      // Neutral
      background: Color(0xFF0D0221),
      surface: Color(0xFF1A0F2E),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onAccent: Color(0xFFFFFFFF),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      // Text
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFB8B8D1),
      textDisabled: Color(0xFF6B6B8A),
      // Border
      border: Color(0xFF6600FF),
      divider: Color(0x446600FF),
    ),
    effects: ThemeEffects(
      hasParticles: true,
      hasScanlines: true,
      hasGlow: true,
      particleType: 'rain',
    ),
  );

  // 7. Nature/Zen Theme
  static const natureZen = BingoTheme(
    id: 'nature_zen',
    name: 'Nature Zen',
    description: 'Peaceful and organic aesthetics',
    unlockCost: 1000,
    backgroundImage: 'assets/images/bg_nature_zen.png',
    navbarImage: 'assets/images/navbar_nature_zen.png',
    colors: ColorTokens(
      id: 'nature_zen',
      name: 'Nature Zen',
      // 60% - Soft Off-White
      primary: Color(0xFFF0F4F0),
      primaryLight: Color(0xFFF8FBF8),
      primaryDark: Color(0xFFE8EFE8),
      // 30% - Sage Green
      secondary: Color(0xFFB8D4B8),
      secondaryLight: Color(0xFFCAE1CA),
      secondaryDark: Color(0xFFA3C9A3),
      // 10% - Forest Green
      accent: Color(0xFF4A7C59),
      accentLight: Color(0xFF5A8F6B),
      accentDark: Color(0xFF3A6347),
      // Semantic
      success: Color(0xFF6B8E23),
      warning: Color(0xFFD4A574),
      error: Color(0xFFB85C5C),
      info: Color(0xFF4A90A4),
      // Neutral
      background: Color(0xFFF0F4F0),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF2C3E2C),
      onSecondary: Color(0xFF2C3E2C),
      onAccent: Color(0xFFFFFFFF),
      onBackground: Color(0xFF2C3E2C),
      onSurface: Color(0xFF2C3E2C),
      // Text
      textPrimary: Color(0xFF2C3E2C),
      textSecondary: Color(0xFF5A6B5A),
      textDisabled: Color(0xFF9CAA9C),
      // Border
      border: Color(0xFFB8D4B8),
      divider: Color(0xFFD9E8D9),
    ),
    effects: ThemeEffects(
      hasParticles: true,
      particleType: 'leaves',
    ),
  );

  /// Get all available themes as a list
  static List<BingoTheme> get allThemes => [
        modernVibrant,
        minimalist,
        retro80s,
        nostalgia90s,
        natureZen,
        spaceOpera,
        cyberpunk,
      ];

  /// Get unlocked themes by default
  static List<BingoTheme> get defaultUnlockedThemes =>
      allThemes.where((theme) => theme.isUnlockedByDefault).toList();
}
