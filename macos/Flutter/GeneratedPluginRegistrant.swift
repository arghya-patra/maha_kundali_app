//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import agora_rtc_engine
import file_selector_macos
import iris_method_channel
import path_provider_foundation
import shared_preferences_foundation
import sqflite
import video_player_avfoundation

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AgoraRtcNgPlugin.register(with: registry.registrar(forPlugin: "AgoraRtcNgPlugin"))
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  IrisMethodChannelPlugin.register(with: registry.registrar(forPlugin: "IrisMethodChannelPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  FVPVideoPlayerPlugin.register(with: registry.registrar(forPlugin: "FVPVideoPlayerPlugin"))
}
