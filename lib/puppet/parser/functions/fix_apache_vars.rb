Puppet::Parser::Functions::newfunction(
  :fix_apache_vars,
  :type => :rvalue,
  :doc => '
  Replace %[style] references in data to %{style} references.

  This is a workaround since hiera does not handle the normal
  escape procedure very well. %%{style} would result in an empty
  string. Bugs.. you gotta love them.
  '
) do |args|
  if args.empty?
    raise Puppet::ParseError, 'You must supply 3 arguments (+ optional indent)'
  end
  str = args.shift
  str.gsub(/(%+)\[([^\]]+)\]/) do |match|
    # $1 = '%' in front
    # $2 = between []

    # we always remove one % except if there is only one
    pre = '%' * [ ($1.count('%') - 1), 1 ].max
    # if we have a even number, we do not replace. thats escaped ;)
    if $1.count('%').even?
      "#{pre}[#{$2}]"
    else
      "#{pre}{#{$2}}"
    end
  end

 # str.gsub(/([^%]|^)%(?!%)\[([^\]]+)\]/, '\1%{\2}')

end
