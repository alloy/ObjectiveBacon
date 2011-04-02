BIN = File.expand_path('../gen_bridge_metadata.rb', __FILE__)
ROOT = '/Developer-Xcode4/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.2.sdk'

#cmd = "#{BIN} -d -c '-framework Foundation -framework IMCore' -f #{ROOT}/System/Library/Frameworks/AssetsLibrary.framework -o ../iOS/AssetsLibrary.bridgesupport"
cmd = "#{BIN} -d -c '-framework Foundation' -f #{ROOT}/System/Library/Frameworks/AddressBook.framework -o ../iOS/AddressBook.bridgesupport"
puts cmd
exec cmd
