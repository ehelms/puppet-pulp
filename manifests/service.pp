# Pulp Master Service
class pulp::service {
	if $pulp::container {
		file { '/usr/lib/systemd/system/pulp_workers.service':
			ensure  => file,
			content => template('pulp/pulp_workers.service.erb'),
			mode    => '0644',
			owner   => 'root',
			group   => 'root',
			before	=> Service['pulp_workers'],
		}
		file { '/usr/lib/systemd/system/pulp_resource_manager.service':
			ensure  => file,
			content => template('pulp/pulp_resource_manager.service.erb'),
			mode    => '0644',
			owner   => 'root',
			group   => 'root',
			before	=> Service['pulp_resource_manager'],
		}
		file { '/usr/lib/systemd/system/pulp_celerybeat.service':
			ensure  => file,
			content => template('pulp/pulp_celerybeat.service.erb'),
			mode    => '0644',
			owner   => 'root',
			group   => 'root',
			before	=> Service['pulp_celerybeat'],
		}
		file { '/usr/lib/systemd/system/pulp.service':
			ensure  => file,
			content => template('pulp/pulp.service.erb'),
			mode    => '0644',
			owner   => 'root',
			group   => 'root',
			before	=> Service['pulp'],
		}
    service { ['pulp']:
      ensure => running,
      enable => true,
    }
	}

	exec { 'pulp refresh system service':
		command     => '/bin/systemctl daemon-reload',
		refreshonly => true,
	} ->
	service { ['pulp_celerybeat', 'pulp_workers', 'pulp_resource_manager', 'pulp_streamer']:
		ensure => running,
		enable => true,
	}
}
