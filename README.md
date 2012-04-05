# Usage

    class {'apache::params':
    }
    import apache
    # The order is important here!


    apache::vhost {'my_virtual_host':

    }

# Notes:

You MUST define the apache::params class before importing apache if you want
to use anything besides the default parameter settings. This is due to the
parsing of the manifests. When you import apache, the apache::params module
will be included because most things require apache::params.
