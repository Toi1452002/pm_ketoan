import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

IconButton IconAdd({required void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(icon: Icon(PhosphorIcons.filePlus()), onPressed: onPressed, enabled: enabled);
}

IconButton IconDelete({required void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(
    icon: Icon(PhosphorIcons.trash(), color: Colors.red),
    onPressed: onPressed,
    enabled: enabled,
  );
}

IconButton IconPrinter({required void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(
    icon: Icon(PhosphorIcons.printer(PhosphorIconsStyle.fill), color: Colors.blue.shade800),
    onPressed: onPressed,
    enabled: enabled,
  );
}

IconButton IconExcel({required void Function()? onPressed, bool enabled = true}) {
  return IconButton.outline(
    icon: Icon(PhosphorIcons.microsoftExcelLogo(PhosphorIconsStyle.fill), color: Colors.green.shade700),
    onPressed: onPressed,
    enabled: enabled,
  );
}

IconButton IconFilter({required void Function()? onPressed, bool enabled = true, bool isFilter = false}) {
  return IconButton.outline(
    icon: Icon(PhosphorIcons.funnel(isFilter ? PhosphorIconsStyle.fill : PhosphorIconsStyle.regular), color:isFilter ?Colors.yellow.shade600: Colors.gray),
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