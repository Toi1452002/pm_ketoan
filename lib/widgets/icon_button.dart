import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

IconButton iconAdd({void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(icon: Icon(PhosphorIcons.filePlus()), onPressed: onPressed, enabled: enabled);
}

IconButton iconDelete({void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(
    icon: Icon(PhosphorIcons.trash(), color: Colors.red),
    onPressed: onPressed,
    enabled: enabled,
  );
}

IconButton iconPrinter({void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(
    icon: Icon(PhosphorIcons.printer(PhosphorIconsStyle.fill), color: Colors.blue),
    onPressed: onPressed,
    enabled: enabled,
  );
}

IconButton iconExcel({required void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(
    icon: Icon(PhosphorIcons.microsoftExcelLogo(PhosphorIconsStyle.fill), color: Colors.green),
    onPressed: onPressed,
    enabled: enabled,
  );
}

IconButton iconFirst({void Function()? onPressed, bool enabled = true}) {
  return IconButton.secondary(
    icon: Icon(PhosphorIcons.rewind()),
    onPressed: onPressed,
    enabled: enabled,
    size: ButtonSize(.7),
  );
}

IconButton iconLast({void Function()? onPressed, bool enabled = true}) {
  return IconButton.secondary(
    icon: Icon(PhosphorIcons.fastForward()),
    onPressed: onPressed,
    enabled: enabled,
    size: ButtonSize(.7),
  );
}

IconButton iconBack({void Function()? onPressed, bool enabled = true}) {
  return IconButton.secondary(
    icon: Icon(PhosphorIcons.skipBack()),
    onPressed: onPressed,
    enabled: enabled,
    size: ButtonSize(.7),

  );
}
IconButton iconNext({void Function()? onPressed, bool enabled = true}) {
  return IconButton.secondary(
    icon: Icon(PhosphorIcons.skipForward()),
    onPressed: onPressed,
    enabled: enabled,
    size: ButtonSize(.7),

  );
}