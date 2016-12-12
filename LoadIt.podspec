Pod::Spec.new do |spec|
  spec.name         = 'LoadIt'
  spec.version      = '0.2.0'
  spec.license      = { :type => 'MIT', :text => <<-LICENSE
    The MIT License (MIT)
    Copyright (c) 2016 Luciano Marisi
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  LICENSE
  }
  spec.homepage     = 'https://github.com/lucianomarisi/LoadIt'
  spec.authors      = { 'Luciano Marisi' => 'luciano@techbrewers.com' }
  spec.summary      = 'Define resources in protocols and load them using a generic service and operation'
  spec.source           = {
    :git => "https://github.com/lucianomarisi/LoadIt.git",
    :tag => spec.version.to_s
  }
  spec.source_files = 'Sources/LoadIt/**/*.swift'
  spec.ios.deployment_target = '8.0'
  spec.deprecated_in_favor_of = 'TABResourceLoader'
end
