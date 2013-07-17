Puppet::Parser::Functions::newfunction(
  :render_allow_deny,
  :type => :rvalue,
  :doc => '
Makes sure the value is always an array, unless its nil.

If the argument is a hash, we will create an array where each element
is the key value separated with a space.
'
) do |args|

  if args.empty? or args.size < 3 or args.size > 4
    raise Puppet::ParseError, 'You must supply 3 arguments (+ optional indent)'
  end
  order = args.shift
  allow_from = [ args.shift ].flatten.reject {|v| v.nil? || v.lstrip == '' }
  deny_from = [ args.shift ].flatten.reject { |v| v.nil? || v.lstrip == '' }
  indent = args.shift || 4
  i = " " * indent

  result = []
  result << "#{i}Order #{order}"
  unless allow_from.empty?
    result << "#{i}Allow from #{allow_from.join(' ')}"
  end
  unless deny_from.empty?
    result << "#{i}Deny from #{deny_from.join(' ')}"
  end

  result.join("\n")

end
