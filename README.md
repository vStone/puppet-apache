# Usage

    class {'apache::params':
    }
    import apache
    # The order is important here!


    apache::vhost {'my_virtual_host':

    }

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
