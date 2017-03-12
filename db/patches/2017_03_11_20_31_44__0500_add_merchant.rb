require_relative './setup'

r.table('merchants').insert([{ 'created_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00',
                               'id'         => 'sho',
                               'name'       => 'shoeme',
                               'updated_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00'
                             }, {
                               'created_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00',
                               'id'         => 'get',
                               'name'       => 'getoutside',
                               'updated_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00'
                             }, {
                               'created_at' => 'Sat Mar 11 2017 20:35:12 GMT+00:00',
                               'id'         => 'sse',
                               'name'       => 'ssense',
                               'updated_at' => 'Sat Mar 11 2017 20:35:12 GMT+00:00'
                             }, {
                               'created_at'  => 'Sat Mar 11 2017 20:35:13 GMT+00:00',
                               'id'          => 'zar',
                               'name'        => 'zara',
                               'updated_at': 'Sat Mar 11 2017 20:35:13 GMT+00:00'
                             }]).run(conn)

