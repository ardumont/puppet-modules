class rabbitmq::config {
  
  require rabbitmq::params
  
  file {"/etc/rabbitmq/rabbitmq-env.conf":
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("rabbitmq/rabbitmq-env.config.erb"),
    require => Class[Rabbitmq::Install],
  }

}
