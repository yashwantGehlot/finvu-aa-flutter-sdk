part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeStateNotifierProviderRef<
        NotifierT extends StateNotifier<T>,
        T> extends StateNotifierProviderRef<NotifierT, T>
    implements AutoDisposeRef<T> {}

/// {@macro riverpod.statenotifierprovider}
class AutoDisposeStateNotifierProvider<NotifierT extends StateNotifier<T>, T>
    extends _StateNotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(
    this._createFn, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    @Deprecated('Will be removed in 3.0.0') Family<Object?>? from,
    @Deprecated('Will be removed in 3.0.0') Object? argument,
    @Deprecated('Will be removed in 3.0.0') String Function()? debugGetCreateSourceHash,
  }) : super(
    name: name,
    dependencies: dependencies,
    from: from,
    argument: argument,
    debugGetCreateSourceHash: debugGetCreateSourceHash,
    allTransitiveDependencies: computeAllTransitiveDependencies(dependencies),
  );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeStateNotifierProvider.internal(
    this._createFn, {
    required String? name,
    required Iterable<ProviderOrFamily>? dependencies,
    required Iterable<ProviderOrFamily>? allTransitiveDependencies,
    required String Function()? debugGetCreateSourceHash,
    Family<Object?>? from,
    Object? argument,
  }) : super(name: name, dependencies: dependencies, allTransitiveDependencies: allTransitiveDependencies, debugGetCreateSourceHash: debugGetCreateSourceHash, from: from, argument: argument);


  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamily.new;

  final NotifierT Function(
    AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
  ) _createFn;

  @override
  NotifierT _create(AutoDisposeStateNotifierProviderElement<NotifierT, T> ref) {
    return _createFn(ref);
  }

  @override
  AutoDisposeStateNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeStateNotifierProviderElement._(this);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier(this);

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    Create<NotifierT, AutoDisposeStateNotifierProviderRef<NotifierT, T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
        create,
        from: from,
        argument: argument,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// The element of [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderElement<
        NotifierT extends StateNotifier<T>,
        T> extends StateNotifierProviderElement<NotifierT, T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeStateNotifierProviderRef<NotifierT, T> {
  /// The [ProviderElementBase] for [StateNotifierProvider]
  AutoDisposeStateNotifierProviderElement._(
    AutoDisposeStateNotifierProvider<NotifierT, T> _provider,
  ) : super._(_provider);
}

/// The [Family] of [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderFamily<NotifierT extends StateNotifier<T>,
        T, Arg>
    extends AutoDisposeFamilyBase<
        AutoDisposeStateNotifierProviderRef<NotifierT, T>,
        T,
        Arg,
        NotifierT,
        AutoDisposeStateNotifierProvider<NotifierT, T>> {
  /// The [Family] of [AutoDisposeStateNotifierProvider].
  AutoDisposeStateNotifierProviderFamily(
    NotifierT Function(AutoDisposeStateNotifierProviderRef<NotifierT, T>, Arg) _createFn, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) : super(
    _createFn,
    name: name,
    dependencies: dependencies,
    providerFactory: AutoDisposeStateNotifierProvider.internal,
    debugGetCreateSourceHash: null,
    allTransitiveDependencies: computeAllTransitiveDependencies(dependencies),
  );

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    NotifierT Function(
      AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
      Arg arg,
    ) create,
  ) {
    return FamilyOverrideImpl<T, Arg,
        AutoDisposeStateNotifierProvider<NotifierT, T>>(
      this,
      (arg) => AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}
