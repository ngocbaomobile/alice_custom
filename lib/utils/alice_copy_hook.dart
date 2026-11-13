/// Global hook run with the selected text whenever the user taps Copy in the
/// call details screen. Global (not per-widget) because the selectable rows
/// are built deep inside widgets that have no handle on the Alice instance.
class AliceCopyHook {
  AliceCopyHook._();

  static void Function(String text)? onCopied;
}
