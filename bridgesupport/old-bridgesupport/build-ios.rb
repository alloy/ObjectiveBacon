BIN = File.expand_path('../gen_bridge_metadata.rb', __FILE__)
ROOT = '/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.2.sdk'

cmd = "#{BIN} -d -f #{ROOT}/System/Library/Frameworks/AssetsLibrary.framework -o AssetsLibrary.bridgesupport"
puts cmd
exec cmd
