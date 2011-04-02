BIN = File.expand_path('../gen_bridge_metadata.rb', __FILE__)
ROOT = '/Developer-Xcode4/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.3.sdk'

#cmd = "#{BIN} -d -f #{ROOT}/System/Library/Frameworks/AssetsLibrary.framework -o ../iOS/AssetsLibrary.bridgesupport"
cmd = "#{BIN} -d -f #{ROOT}/System/Library/Frameworks/AddressBook.framework -o ../iOS/AddressBook.bridgesupport"
puts cmd
exec cmd
