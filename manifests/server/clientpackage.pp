class mysql::server::clientpackage inherits mysql::server::base {
    include mysql::client
    File['mysql_root_cnf']{
        require +> Package['mysql-client'],
    }
    Exec['mysql_set_rootpw']{
        require +> Package['mysql-client'],
    }
}
