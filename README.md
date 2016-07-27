paulosuzart/sdkman
---------------

**former [paulosuzart/gvm](https://forge.puppetlabs.com/paulosuzart/gvm)**

Module can be used to install [Sdkman](http://sdkman.io) and manage its available packages;

Usage
-----

````puppet
    class { 'sdkman' :
      owner   => 'someuser',
      group   => 'g_someuser',
      homedir => '/apps/someuser', #optional
    }
````

   - `owner` is the user name that will own the installation. From it the home of the user is assumed to be `/home/$owner`, or `/root` if the provided user is `root`. Defaults to `root`.
   - `group` is the group name of the owner.  Defaults to `$owner`.
   - `homedir` is the home directory of the owner.  This can be omitted if the home directory is `/root` or `/home/$owner`.

To install packages simply do:

````puppet
  sdkman::package { 'grails':
    version    => '2.1.5',
    is_default => true,
    ensure     => present #default
  }
````

   - `version` will make `sdkman::package` to install the given version of the package
   - `is_default` will make this package as default if you want to install many versions

To remove packages use the extra argument `package_name` (defaults to `name`) like this:

````puppet
  sdkman::package { 'remove grails 2.0.1':
    package_name => 'grails',
    version   => '2.0.1',
    ensure    => absent,
  }
````

The `package_name` is also useful for multiple versions of a given package.

*It is required `Package['unzip']` declared somewhere in your manifests.*

Use sdkman::package_hash to install using Hiera databinding. For example
```
sdkman::package_hash:
  'groovy': { version: '2.4.5' }

```

Limitations
-----------
Tested and mostly built to run with Ubuntu/Debian.


Release Notes
-------------

Notes for release 1.0.2
  - Merged [PR](https://github.com/paulosuzart/sdkman/pull/3) from [af6140](https://github.com/af6140)
  - Some lint

Notes for release 1.0.1

  - Added a package_hash for adding packages by using Hiera databinding

Notes for release 1.0.0

  - Fully refactored to support sdkman

For further details regarding contribution to old `gvm` module, please refer to that project.
