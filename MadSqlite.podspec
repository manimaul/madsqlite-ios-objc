#
# Be sure to run `pod lib lint MadSqlite.podspec' to ensure this is a
# valid spec before submitting. https://guides.cocoapods.org/making/getting-setup-with-trunk ->  'pod trunk push MadSqlite.podspec'
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                   = 'MadSqlite'
  s.version                = '0.2.3'

  s.summary                = 'A simple Sqlite Abstraction'
  s.description            = 'A simple Sqlite Abstraction with FTS5 and R*Tree enabled'
  s.homepage               = 'https://github.com/manimaul/madsqlite-ios-objc'
  s.license                = { :type => 'BSD', :file => 'LICENSE.md' }
  s.author                 = { 'William Kamp' => 'manimaul@gmail.com' }
  #s.documentation_url      = ''

  s.source                 = { :git => 'https://github.com/manimaul/madsqlite-ios-objc.git', :tag => s.version.to_s, :submodules => true }

  s.ios.deployment_target  = '8.0'
  s.source_files           = 'MadSqlite/Classes/**/*.{h,m,hh,mm}',
			     'madsqlite-core/src/main/cpp/*.{hpp}',
			     'madsqlite-core/src/main/cpp/api/*.{hpp}',
			     'madsqlite-core/src/main/cpp/MadContentValuesImpl.cpp',
			     'madsqlite-core/src/main/cpp/MadQueryImpl.cpp',
			     'madsqlite-core/src/main/cpp/MadDatabaseImpl.cpp',
			     'madsqlite-core/src/main/cpp/sqlite-amalgamation/sqlite3.c',
			     'madsqlite-core/src/main/cpp/sqlite-amalgamation/sqlite3.h'

  s.private_header_files   = 'madsqlite-core/src/main/cpp/*.{hpp}',
                             'madsqlite-core/src/main/cpp/api/*.{hpp}',
                             'MadSqlite/Classes/**/*Impl.{hh}',
                             'madsqlite-core/src/main/cpp/sqlite-amalgamation-3140200/sqlite3.h'

  s.requires_arc           = true

  s.library                = 'c++'
  s.xcconfig               = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++14',
       'CLANG_CXX_LIBRARY' => 'libc++',
       'OTHER_CFLAGS' => '-DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_RTREE'
  }

end
