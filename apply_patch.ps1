param([switch]$SkipTools)

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$utf8 = New-Object System.Text.UTF8Encoding($false)
$failed = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path (Join-Path $root 'pubspec.yaml'))) {
  throw 'Run this script from the root of the Flutter project (the folder that contains pubspec.yaml).'
}

function Read-Text([string]$Path) {
  $full = Join-Path $root $Path
  if (-not (Test-Path $full)) { $failed.Add("missing file: $Path"); return $null }
  return [System.IO.File]::ReadAllText($full)
}

function Write-Text([string]$Path, [string]$Text) {
  [System.IO.File]::WriteAllText((Join-Path $root $Path), $Text, $utf8)
  Write-Host "  patched: $Path"
}

function Get-Eol([string]$Text) {
  if ($Text.Contains("`r`n")) { return "`r`n" } else { return "`n" }
}

function Patch-File {
  param([string]$Path, [string]$Find, [string]$Replace, [string]$Marker)
  $text = Read-Text $Path
  if ($null -eq $text) { return }
  if ($text.Contains($Marker)) { Write-Host "  already patched: $Path ($Marker)"; return }
  $index = $text.IndexOf($Find)
  if ($index -lt 0) { $failed.Add("anchor not found in ${Path}: $Find"); return }
  $insert = $Replace.Replace('{NL}', (Get-Eol $text))
  Write-Text $Path ($text.Substring(0, $index) + $insert + $text.Substring($index + $Find.Length))
}

function Patch-After-Regex {
  param([string]$Path, [string]$Pattern, [string]$Insert, [string]$Marker)
  $text = Read-Text $Path
  if ($null -eq $text) { return }
  if ($text.Contains($Marker)) { Write-Host "  already patched: $Path ($Marker)"; return }
  $match = [regex]::Match($text, $Pattern)
  if (-not $match.Success) { $failed.Add("pattern not found in ${Path}: $Pattern"); return }
  $insert = $Insert.Replace('{NL}', (Get-Eol $text))
  $end = $match.Index + $match.Length
  Write-Text $Path ($text.Substring(0, $end) + $insert + $text.Substring($end))
}

function Patch-Replace-Regex {
  param([string]$Path, [string]$Pattern, [string]$Replace, [string]$Marker)
  $text = Read-Text $Path
  if ($null -eq $text) { return }
  if ($text.Contains($Marker)) { Write-Host "  already patched: $Path ($Marker)"; return }
  $match = [regex]::Match($text, $Pattern)
  if (-not $match.Success) { $failed.Add("pattern not found in ${Path}: $Pattern"); return }
  $insert = $Replace.Replace('{NL}', (Get-Eol $text))
  Write-Text $Path ($text.Substring(0, $match.Index) + $insert + $text.Substring($match.Index + $match.Length))
}

Write-Host '1/4 Patching existing files...'

