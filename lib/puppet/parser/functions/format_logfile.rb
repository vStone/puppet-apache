Puppet::Parser::Functions::newfunction(
  :format_logfile,
  :type => :rvalue,
  :doc => '
  Render the log filename from the given template.

'
) do |args|

  unless args.length == 2
    raise Puppet::ParseError, "format_logfile(): wrong number of arguments (#{args.length}; must be 2)"
  end

  unless args[1].is_a?(Hash)
    raise Puppet::ParseError, "format_logfile(): expects the second argument to be a hash, got #{args[1].inspect} which is of type #{args[1].class}"
  end
  values = args[1]

  unless args[0].is_a?(String)
    raise Puppet::ParseError, "format_logfile(): expects the first argument to be a string, got #{args[0].inspect} which is of type #{args[0].class}"
  end
  format = args[0]

  # loop over the values to replace.
  values.each do |key,value|
    re = Regexp.new("(^|[^%])%(#{key})")
    format = format.gsub(re, "\\1#{value}")
  end

  format

end
