<?php
define( 'DB_NAME', getenv('MYSQL_DB') );
define( 'DB_USER', getenv('MYSQL_USER') );
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define('AUTH_KEY',         '7C<{Kxz[eBA].j_r7{m|6ui(#_Kb`d8887_`g1UN%~[02p&[.}b!=F4]*!d[tzjI');
define('SECURE_AUTH_KEY',  '2r-R49Meh2c||sHL: ]+zba.RQBq&Z`q_Um?P+yFAJ_BFF0s!.gsX# D)$-=|m~=');
define('LOGGED_IN_KEY',    'tpmsA<M:<,::cC/C$$hqm+Tsjq<W:l2,Z]5i1;+v;|W{Pcp+)e?k.nrt+0|g _Qj');
define('NONCE_KEY',        ' V)+[HqVT:xm5++jH]+k7f1J HUxdX2QK VL#l&6E3S@P|i@)8w/F2,QOsJ+2o5m');
define('AUTH_SALT',        'uY|nH6>>(R[GP=qSE.{ng;c/h!(%a|3M.):g}iZ&HvQ9w)H8Mu]rq*fY:@:;J[0b');
define('SECURE_AUTH_SALT', '^uLa-0F@va(+~dcxiFT saTl  +<^Rfhdf!=!A!n8[zH=r$Ej3ML.6~~JW}oYrBU');
define('LOGGED_IN_SALT',   'Y}G;~a<D6]@V+;+Z .H:@h3}~[X x=Mm| > .`d:aS.{3|KK(JY6Jm^i+a7wmp45');
define('NONCE_SALT',       'YoJ3-%nQave_}!F86|gnv} #vGf(3ZNS]@&ucr~bB<|L|N|}P.X;v+F9sP*Vrr9r');
$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

