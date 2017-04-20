<?php
return [
    'gate_host' => 'localhost:8889',
    'terminal_url' => 'http://localhost:8888/', //'http://ecogate.tools/terminal',
    'rabbitmq' => [
        'host' => 'localhost',
        'port' => '5673',
        'password' => 'rabbit',
        'login' => 'rabbit'
    ],
    'db_processing' => [
        'host' => '172.17.0.1',
        'port' => '3307', // todo сейчас порт игнорируется, возможно нужно доработать
        'dbName' => 'Processing',
        'user' => 'writer',
        'password' => '123456',
    ],
    'db_transaction' => [
        'host' => '172.17.0.1',
        'port' => '3307', //3307
        'dbName' => 'Shard00',
        'user' => 'writer',
        'password' => '123456',
    ],
    'kafkaBrokers' => '172.17.0.1:19092,172.17.0.1:19093,172.17.0.1:19094',
    'zookeeper_list' => [
        'zk1' => '172.17.0.1:12181',
    ], //to do conf for kafka with different ports
    'memcached' => [
        'servers' => [
            [
                'host' => 'localhost',
                'port' => '11212',
            ],
        ],
    ],

    ];