$libRoot = Join-Path $root 'lib'
$authFile = Get-ChildItem -Path $libRoot -Recurse -Filter 'auth_repository.dart' | Select-Object -First 1
if ($null -eq $authFile) {
  $failed.Add('auth_repository.dart not found under lib/')
} else {
  $authRel = $authFile.FullName.Substring($root.Length).TrimStart('\', '/')
  $dirRel = $authFile.DirectoryName.Substring($libRoot.Length).Trim('\', '/')
  $depth = ($dirRel -split '[\\/]').Count
  $prefix = '../' * $depth
  $importLine = "core/const/user_role.dart';{NL}import '${prefix}core/database/local_data_loader.dart';"

  Patch-File $authRel "core/const/user_role.dart';" $importLine 'local_data_loader.dart'
  Patch-File $authRel 'required AppSession session,' "required AppSession session,{NL}    required LocalDataLoader localData," 'required LocalDataLoader localData'
  Patch-File $authRel '_session = session {' "_session = session,{NL}       _localData = localData {" '_localData = localData'
  Patch-File $authRel 'final AppSession _session;' "final AppSession _session;{NL}  final LocalDataLoader _localData;" 'final LocalDataLoader _localData;'
  Patch-File $authRel 'return _session.isSignedIn;' "if (!_session.isSignedIn) return false;{NL}    await _localData.open(_session.userId);{NL}    return true;" '_localData.open(_session.userId)'
  Patch-File $authRel '_session.applyProfile(profile);' "_session.applyProfile(profile);{NL}      await _localData.open(profile.id);" '_localData.open(profile.id)'
  Patch-File $authRel '_session.signOut();' "_session.signOut();{NL}    await _localData.close();" '_localData.close()'
}

$locator = 'lib/core/di/service_locator.dart'
Patch-File $locator "import '../config/app_env.dart';" "import '../config/app_env.dart';{NL}import '../database/local_data_loader.dart';" 'local_data_loader.dart'
Patch-File $locator 'session: AppSession.instance,' "session: AppSession.instance,{NL}        localData: LocalDataLoader.instance," 'localData: LocalDataLoader.instance'

$icons = 'lib/feat/notification/data/notification_icons.dart'
Patch-File $icons 'NotificationType.accountVerified => SolarIconsBold.shieldCheck,' "NotificationType.accountVerified => SolarIconsBold.shieldCheck,{NL}      NotificationType.verificationRejected => SolarIconsBold.dangerCircle,{NL}      NotificationType.general => SolarIconsBold.infoCircle," 'NotificationType.verificationRejected'

$mainFile = 'lib/main.dart'
Patch-File $mainFile "import 'package:flutter/material.dart';" "import 'package:firebase_core/firebase_core.dart';{NL}import 'package:flutter/material.dart';" 'firebase_core.dart'
Patch-File $mainFile "import 'core/routing/app_navigator.dart';" "import 'core/notifications/lesson_reminder_scheduler.dart';{NL}import 'core/notifications/local_notification_service.dart';{NL}import 'core/routing/app_navigator.dart';" 'lesson_reminder_scheduler.dart'
Patch-File $mainFile "import 'feat/classroom/data/classroom_store.dart';" "import 'feat/classroom/data/classroom_store.dart';{NL}import 'feat/notification/ui/notification_navigator.dart';" 'notification_navigator.dart'
Patch-File $mainFile 'await getIt<AuthRepository>().restoreSession();' "await _initNotifications();{NL}  await getIt<AuthRepository>().restoreSession();" 'await _initNotifications();'
Patch-File $mainFile '_listenForSessionExpiry();' "_listenForSessionExpiry();{NL}  LessonReminderScheduler.instance.start();" 'LessonReminderScheduler.instance.start()'

$initFunction = @'
Future<void> _initNotifications() async {
  try {
    await Firebase.initializeApp();
  } on Object catch (error) {
    debugPrint('[Firebase] $error');
  }
  try {
    await LocalNotificationService.instance.init(
      onTap: (payload) {
        final context = AppNavigator.key.currentContext;
        if (context != null && payload == 'push') {
          NotificationNavigator.open(context);
        }
      },
    );
  } on Object catch (error) {
    debugPrint('[Notify] $error');
  }
}

void _listenForSessionExpiry() {
'@
Patch-File $mainFile 'void _listenForSessionExpiry() {' $initFunction 'Future<void> _initNotifications() async'

$payments = 'lib/feat/payments/ui/payments_screen.dart'
Patch-File $payments "import 'payment_actions_sheet.dart';" "import 'group_payments_screen.dart';{NL}import 'payment_actions_sheet.dart';" 'group_payments_screen.dart'
Patch-Replace-Regex $payments 'void _openGroup\(String groupId\) \{[\s\S]*?\r?\n  \}' "void _openGroup(String groupId) {{NL}    GroupPaymentsScreen.open(context, groupId, _month);{NL}  }" 'GroupPaymentsScreen.open'

$settingsGradle = 'android/settings.gradle.kts'
Patch-After-Regex $settingsGradle 'id\("org\.jetbrains\.kotlin\.android"\)[^\r\n]*' "{NL}    id(`"com.google.gms.google-services`") version `"4.4.2`" apply false" 'com.google.gms.google-services'

$appGradle = 'android/app/build.gradle.kts'
Patch-File $appGradle 'id("kotlin-android")' "id(`"kotlin-android`"){NL}    id(`"com.google.gms.google-services`")" 'com.google.gms.google-services'
Patch-File $appGradle 'compileOptions {' "compileOptions {{NL}        isCoreLibraryDesugaringEnabled = true" 'isCoreLibraryDesugaringEnabled'
Patch-File $appGradle 'flutter {' "dependencies {{NL}    coreLibraryDesugaring(`"com.android.tools:desugar_jdk_libs:2.1.4`"){NL}}{NL}{NL}flutter {" 'coreLibraryDesugaring'

$manifest = 'android/app/src/main/AndroidManifest.xml'
$permissions = @'
<uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
'@
Patch-File $manifest '<uses-permission android:name="android.permission.INTERNET"/>' $permissions 'POST_NOTIFICATIONS'

$receivers = @'
<meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="darsak_alerts_v1" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_stat_notification" />

        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
            android:exported="false" />
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver"
            android:exported="false" />

    </application>
'@
Patch-File $manifest '</application>' $receivers 'ScheduledNotificationReceiver'

Write-Host '2/4 Removing obsolete files...'
$old = Join-Path $root 'lib/feat/notification/data/notification_content.dart'
if (Test-Path $old) {
  Remove-Item $old -Force
  Write-Host '  removed: lib/feat/notification/data/notification_content.dart'
} else {
  Write-Host '  nothing to remove'
}

if ($failed.Count -gt 0) {
  Write-Host ''
  Write-Warning 'Some edits could not be applied. Send me this list:'
  foreach ($item in $failed) { Write-Warning "  $item" }
  exit 1
}

if ($SkipTools) {
  Write-Host '3/4 and 4/4 skipped (-SkipTools).'
  exit 0
}

Write-Host '3/4 Adding packages...'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Warning 'flutter was not found in PATH. Run these manually:'
  Write-Host '  flutter pub add drift drift_flutter uuid path_provider flutter_local_notifications timezone flutter_timezone firebase_core firebase_messaging'
  Write-Host '  flutter pub add dev:drift_dev'
  Write-Host '  dart run build_runner build --delete-conflicting-outputs'
  exit 1
}
flutter pub add drift drift_flutter uuid path_provider flutter_local_notifications timezone flutter_timezone firebase_core firebase_messaging
if ($LASTEXITCODE -ne 0) { throw 'flutter pub add failed' }
flutter pub add dev:drift_dev
if ($LASTEXITCODE -ne 0) { throw 'flutter pub add dev:drift_dev failed' }

Write-Host '4/4 Generating code (build_runner)...'
dart run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) { throw 'build_runner failed' }

Write-Host ''
Write-Host 'Done. Next: flutter analyze, then run the app (a full stop and run, not hot reload).'
