// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitas_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$visitasNotifierHash() => r'60ca99a3b3dfaacbcb1654b294ebe1a94d2eac76';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$VisitasNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Visita>> {
  late final int clienteID;

  FutureOr<List<Visita>> build(
    int clienteID,
  );
}

/// See also [VisitasNotifier].
@ProviderFor(VisitasNotifier)
const visitasNotifierProvider = VisitasNotifierFamily();

/// See also [VisitasNotifier].
class VisitasNotifierFamily extends Family<AsyncValue<List<Visita>>> {
  /// See also [VisitasNotifier].
  const VisitasNotifierFamily();

  /// See also [VisitasNotifier].
  VisitasNotifierProvider call(
    int clienteID,
  ) {
    return VisitasNotifierProvider(
      clienteID,
    );
  }

  @override
  VisitasNotifierProvider getProviderOverride(
    covariant VisitasNotifierProvider provider,
  ) {
    return call(
      provider.clienteID,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'visitasNotifierProvider';
}

/// See also [VisitasNotifier].
class VisitasNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    VisitasNotifier, List<Visita>> {
  /// See also [VisitasNotifier].
  VisitasNotifierProvider(
    int clienteID,
  ) : this._internal(
          () => VisitasNotifier()..clienteID = clienteID,
          from: visitasNotifierProvider,
          name: r'visitasNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitasNotifierHash,
          dependencies: VisitasNotifierFamily._dependencies,
          allTransitiveDependencies:
              VisitasNotifierFamily._allTransitiveDependencies,
          clienteID: clienteID,
        );

  VisitasNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clienteID,
  }) : super.internal();

  final int clienteID;

  @override
  FutureOr<List<Visita>> runNotifierBuild(
    covariant VisitasNotifier notifier,
  ) {
    return notifier.build(
      clienteID,
    );
  }

  @override
  Override overrideWith(VisitasNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VisitasNotifierProvider._internal(
        () => create()..clienteID = clienteID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clienteID: clienteID,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VisitasNotifier, List<Visita>>
      createElement() {
    return _VisitasNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitasNotifierProvider && other.clienteID == clienteID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clienteID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VisitasNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Visita>> {
  /// The parameter `clienteID` of this provider.
  int get clienteID;
}

class _VisitasNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VisitasNotifier,
        List<Visita>> with VisitasNotifierRef {
  _VisitasNotifierProviderElement(super.provider);

  @override
  int get clienteID => (origin as VisitasNotifierProvider).clienteID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
