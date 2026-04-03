<?php
/**
MySQL Settings - you can get this information from your web hosting company.
*/
define('DB_HOST',     getenv('MYSQL_HOST')     ?: 'localhost');
define('DB_USER',     getenv('MYSQL_USER')     ?: 'ultiorganizer');
define('DB_PASSWORD', getenv('MYSQL_PASSWORD') ?: 'ultiorganizer');
define('DB_DATABASE', getenv('MYSQL_DATABASE') ?: 'ultiorganizer');

/**
Server Defaults.
*/
define('BASEURL',           getenv('UO_BASEURL')         ?: 'http://localhost/ultiorganizer');
define('UPLOAD_DIR',        getenv('UO_UPLOAD_DIR')      ?: 'images/uploads/');
define('CUSTOMIZATIONS',    getenv('UO_CUSTOMIZATIONS')  ?: 'default');
define('DATE_FORMAT',       _("%d.%m.%Y %H:%M"));
define('WORD_DELIMITER',    '/([\;\,\-_\s\/\.])/');
define('UO_SESSION_NAME',   getenv('UO_SESSION_NAME')    ?: 'UO-Local');
define('HIDE_TIME',         getenv('UO_HIDE_TIME')       === 'true');
define('PRINT_SPIRIT_SHEETS', getenv('UO_PRINT_SPIRIT_SHEETS') === 'true');
define('DEFAULT_TIMEZONE',  getenv('UO_TIMEZONE')        ?: 'Europe/Lisbon');
