# == Define: sdk
#
# Setup sdkman

# === Parameters
#
# [*owner*]
# The user that owns the package. If homedir is not specified, this is used to infer where to install Sdkman:
# /home/$owner/.sdkman or /root if user is root
#
# [*group*]
# The group that owns the package.  Defaults to be the same as $owner, if unspecified.
#
# [*homedir*]
# The owner's home directory.  This can be omitted if the home directory is /root or /home/$owner
#
# [*package_hash*]
# A hash containing all packages to be installed by using hiera databinding

class sdkman (
    $owner        = 'root',
    $group        = '',
    $homedir      = '',
    $java_home    = '',
    $sh           = '/bin/bash',
    $package_hash = {}
) {

    validate_hash($package_hash)

    $user_group = $group ? {
      ''      => $owner,
      default => $group
    }

    $user_home = $homedir ? {
      ''      => $owner ? {
        'root'  =>  '/root',
        default => "/home/$owner"
      },
      default => $homedir
    }

    $home_env = "HOME=$user_home"
    $base_env = $java_home ? {
        ''      => [$home_env],
        default => [$home_env, "JAVA_HOME=$java_home"]
    }

    wget::fetch {'http://get.sdkman.io':
      destination => '/tmp/sdkman-install.sh',
      verbose     => true,
      execuser    => $owner,
      user        => $owner,
    } ~>
    exec { 'Install Sdkman' :
      user        => $owner,
      environment => $base_env,
      path        => '/usr/bin:/usr/sbin:/bin',
      command     => "$sh sdkman-install.sh",
      cwd         => '/tmp',
      logoutput   => true,
      unless      => 'test -e $HOME/.sdkman',
      require     => Package['unzip'],
    } ~>
    file {"$user_home/.sdkman/etc/config" :
      ensure => file,
      owner  => $owner,
      group  => $user_group,
      source => 'puppet:///modules/sdkman/sdkman_config'
    }

    include sdkman::packages
}
