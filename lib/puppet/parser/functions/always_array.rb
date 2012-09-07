Puppet::Parser::Functions::newfunction(
  :always_array,
  :type => :rvalue,
  :doc => '
Makes sure the value is always an array, unless its nil.

If the argument is a hash, we will create an array where each element
is the key value separated with a space.

'
) do |args|

  value = args

  if value.is_a?(Array)
    return value
  elsif value.is_a?(Hash)
    return value.map{ |k,v| "#{k} #{v}" }
  elsif value.is_a?(String)
    return [value]
  else
    return []
  end

end
