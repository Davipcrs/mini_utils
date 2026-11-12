/// Shared responsive breakpoints, measured in logical pixels.
///
/// Configure once before runApp, for example:
/// `ResponsiveLayout(mobileBreakpoint: 480, desktopBreakpoint: 1200)`.
/// Retrieve the same instance anywhere with `ResponsiveLayout.instance` or
/// `ResponsiveLayout()`. Calling the constructor without values preserves the
/// current configuration. Configuration changes do not trigger widget rebuilds.
class ResponsiveLayout {
  ResponsiveLayout._();

  /// Returns the singleton, updating only explicitly supplied breakpoints.
  ///
  /// Values must be finite and satisfy 0 < mobile < desktop. Invalid values
  /// throw ArgumentError without changing the current configuration.
  factory ResponsiveLayout({
    double? mobileBreakpoint,
    double? desktopBreakpoint,
  }) {
    final mobile = mobileBreakpoint ?? instance.mobileBreakpoint;
    final desktop = desktopBreakpoint ?? instance.desktopBreakpoint;
    _validateBreakpoints(mobile, desktop);
    instance._mobileBreakpoint = mobile;
    instance._desktopBreakpoint = desktop;
    return instance;
  }

  /// The shared instance, initially configured with 600 and 1024.
  static final ResponsiveLayout instance = ResponsiveLayout._();

  double _mobileBreakpoint = 600;
  double _desktopBreakpoint = 1024;

  /// Width below which evaluate returns 1 (mobile). Defaults to 600.
  double get mobileBreakpoint => _mobileBreakpoint;

  /// Width at which evaluate returns 3 (desktop). Defaults to 1024.
  double get desktopBreakpoint => _desktopBreakpoint;

  /// Returns 1 for mobile, 2 for medium/tablet, or 3 for large/desktop.
  ///
  /// Pass a finite, nonnegative width from LayoutBuilder or MediaQuery.
  /// Optional overrides apply only to this evaluation, without changing the
  /// singleton. Invalid widths or breakpoints throw ArgumentError.
  int evaluate(
    double width, {
    double? mobileBreakpoint,
    double? desktopBreakpoint,
  }) {
    if (!width.isFinite || width < 0) {
      throw ArgumentError.value(
          width, 'width', 'Must be finite and nonnegative');
    }
    final mobile = mobileBreakpoint ?? _mobileBreakpoint;
    final desktop = desktopBreakpoint ?? _desktopBreakpoint;
    _validateBreakpoints(mobile, desktop);
    if (width < mobile) return 1;
    if (width < desktop) return 2;
    return 3;
  }

  static void _validateBreakpoints(double mobile, double desktop) {
    if (!mobile.isFinite ||
        !desktop.isFinite ||
        mobile <= 0 ||
        mobile >= desktop) {
      throw ArgumentError(
          'Breakpoints must be finite and satisfy 0 < mobile < desktop');
    }
  }
}

/// Classifies a width using the shared ResponsiveLayout configuration.
///
/// Optional breakpoints override the shared defaults for this call only.
int responsiveLayout(
  double width, {
  double? mobileBreakpoint,
  double? desktopBreakpoint,
}) =>
    ResponsiveLayout.instance.evaluate(
      width,
      mobileBreakpoint: mobileBreakpoint,
      desktopBreakpoint: desktopBreakpoint,
    );
