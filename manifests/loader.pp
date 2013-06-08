define apache::loader(
  $type = 'apache::vhost',
) {

  $tree = hiera_hash($title, {})
  create_resources($type, $tree)

}
