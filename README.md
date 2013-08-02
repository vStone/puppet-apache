# Usage

See the module documentation on top of apache::params and apache::vhost for
more information on how to use this module. Each class should be pretty well
documented.

You can find online (generated) documentation here:
[http://jenkins.vstone.eu/job/puppet-apache/Puppet_Docs/](http://jenkins.vstone.eu/job/puppet-apache/Puppet_Docs/)

## Example:

```puppet

  # We do not want puppet to restart the service.
  class {'apache::params':
    notify_service => false,
  }

  # Basic apache setup.
  class {'apache': }

  # So we will be using php.
  class {'apache::mod::php': }

  # We will have some ssl vhosts.
  apache::listen {'443':}
  apache::namevhost {'443': }

  # Vhost example with the 2 rewrite rules.
  apache::vhost {'myvhost.example.com':
    mods => {
      'rewrite' => [
        { rewrite_cond => 'foo', rewrite_rule  => 'bar', },
        { rewrite_cond => 'fooo', rewrite_rule => 'baaar', },
      ],
    }
  }


```

# Requirements

* augeas &gt;= 0.9.0

## Debian

* libaugeas0 &gt;= 0.9.0
* augeas-lenses &gt;= 0.9.0
* libaugeas-ruby &gt;= 0.3.0

You can find up-to-date packages in squeeze-backports.


# Release Notes:

## Upgrade to 0.9

If you are upgrading from a version earlier than 0.9, you no longer have to
specify `apache::listen{'80': }` and `apache::namevhost{'80':}`. These 2 are
now created by default. You can disable this behaviour by specifying

```puppet
class {'apache':
  defaults => false,
}
```


# Notes:

You MUST define the apache::params class before importing apache if you want
to use anything besides the default parameter settings. This is due to the
parsing of the manifests. When you import apache, the apache::params module
will be included because most things require apache::params.


# Bugs

If you run into bugs or would like to request a new feature (pull requests
are also welcome... if you dare touch the code), please use the repository
located here: https://github.com/vStone/puppet-apache/

# Todo

* Proper debian style configuration. For now, I have not have enought time to test this.
* Tests...
