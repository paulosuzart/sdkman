# == Define: sdkman::package
#
# Manages Sdkman packages. Installing or removing them.

# === Parameters
#
#
# [*is_version*]
#
# Informe if version should be set as default by sdkman
#
# [*version*]
# The version of package itself
#
# [*name*]
# Name of the given package being managed. If not present, title is used.
#

define sdkman::package (
  $version,
  $package_name = $name,
  $is_default   = false,
  $ensure       = present,
  $timeout      = 0 # disabled by default instead of 300 seconds defined by Puppet
) {

  $sdkman_init = "source $sdkman::user_home/.sdkman/bin/sdkman-init.sh"

  $sdkman_operation_unless = $ensure ? {
    present => "test -d $sdkman::user_home/.sdkman/candidates/$package_name/$version",
    absent  => "[ ! -d $sdkman::user_home/.sdkman/candidates/$package_name/$version ]",
  }

  $sdkman_operation = $ensure ? {
    present => "install",
    absent  => "rm"
  }

  exec { "sdk $sdkman_operation $package_name $version" :
    environment => $sdkman::base_env,
    command      => "su -c '$sdkman_init && sdk $sdkman_operation $package_name $version' - ${::sdkman::owner}",
    unless       => $sdkman_operation_unless,
    user         => 'root',
    require      => Class['sdkman'],
    path         => "/usr/bin:/usr/sbin:/bin",
    logoutput    => true,
    timeout      => $timeout
  }

  if $ensure == present and $is_default {
    exec {"sdk default $package_name $version" :
      environment => $sdkman::base_env,
      command     => "su -c '$sdkman_init && sdk default $package_name $version' -${::sdkman::owner}",
      user        => 'root',
      path        => '/usr/bin:/usr/sbin:/bin',
      logoutput   => true,
      require     => Exec["sdk install $package_name $version"],
      unless      => "test \"$version\" = \$(find ${sdkman::user_home}/.sdkman/candidates/${package_name} -type l -printf '%p -> %l\\n'| awk '{print \$3}' | awk -F'/' '{print \$NF}')",
      timeout     => $timeout
    }
  }

}
