# Class: jenkins::jobs
#
class sdkman::packages {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  create_resources('sdkman::package',$::sdkman::package_hash)

}
