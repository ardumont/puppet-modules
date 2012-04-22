class nodejs::install {

  # define local vars
  $username = "$nodejs::params::username"
  $group = "$nodejs::params::group"
  $repository_path = "$nodejs::params::repository_path"
  $upstart_template_path = "/var/cache/opdemand/upstart/$nodejs::params::app_name"
  
  # define package names
  $nodejs_package = "nodejs"
  $npm_package = "npm"
  
  # install base nodejs packages
  $packages = [ $nodejs_package, $npm_package ]
  package { $packages:
    ensure => present,
  }
  
  # npm install
  exec { "npm::install":
    command => "sudo -u $username npm install",
    cwd => $repository_path,
    path => ["/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    user => $username,
    group => $group,
    require => Package[$npm_package],
    subscribe => Vcsrepo[$repository_path],
  }

  # create define for upstart template installation
  define upstart_template () {
    file { "/var/cache/opdemand/$name":
      source => "puppet:///modules/nodejs/$name",
    }
  }
  
  # install upstart templates
  $templates = [ "master.conf.erb", "process_master.conf.erb", "process.conf.erb"]
  upstart_template { $templates: }
  
}
