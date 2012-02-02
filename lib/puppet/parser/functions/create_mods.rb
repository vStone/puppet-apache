Puppet::Parser::Functions::newfunction(:create_mods, :doc => '


') do |args|
  raise ArgumentError, ("create_mods(): wrong number of arguments(#{args.length}; must be 3)") if args.length != 3

  ## What we get
  #
  #  name: name of the vhost in question
  #  mods:
  #   'mod_type' => {mod_parameters}
  #
  #  defaults: parameters copied from vhost definition (ip, port, vhost)
  #
  ## what we need:
  #
  # for each mod defined:
  #
  #   type:       the type of the mod we want
  #   resource:
  #   <name_mod> => {
  #     parameters....
  #   }
  #

  Puppet::Parser::Functions.autoloader.load(:create_resources) unless Puppet::Parser::Functions.autoloader.loaded?(:create_resources)

  name = args[0].downcase
  mods = args[1]
  defaults = args[2]

  raise ArgumentError, ("create_mods(): the second argument should be a hash (#{mods.class} must be Hash)") unless mods.is_a?(Hash)
  raise ArgumentError, ("create_mods(): the third argument should be a hash (#{defaults.class} must be Hash)") unless defaults.is_a?(Hash)

  mods.each do |type, mod|
    defmerge = defaults.dup
    if type =~ /::/
      deftype = type
      type = type.gsub(/::/, '_')
    else
      deftype = "apache::vhost::mod::#{type}"
    end
    if mod.is_a?(Array)
      ### We will need to do some magic on the naming here, appending an index or sth.
      index = 0
      mod.each do |xmod|
        params = defmerge.merge(xmod)
        function_create_resources(deftype, {"#{name}_mod_#{type}_#{index}" => params })
      end
    else
      params = defmerge.merge(mod)
      function_create_resources(deftype, { "#{name}_mod_#{type}" => params })
    end

  end

end
