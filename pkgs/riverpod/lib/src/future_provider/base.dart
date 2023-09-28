part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [state], the value currently exposed by this provider.
abstract class FutureProviderRef<State> implements Ref<AsyncValue<State>> {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  ///
  /// Will return [AsyncLoading] if used during the first initialization.
  /// Subsequent initializations will contain an [AsyncValue] with the previous
  /// state and [AsyncValueX.isRefreshing]/[AsyncValueX.isReloading] set accordingly.
  AsyncValue<State> get state;
  set state(AsyncValue<State> newState);

  /// Obtains the [Future] associated to this provider.
  ///
  /// This is equivalent to doing `ref.read(myProvider.future)`.
  /// See also [FutureProvider.future].
  Future<State> get future;
}

/// {@macro riverpod.futureprovider}
class FutureProvider<T> extends _FutureProviderBase<T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.futureprovider}
  FutureProvider(
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
  FutureProvider.internal(
    this._createFn, {
    required String? name,
    required Iterable<ProviderOrFamily>? dependencies,
    required Iterable<ProviderOrFamily>? allTransitiveDependencies,
    required String Function()? debugGetCreateSourceHash,
    Family<Object?>? from,
    Object? argument,
  }) : super(name: name, dependencies: dependencies, allTransitiveDependencies: allTransitiveDependencies, debugGetCreateSourceHash: debugGetCreateSourceHash, from: from, argument: argument);

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeFutureProviderBuilder();

  /// {@macro riverpod.family}
  static const family = FutureProviderFamilyBuilder();

  final Create<FutureOr<T>, FutureProviderRef<T>> _createFn;

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _future(this);

  @override
  FutureOr<T> _create(FutureProviderElement<T> ref) => _createFn(ref);

  @override
  FutureProviderElement<T> createElement() => FutureProviderElement._(this);

  /// {@macro riverpod.overridewith}
  Override overrideWith(Create<FutureOr<T>, FutureProviderRef<T>> create) {
    return ProviderOverride(
      origin: this,
      override: FutureProvider.internal(
        create,
        from: from,
        argument: argument,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}

/// The element of a [FutureProvider]
class FutureProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    with FutureHandlerProviderElementMixin<T>
    implements FutureProviderRef<T> {
  FutureProviderElement._(_FutureProviderBase<T> _provider) : super(_provider);

  @override
  Future<T> get future {
    flush();
    return futureNotifier.value;
  }

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _FutureProviderBase<T>;

    handleFuture(
      () => provider._create(this),
      didChangeDependency: didChangeDependency,
    );
  }
}

/// The [Family] of a [FutureProvider]
class FutureProviderFamily<R, Arg> extends FamilyBase<FutureProviderRef<R>,
    AsyncValue<R>, Arg, FutureOr<R>, FutureProvider<R>> {
  /// The [Family] of a [FutureProvider]
  FutureProviderFamily(
    FutureOr<R> Function(FutureProviderRef<R>, Arg)_createFn, {
    String? name,
      Iterable<ProviderOrFamily>? dependencies,
  }) : super(
    _createFn,
    name: name,
    dependencies: dependencies,
    providerFactory: FutureProvider<R>.internal,
    allTransitiveDependencies: computeAllTransitiveDependencies(dependencies),
    debugGetCreateSourceHash: null,
  );

  /// Implementation detail of the code-generator.
  @internal
  FutureProviderFamily.generator(
    FutureOr<R> Function(FutureProviderRef<R>, Arg) _createFn, {
    required String? name,
    required Iterable<ProviderOrFamily>? dependencies,
    required Set<ProviderOrFamily> allTransitiveDependencies,
    required String Function()? debugGetCreateSourceHash,
  }) : super(
    _createFn,
    name: name,
    dependencies: dependencies,
    allTransitiveDependencies: allTransitiveDependencies,
    debugGetCreateSourceHash: debugGetCreateSourceHash,
    providerFactory: FutureProvider<R>.internal
  );

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    FutureOr<R> Function(FutureProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, FutureProvider<R>>(
      this,
      (arg) => FutureProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}
