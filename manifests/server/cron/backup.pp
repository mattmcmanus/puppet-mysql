class mysql::server::cron::backup {

    $real_mysql_backup_dir = $mysql_backup_dir ? {
        '' => '/var/backups/mysql',
        default => $mysql_backup_dir,
    }
    
    $mysql_cleanup_after = $mysql_cleanup_after ? {
        '' => false,
        default => $mysql_cleanup_after,
    }
    
    $mysql_backup_s3 = $mysql_backup_s3 ? {
        '' => false,
        default => $mysql_backup_s3,
    }

    case $mysql_manage_backup_dir {
      false: { info("We don't manage \$mysql_backup_dir ($mysql_backup_dir)") }
      default: {
        file { 'mysql_backup_dir':
          path => $real_mysql_backup_dir,
          ensure => directory,
          before => Cron['mysql_backup_cron'],
          owner => root, group => 0, mode => 0700;
        }
      }
    }
    
    file {
      "db-backup.sh":
        path => "/root/scripts/db-backup.sh",
        content  => template("mysql/db-backup.sh.erb"),
        require => File["root/scripts"],
        owner => root, group => 0, mode => 0500,
        ensure => present;
    }
    
    cron { 'mysql_backup_cron':
      command => "/bin/sh /root/scripts/db-backup.sh",
      user => 'root',
      minute => 30,
      hour => 1,
      require => [ File['db-backup.sh'] ],
    }
   
}
