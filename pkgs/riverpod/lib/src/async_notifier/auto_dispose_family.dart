part of '../async_notifier.dart';

/// {@macro riverpod.async_notifier_provider}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class AutoDisposeFamilyAsyncNotifier<State, Arg>
    extends BuildlessAutoDisposeAsyncNotifier<State> {
  /// {@template riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    super._setElement(element);
    arg = element.origin.argument as Arg;
  }

  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

/// {@macro riverpod.async_notifier_provider}
///
/// {@macro riverpod.async_notifier_provider_modifier}
typedef AutoDisposeFamilyAsyncNotifierProvider<
        NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>
    = AutoDisposeFamilyAsyncNotifierProviderImpl<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeAsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AsyncNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeAsyncNotifierProvider] and
/// [AsyncNotifierProvider] at the same time.
@internal
class AutoDisposeFamilyAsyncNotifierProviderImpl<
    NotifierT extends AsyncNotifierBase<T>,
    T,
    Arg> extends AsyncNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.async_notifier_family_provider}
  AutoDisposeFamilyAsyncNotifierProviderImpl(
    NotifierT Function() _createNotifier, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    @Deprecated('Will be removed in 3.0.0') Family<Object?>? from,
    @Deprecated('Will be removed in 3.0.0') Object? argument,
    @Deprecated('Will be removed in 3.0.0') String Function()? debugGetCreateSourceHash,
  }) : super(
    _createNotifier,
    name: name,
    dependencies: dependencies,
    from: from,
    argument: argument,
    debugGetCreateSourceHash: debugGetCreateSourceHash,
    allTransitiveDependencies: computeAllTransitiveDependencies(dependencies),
  );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeFamilyAsyncNotifierProviderImpl.internal(
    NotifierT Function() _createNotifier, {
    required String? name,
    required Iterable<ProviderOrFamily>? dependencies,
    required Iterable<ProviderOrFamily>? allTransitiveDependencies,
    required String Function()? debugGetCreateSourceHash,
    Family<Object?>? from,
    Object? argument,
  }) : super(_createNotifier, name: name, dependencies: dependencies, allTransitiveDependencies: allTransitiveDependencies, debugGetCreateSourceHash: debugGetCreateSourceHash, from: from, argument: argument);


  @override
  late final Refreshable<NotifierT> notifier =
      _asyncNotifier<NotifierT, T>(this);

  @override
  late final Refreshable<Future<T>> future = _asyncFuture<T>(this);

  @override
  AutoDisposeAsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeAsyncNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> runNotifierBuild(
    covariant AutoDisposeFamilyAsyncNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [AsyncNotifierProvider].
class AutoDisposeAsyncNotifierProviderFamily<
        NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>
    extends AutoDisposeNotifierFamilyBase<
        AutoDisposeAsyncNotifierProviderRef<T>,
        AsyncValue<T>,
        Arg,
        NotifierT,
        AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AutoDisposeAsyncNotifierProvider].
  AutoDisposeAsyncNotifierProviderFamily(
    NotifierT Function()_createFn, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) : super(
    _createFn,
    name: name,
    dependencies: dependencies,
    providerFactory: AutoDisposeFamilyAsyncNotifierProvider.internal,
    allTransitiveDependencies: computeAllTransitiveDependencies(dependencies),
    debugGetCreateSourceHash: null,
  );

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<AsyncValue<T>, Arg,
        AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>>(
      this,
      (arg) =>
          AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>.internal(
        create,
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
