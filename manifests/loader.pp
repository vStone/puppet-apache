define apache::loader(
  $type = 'apache::vhost',
) {

  $tree = hiera_hash($type, {})
  create_resources($type, $tree)

}
