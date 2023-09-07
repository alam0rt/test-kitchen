$gem list --no-versions | grep "^busser" 2>&1 >/dev/null
if test $? -ne 0; then
  echo "-----> Installing Busser ($version)"
  $gem install $gem_install_args
else
  echo "-----> Busser installation detected ($version)"
fi

if test ! -f "$BUSSER_ROOT/bin/busser"; then
  $busser setup
fi

for plugin in $plugins; do
  $gem list --no-versions | grep "^$plugin$" 2>&1 >/dev/null
  if test $? -ne 0; then
    echo "-----> Installing Busser plugin the hacky way: $plugin"
    $gem install specific_install
    $gem specific_install https://github.com/test-kitchen/busser-serverspec.git
    $gem install 'rspec-core'
    $gem install 'rake'
    $gem install 'busser'
    $gem list
  elif test $? -ne 0; then
    echo "-----> Installing Busser plugin: $plugin"
    $busser plugin install $plugin
  else
    echo "-----> Busser plugin detected: $plugin"
  fi
done
